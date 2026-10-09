CREATE TYPE "InsuranceScheme" AS ENUM ('CBHI','SHI','PRIVATE','EMPLOYER','OTHER');
CREATE TYPE "ClaimStatus" AS ENUM ('DRAFT','PREAUTH_REQUESTED','SUBMITTED','UNDER_REVIEW','APPROVED','PARTIALLY_APPROVED','REJECTED','PAID','RETURNED');
CREATE TYPE "PreauthorizationStatus" AS ENUM ('REQUESTED','APPROVED','PARTIALLY_APPROVED','REJECTED','EXPIRED','CANCELLED');

ALTER TABLE "InsuranceProvider" ADD COLUMN "email" TEXT;
ALTER TABLE "InsuranceProvider" ADD COLUMN "address" TEXT;
ALTER TABLE "InsuranceProvider" ADD COLUMN "scheme" "InsuranceScheme" NOT NULL DEFAULT 'OTHER';
ALTER TABLE "InsurancePolicy" ADD COLUMN "coverageLimit" DECIMAL(12,2);
ALTER TABLE "InsurancePolicy" ADD COLUMN "deductiblePercent" DECIMAL(5,2);
ALTER TABLE "InsurancePolicy" ADD COLUMN "benefitPackage" TEXT;

CREATE TABLE "Preauthorization" (
  "id" TEXT NOT NULL,
  "authorizationNumber" TEXT NOT NULL,
  "patientId" TEXT NOT NULL,
  "policyId" TEXT NOT NULL,
  "providerId" TEXT NOT NULL,
  "encounterId" TEXT,
  "requestedAmount" DECIMAL(12,2) NOT NULL,
  "approvedAmount" DECIMAL(12,2),
  "serviceDescription" TEXT NOT NULL,
  "diagnosisCode" TEXT,
  "procedureCode" TEXT,
  "status" "PreauthorizationStatus" NOT NULL DEFAULT 'REQUESTED',
  "requestedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "decidedAt" TIMESTAMP(3),
  "decisionNote" TEXT,
  CONSTRAINT "Preauthorization_pkey" PRIMARY KEY ("id"),
  CONSTRAINT "Preauthorization_authorizationNumber_key" UNIQUE ("authorizationNumber"),
  CONSTRAINT "Preauthorization_patientId_fkey" FOREIGN KEY ("patientId") REFERENCES "Patient"("id") ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT "Preauthorization_policyId_fkey" FOREIGN KEY ("policyId") REFERENCES "InsurancePolicy"("id") ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT "Preauthorization_providerId_fkey" FOREIGN KEY ("providerId") REFERENCES "InsuranceProvider"("id") ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT "Preauthorization_encounterId_fkey" FOREIGN KEY ("encounterId") REFERENCES "Encounter"("id") ON DELETE SET NULL ON UPDATE CASCADE
);
CREATE INDEX "Preauthorization_patientId_status_idx" ON "Preauthorization"("patientId","status");
CREATE INDEX "Preauthorization_policyId_status_idx" ON "Preauthorization"("policyId","status");

CREATE TABLE "Claim" (
  "id" TEXT NOT NULL,
  "claimNumber" TEXT NOT NULL,
  "patientId" TEXT NOT NULL,
  "policyId" TEXT NOT NULL,
  "providerId" TEXT NOT NULL,
  "invoiceId" TEXT,
  "preauthorizationId" TEXT,
  "encounterId" TEXT,
  "serviceFrom" TIMESTAMP(3) NOT NULL,
  "serviceTo" TIMESTAMP(3) NOT NULL,
  "diagnosisCodes" JSONB,
  "procedureCodes" JSONB,
  "totalAmount" DECIMAL(12,2) NOT NULL,
  "approvedAmount" DECIMAL(12,2),
  "patientResponsibility" DECIMAL(12,2),
  "status" "ClaimStatus" NOT NULL DEFAULT 'DRAFT',
  "submittedAt" TIMESTAMP(3),
  "decidedAt" TIMESTAMP(3),
  "paidAt" TIMESTAMP(3),
  "rejectionReason" TEXT,
  "notes" TEXT,
  CONSTRAINT "Claim_pkey" PRIMARY KEY ("id"),
  CONSTRAINT "Claim_claimNumber_key" UNIQUE ("claimNumber"),
  CONSTRAINT "Claim_patientId_fkey" FOREIGN KEY ("patientId") REFERENCES "Patient"("id") ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT "Claim_policyId_fkey" FOREIGN KEY ("policyId") REFERENCES "InsurancePolicy"("id") ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT "Claim_providerId_fkey" FOREIGN KEY ("providerId") REFERENCES "InsuranceProvider"("id") ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT "Claim_invoiceId_fkey" FOREIGN KEY ("invoiceId") REFERENCES "Invoice"("id") ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT "Claim_preauthorizationId_fkey" FOREIGN KEY ("preauthorizationId") REFERENCES "Preauthorization"("id") ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT "Claim_encounterId_fkey" FOREIGN KEY ("encounterId") REFERENCES "Encounter"("id") ON DELETE SET NULL ON UPDATE CASCADE
);
CREATE INDEX "Claim_patientId_status_idx" ON "Claim"("patientId","status");
CREATE INDEX "Claim_providerId_status_idx" ON "Claim"("providerId","status");
CREATE INDEX "Claim_serviceFrom_idx" ON "Claim"("serviceFrom");
