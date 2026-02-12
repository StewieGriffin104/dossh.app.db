/*
  Warnings:

  - You are about to drop the column `isActive` on the `accounts` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "accounts" DROP COLUMN "isActive",
ADD COLUMN     "isKYCVerified" BOOLEAN NOT NULL DEFAULT true;
