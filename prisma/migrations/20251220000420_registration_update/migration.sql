/*
  Warnings:

  - You are about to drop the column `passwordHash` on the `registration_tokens` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "registration_tokens" DROP COLUMN "passwordHash";
