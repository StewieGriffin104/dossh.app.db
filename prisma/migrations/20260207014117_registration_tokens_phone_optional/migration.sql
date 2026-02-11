/*
  Warnings:

  - A unique constraint covering the columns `[email,token]` on the table `registration_tokens` will be added. If there are existing duplicate values, this will fail.

*/
-- DropIndex
DROP INDEX "registration_tokens_phone_token_key";

-- AlterTable
ALTER TABLE "registration_tokens" ALTER COLUMN "phone" DROP NOT NULL;

-- CreateIndex
CREATE UNIQUE INDEX "registration_tokens_email_token_key" ON "registration_tokens"("email", "token");
