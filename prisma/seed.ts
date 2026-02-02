import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Starting database seed...');

  // Create test device
  const testDevice = await prisma.devices.upsert({
    where: { id: 'test-device-123' },
    update: {},
    create: {
      id: 'test-device-123',
      deviceFingerprint: 'test-fingerprint-abc123',
      deviceName: 'Test Device',
      deviceType: 'desktop',
      os: 'Linux',
      osVersion: 'Ubuntu 22.04',
      ip: '127.0.0.1',
      isActive: true,
      lastUsedAt: new Date(),
    },
  });

  console.log('✅ Created test device:', testDevice.id);

  // Create additional test devices for different scenarios
  const devices = [
    {
      id: 'mobile-device-001',
      deviceFingerprint: 'mobile-fingerprint-001',
      deviceName: 'iPhone 14',
      deviceType: 'mobile',
      os: 'iOS',
      osVersion: '16.0',
      ip: '192.168.1.101',
    },
    {
      id: 'desktop-device-001',
      deviceFingerprint: 'desktop-fingerprint-001',
      deviceName: 'MacBook Pro',
      deviceType: 'desktop',
      os: 'macOS',
      osVersion: '10.15.7',
      ip: '192.168.1.102',
    },
  ];

  for (const device of devices) {
    await prisma.devices.upsert({
      where: { id: device.id },
      update: {},
      create: {
        ...device,
        isActive: true,
        lastUsedAt: new Date(),
      },
    });
    console.log('✅ Created device:', device.id);
  }

  console.log('🎉 Seed completed successfully!');
  console.log('\n📝 Test Device IDs:');
  console.log('  - test-device-123 (primary test device)');
  console.log('  - mobile-device-001 (mobile test)');
  console.log('  - desktop-device-001 (desktop test)');
  console.log('\n💡 You can now test registration with deviceId: "test-device-123"');
}

main()
  .then(async () => {
    await prisma.$disconnect();
  })
  .catch(async (e) => {
    console.error('❌ Seed failed:', e);
    await prisma.$disconnect();
    process.exit(1);
  });
