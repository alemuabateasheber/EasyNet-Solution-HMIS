CREATE TABLE "SystemSetting" (
  "id" TEXT NOT NULL,
  "singletonKey" TEXT NOT NULL DEFAULT 'default',
  "legalName" TEXT NOT NULL DEFAULT 'EasyNet Solution P.L.C.',
  "displayName" TEXT NOT NULL DEFAULT 'EasyNet HIS',
  "tagline" TEXT NOT NULL DEFAULT 'Smart Healthcare · Better Tomorrow',
  "logoUrl" TEXT,
  "logoData" TEXT,
  "faviconUrl" TEXT,
  "address" TEXT,
  "city" TEXT,
  "region" TEXT,
  "country" TEXT DEFAULT 'Ethiopia',
  "phone" TEXT,
  "email" TEXT,
  "website" TEXT,
  "emergencyPhone" TEXT,
  "taxId" TEXT,
  "licenseNumber" TEXT,
  "currency" TEXT NOT NULL DEFAULT 'ETB',
  "timezone" TEXT NOT NULL DEFAULT 'Africa/Addis_Ababa',
  "dateFormat" TEXT NOT NULL DEFAULT 'DD/MM/YYYY',
  "workingHours" TEXT,
  "receiptFooter" TEXT,
  "privacyNotice" TEXT,
  "termsText" TEXT,
  "aboutText" TEXT,
  "maintenanceMode" BOOLEAN NOT NULL DEFAULT false,
  "updatedAt" TIMESTAMP(3) NOT NULL,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT "SystemSetting_pkey" PRIMARY KEY ("id")
);
CREATE UNIQUE INDEX "SystemSetting_singletonKey_key" ON "SystemSetting"("singletonKey");
CREATE TABLE "ContentPage" (
  "id" TEXT NOT NULL,
  "slug" TEXT NOT NULL,
  "title" TEXT NOT NULL,
  "body" TEXT NOT NULL,
  "excerpt" TEXT,
  "seoTitle" TEXT,
  "seoDescription" TEXT,
  "published" BOOLEAN NOT NULL DEFAULT false,
  "publishedAt" TIMESTAMP(3),
  "createdById" TEXT,
  "updatedById" TEXT,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) NOT NULL,
  CONSTRAINT "ContentPage_pkey" PRIMARY KEY ("id")
);
CREATE UNIQUE INDEX "ContentPage_slug_key" ON "ContentPage"("slug");
CREATE INDEX "ContentPage_published_idx" ON "ContentPage"("published");
ALTER TABLE "ContentPage" ADD CONSTRAINT "ContentPage_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE "ContentPage" ADD CONSTRAINT "ContentPage_updatedById_fkey" FOREIGN KEY ("updatedById") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;
