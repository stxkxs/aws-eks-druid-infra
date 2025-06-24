package io.stxkxs.eks.stack;

import io.stxkxs.eks.stack.nested.DruidNestedStack;
import io.stxkxs.execute.aws.eks.EksNestedStack;
import io.stxkxs.execute.aws.vpc.NetworkNestedStack;
import lombok.Getter;
import software.amazon.awscdk.NestedStackProps;
import software.amazon.awscdk.Stack;
import software.amazon.awscdk.StackProps;
import software.constructs.Construct;

import static io.stxkxs.execute.serialization.Format.describe;

@Getter
public class DeploymentStack extends Stack {
  private final NetworkNestedStack network;
  private final EksNestedStack eks;
  private final DruidNestedStack druid;

  public DeploymentStack(Construct scope, DeploymentConf conf, StackProps props) {
    super(scope, "eks.platform", props);

    this.network = new NetworkNestedStack(this, conf.common(), conf.vpc(),
      NestedStackProps.builder()
        .description(describe(conf.common(), "eks::network"))
        .build());

    this.eks = new EksNestedStack(this, conf.common(), conf.eks(), this.network().vpc(),
      NestedStackProps.builder()
        .description(describe(conf.common(), "eks::cluster"))
        .build());

    this.druid = new DruidNestedStack(this, conf.common(), conf.druid(), this.network().vpc(), this.eks().cluster(),
      NestedStackProps.builder()
        .description(describe(conf.common(), "eks::druid"))
        .build());
  }
}
