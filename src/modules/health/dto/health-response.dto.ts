import { ApiProperty } from '@nestjs/swagger';

export class HealthResponseDto {
  @ApiProperty({ example: 'ok', description: 'Service status' })
  status: string;

  @ApiProperty({ example: '2026-03-01T12:00:00.000Z', description: 'Server timestamp' })
  timestamp: string;
}
