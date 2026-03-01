import { ServiceUnavailableException } from '@nestjs/common';
import { HealthController } from '../health.controller';
import { HealthService } from '../health.service';

describe('HealthController', () => {
  let controller: HealthController;
  let healthService: HealthService;

  beforeEach(() => {
    healthService = {
      isDatabaseHealthy: jest.fn(),
    } as unknown as HealthService;

    controller = new HealthController(healthService);
  });

  it('should return ok when service is healthy', async () => {
    (healthService.isDatabaseHealthy as jest.Mock).mockResolvedValue(true);

    const result = await controller.check();

    expect(result.status).toBe('ok');
    expect(result.timestamp).toBeDefined();
  });

  it('should throw ServiceUnavailableException when database fails', async () => {
    (healthService.isDatabaseHealthy as jest.Mock).mockResolvedValue(false);

    await expect(controller.check()).rejects.toThrow(ServiceUnavailableException);
  });
});
