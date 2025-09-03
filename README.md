# aws-eks

<div align="center">

*aws cdk application written in java that provisions an apache druid deployment on an amazon eks (elastic kubernetes
service) cluster with managed addons, custom helm charts, observability integration, and node groups.*

[![license: mit](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![java](https://img.shields.io/badge/Java-21%2B-blue.svg)](https://www.oracle.com/java/)
[![aws cdk](https://img.shields.io/badge/AWS%20CDK-latest-orange.svg)](https://aws.amazon.com/cdk/)
[![vpc](https://img.shields.io/badge/Amazon-VPC-ff9900.svg)](https://aws.amazon.com/vpc/)
[![eks](https://img.shields.io/badge/Amazon-EKS-ff9900.svg)](https://aws.amazon.com/eks/)
[![apache druid](https://img.shields.io/badge/Apache-Druid-008080.svg)](https://druid.apache.org/)
[![opentelemetry](https://img.shields.io/badge/OpenTelemetry-Enabled-blueviolet.svg)](https://opentelemetry.io/)
[![grafana](https://img.shields.io/badge/Grafana-Observability-F46800.svg)](https://grafana.com/)

</div>

## overview

+ eks cluster with rbac configuration
+ aws managed eks addons (vpc cni, ebs csi driver, coredns, kube proxy, pod identity agent, cloudwatch container
  insights)
+ helm chart-based addons (cert-manager, aws load balancer controller, karpenter, csi secrets store)
+ grafana cloud observability integration
+ managed node groups with bottlerocket ami's
+ sqs queue for node interruption handling
+ apache druid helm chart deployment integrated with aws resources:
    + rds database for metadata storage
    + s3 bucket for deep storage
    + s3 bucket for multi-stage query ingestion
    + kafka (msk) for real-time ingestion

## prerequisites

+ [java 21+](https://sdkman.io/)
+ [maven](https://maven.apache.org/download.cgi)
+ [aws cli](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
+ [aws cdk cli](https://docs.aws.amazon.com/cdk/v2/guide/getting-started.html)
+ [github cli](https://cli.github.com/)
+ [grafana cloud account](https://grafana.com/products/cloud/)
+ [common cdk repo](https://github.com/stxkxs/cdk-common) `gh repo clone stxkxs/cdk-common`
+ prepare aws environment by running `cdk bootstrap` with the appropriate aws account and region:

  ```bash
  cdk bootstrap aws://<account-id>/<region>
  ```

    + replace `<account-id>` with your aws account id and `<region>` with your desired aws region (e.g., `us-west-2`).
    + this command sets up the necessary resources for deploying cdk applications, such as an S3 bucket for storing
      assets and a CloudFormation execution role
    + for more information, see the aws cdk documentation:
        + https://docs.aws.amazon.com/cdk/v2/guide/bootstrapping.html
        + https://docs.aws.amazon.com/cdk/v2/guide/ref-cli-cmd-bootstrap.html

+ (optional) prepare apache druid helm chart and eks docker image:
    + docker image:
        + create an ecr repository named `stxkxs.io/v1/docker/druid` in your aws account
        + build and push the eks docker image to the ecr repository:
          ```bash
          aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <account-id>.dkr.ecr.<region>.amazonaws.com
          aws ecr create-repository \
            --repository-name stxkxs.io/v1/docker/druid \
            --region <region> \
            --image-scanning-configuration scanOnPush=true
          docker buildx build --provenance=false --platform linux/amd64 -f Dockerfile.druid \
            -t <account-id>.dkr.ecr.<region>.amazonaws.com/stxkxs.io/v1/docker/druid:$(date +'%Y%m%d') \
            -t <account-id>.dkr.ecr.<region>.amazonaws.com/stxkxs.io/v1/docker/druid:v1 \
            -t <account-id>.dkr.ecr.<region>.amazonaws.com/stxkxs.io/v1/docker/druid:latest \
            --push .
          ```
    + helm chart:
        + create an ecr repository named `stxkxs.io/v1/helm/druid` in your aws account
        + package and push the druid helm chart to the ecr repository:
          ```bash
          aws ecr get-login-password --region <region> | helm registry login --username AWS --password-stdin <account-id>.dkr.ecr.<region>.amazonaws.com
          aws ecr create-repository \
            --repository-name stxkxs.io/v1/helm/druid \
            --region <region> \
            --image-scanning-configuration scanOnPush=true \
            --encryption-configuration encryptionType=AES256
          helm package ./helm/chart/druid
          helm push druid-<version>.tgz oci://<account-id>.dkr.ecr.<region>.amazonaws.com/stxkxs.io/v1/helm/druid
          ```
    + update the docker image reference in the
      `aws-eks-druid-infra/src/main/resources/prototype/v1/druid/values.mustache` file
        + `image.repository` - ecr repository for the druid docker image (e.g.,
          `000000000000.dkr.ecr.us-west-2.amazonaws.com/stxkxs.io/v1/docker/druid`,
          `public.ecr.aws/q9l5h9b2/stxkxs.io/v1/docker/druid`)
        + `image.tag` - tag of the druid docker image (e.g., `v1`, `latest`, or a specific date tag like `20231001`)
        + `image.pullPolicy` - pull policy for the druid docker image (e.g., `IfNotPresent`)
    + update the helm chart reference in the `aws-eks-druid-infra/src/main/resources/prototype/v1/conf.mustache` file
        + `chart.repository` - ecr repository for the druid helm chart (e.g.,
          `000000000000.dkr.ecr.us-west-2.amazonaws.com/stxkxs.io/v1/helm/druid`,
          `oci://public.ecr.aws/q9l5h9b2/stxkxs.io/v1/helm/druid`)
        + `chart.name` - name of the druid helm chart (e.g., `druid`)
        + `chart.version` - version of the druid helm chart (e.g., `0.1.0`)

## deployment

1. build projects:
   ```bash
   mvn -f cdk-common/pom.xml clean install
   mvn -f aws-eks-druid-infra/pom.xml clean install
   ```

2. update configuration files:

    + create `aws-eks-druid-infra/cdk.context.json` from `aws-eks-druid-infra/cdk.context.template.json` with your
      aws account details
        + `:account` - aws account id
        + `:region` - aws region (e.g., `us-west-2`
        + `:domain` - registered domain name for ses (e.g., `stxkxs.io`)
        + `:environment` - this should not be changed unless you add a new set of resources to configure that
          environment
        + `:version` - version of the resources to deploy, this is used to differentiate between different versions of
          the resources
            + currently set to prototype/v1 for the resources at
              `aws-eks-druid-infra/src/main/resources/prototype/v1`

    + configure grafana cloud configurations
      ```json
      "hosted:eks:grafana:instanceId":"000000",
      "hosted:eks:grafana:key": "glc_xyz",
      "hosted:eks:grafana:lokiHost": "https://logs-prod-000.grafana.net",
      "hosted:eks:grafana:lokiUsername": "000000",
      "hosted:eks:grafana:prometheusHost": "https://prometheus-prod-000-prod-us-west-0.grafana.net",
      "hosted:eks:grafana:prometheusUsername":"0000000",
      "hosted:eks:grafana:tempoHost": "https://tempo-prod-000-prod-us-west-0.grafana.net/tempo",
      "hosted:eks:grafana:tempoUsername": "000000",
      "hosted:eks:grafana:pyroscopeHost": "https://profiles-prod-000.grafana.net:443",
      "hosted:eks:grafana:fleetManagementHost": "https://fleet-management-prod-000.grafana.net",
      ```

      these configuration values integrate your eks cluster with grafana cloud for comprehensive observability:

        1. **setting up grafana cloud**:
            - sign up for a grafana cloud account at https://grafana.com/
            - create a new stack
            - navigate to your stack settings

        2. **retrieving grafana cloud values**:
            - `instanceId`: Found in your Grafana Cloud stack details page. This is a unique identifier for your Grafana
              instance.
            - `key`: Create an API key with the following permissions in the "API Keys" section of your Grafana Cloud
              account. This key is used for authentication and should start with "glc_":
              
              **Required permissions:**
              - `metrics`: Read and Write access (for Prometheus metrics ingestion)
              - `logs`: Read and Write access (for Loki log ingestion)
              - `traces`: Read and Write access (for Tempo trace ingestion)
              - `profiles`: Read and Write access (for Pyroscope profiling data ingestion)
              - `alerts`: Read and Write access (for alerting configuration)
              - `rules`: Read and Write access (for recording and alerting rules)
              
              Note: While Grafana recommends using separate keys with minimal permissions for security, this 
              deployment requires write access to multiple services for the k8s-monitoring helm chart to function properly.
            - `lokiHost` and `lokiUsername`: In Grafana Cloud UI, navigate to Logs > Data Sources > Loki details. The
              lokiHost
              is the endpoint URL for sending logs, and the lokiUsername is your account identifier.
            - `prometheusHost` and `prometheusUsername`: In Grafana Cloud UI, navigate to Metrics > Data Sources >
              Prometheus
              details. Similar to Loki, these are endpoint and authentication details for metrics.
            - `tempoHost` and `tempoUsername`: In Grafana Cloud UI, navigate to Traces > Data Sources > Tempo details.
              These
              values configure the trace collection endpoint.
            - `pyroscopeHost`: In Grafana Cloud UI, navigate to Profiles > Connect a data source. This endpoint is used
              for
              continuous profiling.
            - `fleetManagementHost`: Available in your stack settings, this is used for managing agents.

      these values are used by the grafana kubernetes monitoring helm chart (k8s-monitoring) to configure the grafana
      agent
      properly for sending metrics, logs, and traces to your grafana cloud instance

    + cluster access configuration
        ```json
        {
          "hosted:eks:administrators": [
            {
              "username": "administrator",
              "role": "arn:aws:iam::000000000000:role/AWSReservedSSO_AdministratorAccess_abc",
              "email": "admin@aol.com"
            }
          ],
          "hosted:eks:users": [
            {
              "username": "user",
              "role": "arn:aws:iam::000000000000:role/AWSReservedSSO_DeveloperAccess_abc",
              "email": "user@aol.com"
            }  
          ]
        }
        ```

        + **administrators**: iam roles that will have full admin access to the cluster
        + **users**: iam roles that will have read-only access to the cluster
            + `username`: used for identifying the user in kubernetes rbac
            + `role`: aws iam role arn (typically from aws sso) that will be mapped to admin permissions through
              aws-auth configmap
            + `email`: for identification and traceability purposes

3. deploy eks infrastructure:
    ```bash
    cd aws-eks-druid-infra
    
    cdk synth
    cdk deploy
    ```

4. use it:
    ```bash
    aws eks update-kubeconfig --name {{hosted:id}}-eks --region us-west-2
   
    kubectl get nodes
    kubectl get pods -A
    ```

## license

[mit license](LICENSE)

for your convenience, you can find the full mit license text at

+ [https://opensource.org/license/mit/](https://opensource.org/license/mit/) (official osi website)
+ [https://choosealicense.com/licenses/mit/](https://choosealicense.com/licenses/mit/) (choose a license website)
