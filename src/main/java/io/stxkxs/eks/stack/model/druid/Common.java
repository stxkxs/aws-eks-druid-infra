package io.stxkxs.eks.stack.model.druid;

public record Common(
  String env,
  String jvmConf,
  String log4jConf,
  String metricConf,
  String runtimeProperties
) {}
