-- DropForeignKey
ALTER TABLE "devices" DROP CONSTRAINT "devices_customerId_fkey";

-- AlterTable
ALTER TABLE "devices" ALTER COLUMN "customerId" DROP NOT NULL;

-- AddForeignKey
ALTER TABLE "devices" ADD CONSTRAINT "devices_customerId_fkey" FOREIGN KEY ("customerId") REFERENCES "customers"("id") ON DELETE SET NULL ON UPDATE CASCADE;
