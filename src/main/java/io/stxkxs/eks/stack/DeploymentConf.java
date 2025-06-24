package io.stxkxs.eks.stack;

import io.stxkxs.eks.stack.model.DruidConf;
import io.stxkxs.model._main.Common;
import io.stxkxs.model.aws.eks.KubernetesConf;
import io.stxkxs.model.aws.vpc.NetworkConf;

public record DeploymentConf(
  Common common,
  NetworkConf vpc,
  KubernetesConf eks,
  DruidConf druid
) {}
