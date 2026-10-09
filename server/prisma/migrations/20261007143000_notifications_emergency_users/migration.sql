CREATE TYPE "SmsStatus" AS ENUM ('QUEUED','SENDING','SENT','DELIVERED','FAILED');
CREATE TYPE "EmergencyTaskStatus" AS ENUM ('OPEN','ACKNOWLEDGED','IN_PROGRESS','COMPLETED','CANCELLED');
CREATE TYPE "EmergencyTaskPriority" AS ENUM ('LOW','NORMAL','HIGH','CRITICAL');

CREATE TABLE "SmsMessage" (
  "id" TEXT NOT NULL,
  "patientId" TEXT,
  "phone" TEXT NOT NULL,
  "message" TEXT NOT NULL,
  "category" TEXT NOT NULL,
  "status" "SmsStatus" NOT NULL DEFAULT 'QUEUED',
  "providerMessageId" TEXT,
  "errorMessage" TEXT,
  "sentAt" TIMESTAMP(3),
  "deliveredAt" TIMESTAMP(3),
  "createdById" TEXT,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) NOT NULL,
  CONSTRAINT "SmsMessage_pkey" PRIMARY KEY ("id")
);
CREATE INDEX "SmsMessage_createdAt_idx" ON "SmsMessage"("createdAt");
CREATE INDEX "SmsMessage_patientId_idx" ON "SmsMessage"("patientId");

CREATE TABLE "EmergencyTask" (
  "id" TEXT NOT NULL,
  "taskNumber" TEXT NOT NULL,
  "patientId" TEXT,
  "encounterId" TEXT,
  "assignedToId" TEXT NOT NULL,
  "createdById" TEXT NOT NULL,
  "title" TEXT NOT NULL,
  "instructions" TEXT,
  "priority" "EmergencyTaskPriority" NOT NULL DEFAULT 'NORMAL',
  "status" "EmergencyTaskStatus" NOT NULL DEFAULT 'OPEN',
  "dueAt" TIMESTAMP(3),
  "acknowledgedAt" TIMESTAMP(3),
  "completedAt" TIMESTAMP(3),
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) NOT NULL,
  CONSTRAINT "EmergencyTask_pkey" PRIMARY KEY ("id")
);
CREATE UNIQUE INDEX "EmergencyTask_taskNumber_key" ON "EmergencyTask"("taskNumber");
CREATE INDEX "EmergencyTask_assignedToId_status_idx" ON "EmergencyTask"("assignedToId","status");
CREATE INDEX "EmergencyTask_patientId_createdAt_idx" ON "EmergencyTask"("patientId","createdAt");

ALTER TABLE "SmsMessage" ADD CONSTRAINT "SmsMessage_patientId_fkey" FOREIGN KEY ("patientId") REFERENCES "Patient"("id") ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE "SmsMessage" ADD CONSTRAINT "SmsMessage_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE "EmergencyTask" ADD CONSTRAINT "EmergencyTask_patientId_fkey" FOREIGN KEY ("patientId") REFERENCES "Patient"("id") ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE "EmergencyTask" ADD CONSTRAINT "EmergencyTask_encounterId_fkey" FOREIGN KEY ("encounterId") REFERENCES "Encounter"("id") ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE "EmergencyTask" ADD CONSTRAINT "EmergencyTask_assignedToId_fkey" FOREIGN KEY ("assignedToId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "EmergencyTask" ADD CONSTRAINT "EmergencyTask_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
