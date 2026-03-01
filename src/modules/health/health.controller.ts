import { Controller, Get, ServiceUnavailableException } from '@nestjs/common';
import {
  ApiBadRequestResponse,
  ApiNotFoundResponse,
  ApiOkResponse,
  ApiOperation,
  ApiServiceUnavailableResponse,
  ApiTags,
} from '@nestjs/swagger';
import { HealthResponseDto } from './dto/health-response.dto.js';
import {
  HealthErrorResponseDto,
  HealthErrorResponseDto2,
} from './dto/health-error-response.dto.js';
import prisma from '../../database/prisma.js';

@ApiTags('health')
@Controller('health')
export class HealthController {
  @Get()
  @ApiOperation({ summary: 'Health check' })
  @ApiOkResponse({ description: 'Service is healthy', type: HealthResponseDto })
  @ApiServiceUnavailableResponse({
    description: 'Database is unreachable',
    type: HealthErrorResponseDto,
  })
  @ApiNotFoundResponse({
    description: 'Route is not found',
    type: HealthErrorResponseDto2,
  })
  async check(): Promise<HealthResponseDto> {
    try {
      await prisma.$queryRaw`SELECT 1`;
    } catch {
      throw new ServiceUnavailableException('Database connection failed');
    }

    return {
      status: 'ok',
      timestamp: new Date().toISOString(),
    };
  }
}
