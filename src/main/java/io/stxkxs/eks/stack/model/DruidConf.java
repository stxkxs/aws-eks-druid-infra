package io.stxkxs.eks.stack.model;

import io.stxkxs.model.aws.eks.HelmChart;

public record DruidConf(
  String access,
  String secrets,
  String storage,
  String ingestion,
  String asset,
  HelmChart chart
) {}
