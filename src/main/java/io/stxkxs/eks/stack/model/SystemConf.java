package io.stxkxs.eks.stack.model;

import io.stxkxs.model._main.Common;
import io.stxkxs.model.aws.eks.KubernetesConf;
import io.stxkxs.model.aws.vpc.NetworkConf;

public record SystemConf(
  Common common,
  NetworkConf vpc,
  KubernetesConf eks,
  DruidConf druid
) {}
