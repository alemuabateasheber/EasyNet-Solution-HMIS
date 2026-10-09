CREATE TABLE "PaymentRequest" (
  "id" TEXT NOT NULL,
  "requestNumber" TEXT NOT NULL,
  "invoiceId" TEXT NOT NULL,
  "provider" TEXT NOT NULL,
  "amount" DECIMAL(12,2) NOT NULL,
  "currency" TEXT NOT NULL DEFAULT 'ETB',
  "status" TEXT NOT NULL DEFAULT 'PENDING',
  "providerReference" TEXT,
  "qrPayload" TEXT,
  "qrImageUrl" TEXT,
  "expiresAt" TIMESTAMP(3),
  "confirmedAt" TIMESTAMP(3),
  "rawResponse" JSONB,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) NOT NULL,
  CONSTRAINT "PaymentRequest_pkey" PRIMARY KEY ("id")
);
CREATE UNIQUE INDEX "PaymentRequest_requestNumber_key" ON "PaymentRequest"("requestNumber");
CREATE UNIQUE INDEX "PaymentRequest_providerReference_key" ON "PaymentRequest"("providerReference");
CREATE INDEX "PaymentRequest_invoiceId_status_idx" ON "PaymentRequest"("invoiceId", "status");
CREATE INDEX "PaymentRequest_provider_status_idx" ON "PaymentRequest"("provider", "status");
ALTER TABLE "PaymentRequest" ADD CONSTRAINT "PaymentRequest_invoiceId_fkey" FOREIGN KEY ("invoiceId") REFERENCES "Invoice"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
