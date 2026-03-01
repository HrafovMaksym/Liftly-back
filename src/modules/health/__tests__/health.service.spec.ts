import { HealthService } from '../health.service';

jest.mock('../../../database/prisma', () => ({
  __esModule: true,
  default: {
    $queryRaw: jest.fn(),
  },
}));

import prisma from '../../../database/prisma';

describe('HealthService', () => {
  let service: HealthService;

  beforeEach(() => {
    service = new HealthService();
    jest.clearAllMocks();
  });

  it('should return true when database is healthy', async () => {
    (prisma.$queryRaw as jest.Mock).mockResolvedValue([{ '?column?': 1 }]);

    const result = await service.isDatabaseHealthy();

    expect(result).toBe(true);
    expect(prisma.$queryRaw).toHaveBeenCalled();
  });

  it('should return false when database is unreachable', async () => {
    (prisma.$queryRaw as jest.Mock).mockRejectedValue(new Error('Connection refused'));

    const result = await service.isDatabaseHealthy();

    expect(result).toBe(false);
  });
});
