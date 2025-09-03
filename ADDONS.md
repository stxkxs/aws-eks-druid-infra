## addons

the eks cluster comes equipped with a comprehensive set of addons and features

### aws managed addons

| addon                  | purpose                                                                                                                                          |
|------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------|
| **vpc cni**            | provides networking for pods using amazon vpc networking. configures pod networking with aws iam role for service account.                       |
| **ebs csi driver**     | manages amazon ebs volumes for persistent storage. includes kms integration for volume encryption. creates a custom storage class as the default |
| **coredns**            | kubernetes cluster dns for service discovery. manages internal dns resolution within the cluster                                                 |
| **kube proxy**         | network proxy that maintains network rules on nodes. handles internal kubernetes networking for services                                         |
| **pod identity agent** | enables iam roles for service accounts (irsa). provides iam credentials to pods based on service account                                         |
| **container insights** | aws cloudwatch integration for container monitoring. collects metrics, logs, and traces for aws x-ray.                                           |

### helm chart/custom addons

| chart                            | namespace         | purpose                                                                                                                                                |
|----------------------------------|-------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------|
| **cert-manager**                 | cert-manager      | automates certificate management within kubernetes. handles tls certificate issuance and renewal                                                       |
| **csi secrets store**            | aws-secrets-store | interface between csi volume and secrets stores. allows mounting secrets, keys, and certs                                                              |
| **aws secrets store provider**   | aws-secrets-store | aws provider for csi secrets store. enables pods to access aws secrets manager and ssm parameter store                                                 |
| **karpenter**                    | kube-system       | advanced kubernetes autoscaler. manages node provisioning and termination. scales nodes based on pending pods. uses sqs for node interruption handling |
| **aws load balancer controller** | aws-load-balancer | manages aws elastic load balancers for kubernetes services. handles aws alb and nlb resources. provides support for ingress and service resources      |
| **alloy-operator**               | alloy-system      | grafana alloy operator for managing alloy instances. provides custom resources and crds required by k8s-monitoring chart v3+                           |
| **grafana k8s-monitoring**       | monitoring        | deploys grafana alloy agents for complete observability. collects metrics, logs, and traces. integrates with grafana cloud                             |
