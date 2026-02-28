import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class NotificationResponseDto {
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  id!: string;

  @ApiProperty({ example: 'WORKOUT_REMINDER' })
  type!: string;

  @ApiProperty({ example: 'Time to workout!' })
  title!: string;

  @ApiProperty({ example: 'Your scheduled workout starts in 10 minutes' })
  body!: string;

  @ApiPropertyOptional({ example: '2026-02-28T12:00:00.000Z', nullable: true })
  readAt!: Date | null;

  @ApiProperty({ example: '2026-02-28T12:00:00.000Z' })
  createdAt!: Date;
}
