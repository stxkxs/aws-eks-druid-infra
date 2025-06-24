package io.stxkxs.eks.stack.model.druid;

import io.stxkxs.model.aws.secretsmanager.SecretCredentials;

public record Secrets(
  SecretCredentials admin,
  SecretCredentials system
) {}
