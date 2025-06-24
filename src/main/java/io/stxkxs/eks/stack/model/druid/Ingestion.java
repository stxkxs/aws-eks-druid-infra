package io.stxkxs.eks.stack.model.druid;

import io.stxkxs.model.aws.msk.Msk;

public record Ingestion(Msk kafka) {}
