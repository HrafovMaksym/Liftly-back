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
import { HealthService } from './health.service.js';
import { Public } from '../../common/decorators/public.decorator.js';

@ApiTags('health')
@Controller('health')
export class HealthController {
  constructor(private readonly healthService: HealthService) {}

  @Public()
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
    const isHealthy = await this.healthService.isDatabaseHealthy();

    if (!isHealthy) {
      throw new ServiceUnavailableException('Database connection failed');
    }

    return {
      status: 'ok',
      timestamp: new Date().toISOString(),
    };
  }
}
