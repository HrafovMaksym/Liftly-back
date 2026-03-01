import { z } from 'zod';
import { ApiPropertyOptional } from '@nestjs/swagger';

export const QueryWorkoutsSchema = z.object({
  cursor: z.string().uuid().optional(),
  limit: z.coerce.number().int().min(1).max(50).default(20),
  status: z.enum(['IN_PROGRESS', 'COMPLETED', 'CANCELLED']).optional(),
});

export type QueryWorkoutsInput = z.infer<typeof QueryWorkoutsSchema>;

export class QueryWorkoutsDto {
  @ApiPropertyOptional({ type: String, format: 'uuid', description: 'Cursor ID for pagination' })
  cursor?: string;

  @ApiPropertyOptional({ type: Number, example: 20, minimum: 1, maximum: 50 })
  limit?: number;

  @ApiPropertyOptional({ enum: ['IN_PROGRESS', 'COMPLETED', 'CANCELLED'], description: 'Filter by status' })
  status?: string;
}
