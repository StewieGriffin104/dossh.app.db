-- CreateEnum
CREATE TYPE "KYCStatus" AS ENUM ('NOT_STARTED', 'IN_PROGRESS', 'SUBMITTED', 'UNDER_REVIEW', 'APPROVED', 'REJECTED', 'RESUBMIT_REQUIRED');

-- CreateEnum
CREATE TYPE "KYCSection" AS ENUM ('PERSONAL_DETAILS', 'CONTACT_DETAILS', 'SOURCE_OF_FUNDS', 'PRIMARY_DOCUMENT', 'SECONDARY_DOCUMENT', 'BIOMETRICS');

-- CreateEnum
CREATE TYPE "Gender" AS ENUM ('MALE', 'FEMALE', 'NON_BINARY', 'PREFER_NOT_TO_SAY', 'OTHER');

-- CreateEnum
CREATE TYPE "MaritalStatus" AS ENUM ('SINGLE', 'MARRIED', 'DIVORCED', 'WIDOWED', 'SEPARATED', 'COMMON_LAW');

-- CreateEnum
CREATE TYPE "VisaStatus" AS ENUM ('AUSTRALIAN_CITIZEN', 'PERMANENT_RESIDENT', 'TEMPORARY_VISA', 'STUDENT_VISA', 'WORK_VISA', 'REFUGEE_VISA', 'OTHER');

-- CreateEnum
CREATE TYPE "DocumentType" AS ENUM ('DRIVERS_LICENCE', 'PASSPORT', 'NATIONAL_ID', 'BIRTH_CERTIFICATE', 'PROOF_OF_AGE_CARD', 'BANK_STATEMENT', 'UTILITY_BILL', 'GOVERNMENT_LETTER', 'OTHER');

-- CreateEnum
CREATE TYPE "IncomeRange" AS ENUM ('BELOW_30K', 'FROM_30K_TO_50K', 'FROM_50K_TO_80K', 'FROM_80K_TO_120K', 'FROM_120K_TO_200K', 'ABOVE_200K');

-- CreateEnum
CREATE TYPE "IncomeSource" AS ENUM ('SALARY', 'BUSINESS', 'INVESTMENT', 'PENSION', 'RENTAL', 'GOVERNMENT_BENEFITS', 'OTHER');

-- CreateEnum
CREATE TYPE "VerificationProvider" AS ENUM ('PROVIDER_A', 'PROVIDER_B');

-- CreateEnum
CREATE TYPE "VerificationStatus" AS ENUM ('PENDING', 'IN_PROGRESS', 'SUCCESS', 'FAILED', 'ERROR');

-- CreateEnum
CREATE TYPE "RejectionReason" AS ENUM ('DOCUMENT_EXPIRED', 'DOCUMENT_UNCLEAR', 'INFORMATION_MISMATCH', 'FRAUD_SUSPECTED', 'INCOMPLETE_INFORMATION', 'FAILED_BIOMETRIC_CHECK', 'FAILED_THIRD_PARTY_VERIFICATION', 'OTHER');

-- CreateEnum
CREATE TYPE "AddressType" AS ENUM ('BILLING', 'SHIPPING', 'RESIDENTIAL', 'BUSINESS');

-- AlterTable
ALTER TABLE "accounts" ADD COLUMN     "companyLogoS3Key" TEXT,
ADD COLUMN     "companyLogoUrl" TEXT,
ADD COLUMN     "currentSubmissionId" TEXT,
ADD COLUMN     "kycLevel" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "kycRejectedAt" TIMESTAMP(3),
ADD COLUMN     "kycStatus" "KYCStatus" NOT NULL DEFAULT 'NOT_STARTED',
ADD COLUMN     "kycVerifiedAt" TIMESTAMP(3),
ADD COLUMN     "profileImageS3Key" TEXT,
ADD COLUMN     "profileImageUrl" TEXT;

-- CreateTable
CREATE TABLE "addresses" (
    "id" TEXT NOT NULL,
    "accountId" TEXT NOT NULL,
    "type" "AddressType" NOT NULL DEFAULT 'BILLING',
    "isDefault" BOOLEAN NOT NULL DEFAULT false,
    "streetAddress" TEXT NOT NULL,
    "streetAddress2" TEXT,
    "city" TEXT NOT NULL,
    "state" TEXT NOT NULL,
    "postalCode" TEXT NOT NULL,
    "country" TEXT NOT NULL DEFAULT 'AU',
    "label" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "addresses_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "kyc_submissions" (
    "id" TEXT NOT NULL,
    "customerId" TEXT NOT NULL,
    "status" "KYCStatus" NOT NULL DEFAULT 'IN_PROGRESS',
    "submittedAt" TIMESTAMP(3),
    "reviewedAt" TIMESTAMP(3),
    "approvedAt" TIMESTAMP(3),
    "rejectedAt" TIMESTAMP(3),
    "rejectionReason" "RejectionReason",
    "rejectionDetails" TEXT,
    "completedSections" "KYCSection"[],
    "title" TEXT,
    "firstName" TEXT NOT NULL,
    "middleName" TEXT,
    "lastName" TEXT NOT NULL,
    "dateOfBirth" TIMESTAMP(3) NOT NULL,
    "gender" "Gender",
    "maritalStatus" "MaritalStatus",
    "visaStatus" "VisaStatus",
    "email" TEXT NOT NULL,
    "phone" TEXT NOT NULL,
    "streetAddress" TEXT,
    "city" TEXT,
    "state" TEXT,
    "postalCode" TEXT,
    "country" TEXT,
    "occupation" TEXT,
    "industryType" TEXT,
    "annualIncome" "IncomeRange",
    "incomeSources" "IncomeSource"[],
    "activities" TEXT[],
    "transactionCountries" TEXT[],
    "biometricConsentGiven" BOOLEAN NOT NULL DEFAULT false,
    "biometricConsentAt" TIMESTAMP(3),
    "submissionData" JSONB,
    "internalNotes" TEXT,
    "lastUpdated" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "kyc_submissions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "kyc_documents" (
    "id" TEXT NOT NULL,
    "submissionId" TEXT NOT NULL,
    "documentType" "DocumentType" NOT NULL,
    "documentPurpose" TEXT NOT NULL,
    "documentNumber" TEXT,
    "issuingCountry" TEXT,
    "expiryDate" TIMESTAMP(3),
    "s3Key" TEXT NOT NULL,
    "s3Bucket" TEXT,
    "fileUrl" TEXT NOT NULL,
    "originalPath" TEXT,
    "fileName" TEXT,
    "fileSize" INTEGER,
    "mimeType" TEXT,
    "imageSide" TEXT,
    "uploadedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "processedAt" TIMESTAMP(3),
    "verified" BOOLEAN NOT NULL DEFAULT false,
    "verifiedAt" TIMESTAMP(3),
    "additionalDetails" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "kyc_documents_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "kyc_verifications" (
    "id" TEXT NOT NULL,
    "submissionId" TEXT NOT NULL,
    "provider" "VerificationProvider" NOT NULL,
    "providerSessionId" TEXT,
    "verificationType" TEXT NOT NULL,
    "status" "VerificationStatus" NOT NULL DEFAULT 'PENDING',
    "score" DOUBLE PRECISION,
    "checksPassed" TEXT[],
    "checksFailed" TEXT[],
    "matchPercentage" DOUBLE PRECISION,
    "requestPayload" JSONB,
    "responseData" JSONB,
    "errorMessage" TEXT,
    "requestedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "completedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "kyc_verifications_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "addresses_accountId_idx" ON "addresses"("accountId");

-- CreateIndex
CREATE INDEX "addresses_type_idx" ON "addresses"("type");

-- CreateIndex
CREATE INDEX "addresses_isDefault_idx" ON "addresses"("isDefault");

-- CreateIndex
CREATE INDEX "kyc_submissions_customerId_idx" ON "kyc_submissions"("customerId");

-- CreateIndex
CREATE INDEX "kyc_submissions_status_idx" ON "kyc_submissions"("status");

-- CreateIndex
CREATE INDEX "kyc_submissions_submittedAt_idx" ON "kyc_submissions"("submittedAt");

-- CreateIndex
CREATE INDEX "kyc_submissions_approvedAt_idx" ON "kyc_submissions"("approvedAt");

-- CreateIndex
CREATE INDEX "kyc_documents_submissionId_idx" ON "kyc_documents"("submissionId");

-- CreateIndex
CREATE INDEX "kyc_documents_documentType_idx" ON "kyc_documents"("documentType");

-- CreateIndex
CREATE INDEX "kyc_documents_documentPurpose_idx" ON "kyc_documents"("documentPurpose");

-- CreateIndex
CREATE INDEX "kyc_documents_verified_idx" ON "kyc_documents"("verified");

-- CreateIndex
CREATE INDEX "kyc_verifications_submissionId_idx" ON "kyc_verifications"("submissionId");

-- CreateIndex
CREATE INDEX "kyc_verifications_provider_idx" ON "kyc_verifications"("provider");

-- CreateIndex
CREATE INDEX "kyc_verifications_status_idx" ON "kyc_verifications"("status");

-- CreateIndex
CREATE INDEX "kyc_verifications_verificationType_idx" ON "kyc_verifications"("verificationType");

-- CreateIndex
CREATE INDEX "accounts_isKYCVerified_idx" ON "accounts"("isKYCVerified");

-- CreateIndex
CREATE INDEX "accounts_kycStatus_idx" ON "accounts"("kycStatus");

-- AddForeignKey
ALTER TABLE "addresses" ADD CONSTRAINT "addresses_accountId_fkey" FOREIGN KEY ("accountId") REFERENCES "accounts"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "kyc_submissions" ADD CONSTRAINT "kyc_submissions_customerId_fkey" FOREIGN KEY ("customerId") REFERENCES "customers"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "kyc_documents" ADD CONSTRAINT "kyc_documents_submissionId_fkey" FOREIGN KEY ("submissionId") REFERENCES "kyc_submissions"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "kyc_verifications" ADD CONSTRAINT "kyc_verifications_submissionId_fkey" FOREIGN KEY ("submissionId") REFERENCES "kyc_submissions"("id") ON DELETE CASCADE ON UPDATE CASCADE;
