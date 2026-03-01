import { ApiProperty } from '@nestjs/swagger';

export class HealthErrorResponseDto {
  @ApiProperty({ example: 503, description: 'HTTP status code' })
  statusCode: number;

  @ApiProperty({
    example: 'Database connection failed',
    description: 'Error message',
  })
  message: string;

  @ApiProperty({ example: 'Service Unavailable' })
  error: string;
}

export class HealthErrorResponseDto2 {
  @ApiProperty({ example: 404, description: 'HTTP status code' })
  statusCode: number;

  @ApiProperty({
    example: 'Route not found',
    description: 'Error message',
  })
  message: string;

  @ApiProperty({ example: 'Error message' })
  error: string;
}

export class ErrorResponseDto {
  @ApiProperty()
  statusCode: number;

  @ApiProperty()
  message: string;

  @ApiProperty()
  error: string;
}
