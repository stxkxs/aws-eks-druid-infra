package io.stxkxs.eks.stack.nested;


import io.stxkxs.eks.stack.model.DruidConf;
import io.stxkxs.eks.stack.model.druid.Access;
import io.stxkxs.eks.stack.model.druid.Ingestion;
import io.stxkxs.eks.stack.model.druid.Secrets;
import io.stxkxs.eks.stack.model.druid.Storage;
import io.stxkxs.execute.aws.eks.NamespaceConstruct;
import io.stxkxs.execute.aws.eks.ServiceAccountConstruct;
import io.stxkxs.execute.aws.iam.RoleConstruct;
import io.stxkxs.execute.aws.msk.MskConstruct;
import io.stxkxs.execute.aws.rds.RdsConstruct;
import io.stxkxs.execute.aws.s3.BucketConstruct;
import io.stxkxs.execute.aws.secretsmanager.SecretConstruct;
import io.stxkxs.execute.serialization.Mapper;
import io.stxkxs.execute.serialization.Template;
import io.stxkxs.model._main.Common;
import lombok.Getter;
import lombok.SneakyThrows;
import software.amazon.awscdk.NestedStack;
import software.amazon.awscdk.NestedStackProps;
import software.amazon.awscdk.services.ec2.Vpc;
import software.amazon.awscdk.services.eks.ICluster;
import software.amazon.awscdk.services.eks.ServiceAccount;
import software.amazon.awscdk.services.iam.IRole;
import software.amazon.awscdk.services.msk.CfnServerlessCluster;
import software.amazon.awscdk.services.s3.Bucket;
import software.amazon.awscdk.services.secretsmanager.Secret;
import software.constructs.Construct;

import java.util.List;
import java.util.Map;

import static io.stxkxs.execute.serialization.Format.id;


@Getter
public class DruidSetupNestedStack extends NestedStack {
  private final DruidAccessConstruct accessConstruct;
  private final DruidSecretsConstruct secretsConstruct;
  private final DruidStorageConstruct storageConstruct;
  private final DruidIngestionConstruct ingestConstruct;

  public DruidSetupNestedStack(Construct scope, Common common, DruidConf conf, Vpc vpc, ICluster cluster) {
    super(scope, id("druid.setup", conf.chart().release()), NestedStackProps.builder().build());

    this.accessConstruct = new DruidAccessConstruct(this, common, conf, cluster);
    this.secretsConstruct = new DruidSecretsConstruct(this, common, conf);
    this.storageConstruct = new DruidStorageConstruct(this, common, conf, vpc, cluster);
    this.ingestConstruct = new DruidIngestionConstruct(this, common, conf, vpc, cluster);

    this.storageConstruct().getNode().addDependency(this.accessConstruct());
  }

  @Getter
  static class DruidAccessConstruct extends Construct {
    private final IRole role;

    @SneakyThrows
    DruidAccessConstruct(Construct scope, Common common, DruidConf conf, ICluster cluster) {
      super(scope, "access");

      var replace = Map.<String, Object>of("hosted:eks:druid:release", conf.chart().release());
      var configuration = Mapper.get().readValue(Template.parse(scope, conf.access(), replace), Access.class);

      var oidc = cluster.getOpenIdConnectProvider();
      var principal = configuration.serviceAccount().role().principal().oidcPrincipal(this, oidc, configuration.serviceAccount());
      this.role = new RoleConstruct(this, common, principal, configuration.serviceAccount().role()).role();
    }
  }

  @Getter
  static class DruidSecretsConstruct extends Construct {
    private final Secret admin;
    private final Secret systemCredentials;

    @SneakyThrows
    DruidSecretsConstruct(Construct scope, Common common, DruidConf conf) {
      super(scope, "secrets");

      var replace = Map.<String, Object>of("hosted:eks:druid:release", conf.chart().release());
      var configuration = Mapper.get().readValue(Template.parse(scope, conf.secrets(), replace), Secrets.class);
      this.admin = new SecretConstruct(this, common, configuration.admin()).secret();
      this.systemCredentials = new SecretConstruct(this, common, configuration.system()).secret();
    }
  }

  @Getter
  static class DruidStorageConstruct extends Construct {
    private final RdsConstruct rdsConstruct;
    private final Bucket indexLogs;
    private final Bucket deepStorage;
    private final Bucket multiStageQueryBucket;

    @SneakyThrows
    DruidStorageConstruct(Construct scope, Common common, DruidConf conf, Vpc vpc, ICluster cluster) {
      super(scope, "storage");

      var replace = Map.<String, Object>of("hosted:eks:druid:release", conf.chart().release());
      var configuration = Mapper.get().readValue(Template.parse(scope, conf.storage(), replace), Storage.class);
      this.rdsConstruct = new RdsConstruct(this, common, configuration.metadata(), vpc, List.of(cluster.getClusterSecurityGroup()));
      this.deepStorage = new BucketConstruct(this, common, configuration.deepStorage()).bucket();
      this.indexLogs = new BucketConstruct(this, common, configuration.indexLogs()).bucket();
      this.multiStageQueryBucket = new BucketConstruct(this, common, configuration.multiStageQuery()).bucket();
    }
  }

  @Getter
  static class DruidIngestionConstruct extends Construct {
    private final CfnServerlessCluster msk;
    private final List<ServiceAccount> mskServiceAccounts;

    @SneakyThrows
    DruidIngestionConstruct(Construct scope, Common common, DruidConf conf, Vpc vpc, ICluster cluster) {
      super(scope, "ingestion");

      var replace = Map.<String, Object>of("hosted:eks:druid:release", conf.chart().release());
      var configuration = Mapper.get().readValue(Template.parse(scope, conf.ingestion(), replace), Ingestion.class);
      this.msk = new MskConstruct(this, common, configuration.kafka(), vpc, List.of(cluster.getClusterSecurityGroupId())).msk();
      this.mskServiceAccounts = configuration.kafka().clients().stream()
        .map(client -> {
          var namespace = new NamespaceConstruct(this, common, client.serviceAccount().metadata(), cluster);
          var serviceAccount = new ServiceAccountConstruct(this, common, client.serviceAccount(), cluster).serviceAccount();
          serviceAccount.getNode().addDependency(namespace.manifest());
          return serviceAccount;
        }).toList();
    }
  }
}
