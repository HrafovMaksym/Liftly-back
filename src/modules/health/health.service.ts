import { Injectable } from '@nestjs/common';
import prisma from '../../database/prisma.js';

@Injectable()
export class HealthService {
  async isDatabaseHealthy(): Promise<boolean> {
    try {
      await prisma.$queryRaw`SELECT 1`;
      return true;
    } catch {
      return false;
    }
  }
}
