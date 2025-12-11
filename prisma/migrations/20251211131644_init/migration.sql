-- CreateEnum
CREATE TYPE "AccountType" AS ENUM ('EVERYDAY', 'CORPORATE');

-- CreateEnum
CREATE TYPE "BusinessType" AS ENUM ('BUSINESS_OWNER', 'TRUST_OWNER', 'EMPLOYEE');

-- CreateEnum
CREATE TYPE "PlanType" AS ENUM ('BASIC', 'STANDARD', 'PREMIUM');

-- CreateEnum
CREATE TYPE "Role" AS ENUM ('CUSTOMER', 'DEVELOPER', 'TESTING', 'MANAGER');

-- CreateTable
CREATE TABLE "devices" (
    "id" TEXT NOT NULL,
    "customerId" TEXT NOT NULL,
    "deviceName" TEXT,
    "deviceType" TEXT,
    "os" TEXT,
    "osVersion" TEXT,
    "deviceFingerprint" TEXT,
    "ip" TEXT,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "lastUsedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "devices_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "device_events" (
    "id" TEXT NOT NULL,
    "deviceId" TEXT NOT NULL,
    "eventType" TEXT NOT NULL,
    "eventMeta" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "device_events_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "customers" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "emailVerified" BOOLEAN NOT NULL DEFAULT false,
    "phone" TEXT,
    "phoneVerified" BOOLEAN NOT NULL DEFAULT false,
    "firstName" TEXT,
    "lastName" TEXT,
    "username" TEXT,
    "passwordHash" TEXT NOT NULL,
    "imageUrl" TEXT,
    "role" "Role" NOT NULL DEFAULT 'CUSTOMER',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "customers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "registration_tokens" (
    "id" TEXT NOT NULL,
    "email" TEXT,
    "phone" TEXT NOT NULL,
    "firstName" TEXT,
    "lastName" TEXT,
    "passwordHash" TEXT NOT NULL,
    "token" TEXT NOT NULL,
    "tokenHash" TEXT,
    "tokenType" TEXT NOT NULL DEFAULT 'sms',
    "ip" TEXT,
    "deviceFingerprint" TEXT,
    "attempts" INTEGER NOT NULL DEFAULT 0,
    "maxAttempts" INTEGER NOT NULL DEFAULT 5,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "verifiedAt" TIMESTAMP(3),
    "verifiedByUserId" TEXT,
    "status" TEXT NOT NULL DEFAULT 'pending',
    "meta" JSONB,
    "devicesId" TEXT,

    CONSTRAINT "registration_tokens_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "registration_attempts" (
    "id" TEXT NOT NULL,
    "phone" TEXT,
    "email" TEXT,
    "ip" TEXT,
    "deviceId" TEXT,
    "action" TEXT NOT NULL,
    "result" TEXT NOT NULL,
    "reason" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "devicesId" TEXT,

    CONSTRAINT "registration_attempts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "sms_events" (
    "id" TEXT NOT NULL,
    "phone" TEXT NOT NULL,
    "direction" TEXT NOT NULL DEFAULT 'outbound',
    "provider" TEXT,
    "providerId" TEXT,
    "status" TEXT NOT NULL,
    "statusCode" TEXT,
    "message" TEXT,
    "meta" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "devicesId" TEXT,

    CONSTRAINT "sms_events_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "blocks" (
    "id" TEXT NOT NULL,
    "scope" TEXT NOT NULL,
    "value" TEXT NOT NULL,
    "reason" TEXT,
    "source" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expiresAt" TIMESTAMP(3),
    "active" BOOLEAN NOT NULL DEFAULT true,
    "meta" JSONB,
    "devicesId" TEXT,

    CONSTRAINT "blocks_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "accounts" (
    "id" TEXT NOT NULL,
    "customerId" TEXT NOT NULL,
    "accountType" "AccountType" NOT NULL DEFAULT 'EVERYDAY',
    "businessType" "BusinessType",
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "planId" TEXT,
    "plan" "PlanType" NOT NULL DEFAULT 'BASIC',
    "planUpdatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "planStartAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "planEndAt" TIMESTAMP(3),
    "renewAt" TIMESTAMP(3),
    "canceledAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "accounts_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "devices_customerId_idx" ON "devices"("customerId");

-- CreateIndex
CREATE INDEX "devices_deviceFingerprint_idx" ON "devices"("deviceFingerprint");

-- CreateIndex
CREATE INDEX "devices_ip_idx" ON "devices"("ip");

-- CreateIndex
CREATE INDEX "devices_isActive_idx" ON "devices"("isActive");

-- CreateIndex
CREATE INDEX "device_events_deviceId_idx" ON "device_events"("deviceId");

-- CreateIndex
CREATE INDEX "device_events_eventType_idx" ON "device_events"("eventType");

-- CreateIndex
CREATE INDEX "device_events_createdAt_idx" ON "device_events"("createdAt");

-- CreateIndex
CREATE UNIQUE INDEX "customers_email_key" ON "customers"("email");

-- CreateIndex
CREATE UNIQUE INDEX "customers_phone_key" ON "customers"("phone");

-- CreateIndex
CREATE INDEX "customers_emailVerified_idx" ON "customers"("emailVerified");

-- CreateIndex
CREATE INDEX "customers_phoneVerified_idx" ON "customers"("phoneVerified");

-- CreateIndex
CREATE INDEX "customers_createdAt_idx" ON "customers"("createdAt");

-- CreateIndex
CREATE INDEX "registration_tokens_phone_idx" ON "registration_tokens"("phone");

-- CreateIndex
CREATE INDEX "registration_tokens_email_idx" ON "registration_tokens"("email");

-- CreateIndex
CREATE INDEX "registration_tokens_ip_idx" ON "registration_tokens"("ip");

-- CreateIndex
CREATE INDEX "registration_tokens_deviceFingerprint_idx" ON "registration_tokens"("deviceFingerprint");

-- CreateIndex
CREATE INDEX "registration_tokens_expiresAt_idx" ON "registration_tokens"("expiresAt");

-- CreateIndex
CREATE INDEX "registration_tokens_status_idx" ON "registration_tokens"("status");

-- CreateIndex
CREATE UNIQUE INDEX "registration_tokens_phone_token_key" ON "registration_tokens"("phone", "token");

-- CreateIndex
CREATE INDEX "registration_attempts_phone_idx" ON "registration_attempts"("phone");

-- CreateIndex
CREATE INDEX "registration_attempts_email_idx" ON "registration_attempts"("email");

-- CreateIndex
CREATE INDEX "registration_attempts_ip_idx" ON "registration_attempts"("ip");

-- CreateIndex
CREATE INDEX "registration_attempts_createdAt_idx" ON "registration_attempts"("createdAt");

-- CreateIndex
CREATE INDEX "sms_events_phone_idx" ON "sms_events"("phone");

-- CreateIndex
CREATE INDEX "sms_events_status_idx" ON "sms_events"("status");

-- CreateIndex
CREATE INDEX "sms_events_createdAt_idx" ON "sms_events"("createdAt");

-- CreateIndex
CREATE INDEX "blocks_scope_value_idx" ON "blocks"("scope", "value");

-- CreateIndex
CREATE INDEX "blocks_active_idx" ON "blocks"("active");

-- CreateIndex
CREATE INDEX "blocks_expiresAt_idx" ON "blocks"("expiresAt");

-- CreateIndex
CREATE UNIQUE INDEX "blocks_scope_value_key" ON "blocks"("scope", "value");

-- CreateIndex
CREATE UNIQUE INDEX "accounts_customerId_key" ON "accounts"("customerId");

-- CreateIndex
CREATE INDEX "accounts_accountType_idx" ON "accounts"("accountType");

-- CreateIndex
CREATE INDEX "accounts_businessType_idx" ON "accounts"("businessType");

-- AddForeignKey
ALTER TABLE "devices" ADD CONSTRAINT "devices_customerId_fkey" FOREIGN KEY ("customerId") REFERENCES "customers"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "device_events" ADD CONSTRAINT "device_events_deviceId_fkey" FOREIGN KEY ("deviceId") REFERENCES "devices"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "registration_tokens" ADD CONSTRAINT "registration_tokens_devicesId_fkey" FOREIGN KEY ("devicesId") REFERENCES "devices"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "registration_attempts" ADD CONSTRAINT "registration_attempts_devicesId_fkey" FOREIGN KEY ("devicesId") REFERENCES "devices"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "sms_events" ADD CONSTRAINT "sms_events_devicesId_fkey" FOREIGN KEY ("devicesId") REFERENCES "devices"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "blocks" ADD CONSTRAINT "blocks_devicesId_fkey" FOREIGN KEY ("devicesId") REFERENCES "devices"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "accounts" ADD CONSTRAINT "accounts_customerId_fkey" FOREIGN KEY ("customerId") REFERENCES "customers"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
