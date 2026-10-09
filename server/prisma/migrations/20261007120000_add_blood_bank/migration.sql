CREATE TABLE "BloodUnit" (
  "id" TEXT NOT NULL,
  "unitNumber" TEXT NOT NULL,
  "donorName" TEXT NOT NULL,
  "donorPhone" TEXT,
  "bloodGroup" TEXT NOT NULL,
  "component" TEXT NOT NULL DEFAULT 'WHOLE_BLOOD',
  "volumeMl" INTEGER NOT NULL DEFAULT 450,
  "collectedAt" TIMESTAMP(3) NOT NULL,
  "expiresAt" TIMESTAMP(3) NOT NULL,
  "status" TEXT NOT NULL DEFAULT 'AVAILABLE',
  "notes" TEXT,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) NOT NULL,
  CONSTRAINT "BloodUnit_pkey" PRIMARY KEY ("id")
);
CREATE UNIQUE INDEX "BloodUnit_unitNumber_key" ON "BloodUnit"("unitNumber");
CREATE INDEX "BloodUnit_bloodGroup_status_idx" ON "BloodUnit"("bloodGroup", "status");
CREATE INDEX "BloodUnit_expiresAt_idx" ON "BloodUnit"("expiresAt");
