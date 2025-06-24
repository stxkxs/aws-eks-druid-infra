package io.stxkxs.eks.stack.model.druid;

import io.stxkxs.model.aws.rds.Rds;
import io.stxkxs.model.aws.s3.S3Bucket;

public record Storage(
  Rds metadata,
  S3Bucket deepStorage,
  S3Bucket indexLogs,
  S3Bucket multiStageQuery
) {}
