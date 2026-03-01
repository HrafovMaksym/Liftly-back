import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class WorkoutResponseDto {
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  id!: string;

  @ApiProperty({ example: 'Push Day' })
  name!: string | null;

  @ApiPropertyOptional({ example: 'Great session', nullable: true })
  notes!: string | null;

  @ApiProperty({ example: 'IN_PROGRESS', enum: ['IN_PROGRESS', 'COMPLETED', 'CANCELLED'] })
  status!: string;

  @ApiProperty({ example: '2026-03-01T10:00:00.000Z' })
  startedAt!: Date;

  @ApiPropertyOptional({ example: '2026-03-01T11:30:00.000Z', nullable: true })
  finishedAt!: Date | null;

  @ApiPropertyOptional({ example: 5400, nullable: true, description: 'Duration in seconds' })
  durationSeconds!: number | null;

  @ApiPropertyOptional({ example: 12500.0, nullable: true, description: 'Total volume (weight x reps)' })
  totalVolume!: number | null;

  @ApiPropertyOptional({ example: 24, nullable: true })
  totalSets!: number | null;

  @ApiPropertyOptional({ example: 180, nullable: true })
  totalReps!: number | null;

  @ApiPropertyOptional({ example: 4, nullable: true, description: 'Rating 1-5' })
  rating!: number | null;

  @ApiProperty({ example: '2026-03-01T10:00:00.000Z' })
  createdAt!: Date;
}

export class WorkoutSummaryDto {
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  id!: string;

  @ApiPropertyOptional({ example: 'Push Day', nullable: true })
  name!: string | null;

  @ApiProperty({ example: 'COMPLETED', enum: ['IN_PROGRESS', 'COMPLETED', 'CANCELLED'] })
  status!: string;

  @ApiProperty({ example: '2026-03-01T10:00:00.000Z' })
  startedAt!: Date;

  @ApiPropertyOptional({ example: 5400, nullable: true })
  durationSeconds!: number | null;

  @ApiPropertyOptional({ example: 12500.0, nullable: true })
  totalVolume!: number | null;

  @ApiPropertyOptional({ example: 24, nullable: true })
  totalSets!: number | null;
}
