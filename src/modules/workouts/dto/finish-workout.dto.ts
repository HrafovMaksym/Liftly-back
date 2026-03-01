import { z } from 'zod';
import { ApiPropertyOptional } from '@nestjs/swagger';

export const FinishWorkoutSchema = z.object({
  rating: z.number().int().min(1).max(5).optional(),
  perceivedEffort: z.number().int().min(1).max(10).optional(),
  notes: z.string().max(1000).optional(),
});

export type FinishWorkoutInput = z.infer<typeof FinishWorkoutSchema>;

export class FinishWorkoutDto {
  @ApiPropertyOptional({ example: 4, minimum: 1, maximum: 5, description: 'Workout rating (1-5)' })
  rating?: number;

  @ApiPropertyOptional({ example: 7, minimum: 1, maximum: 10, description: 'RPE for overall session (1-10)' })
  perceivedEffort?: number;

  @ApiPropertyOptional({ example: 'Great pump today', maxLength: 1000 })
  notes?: string;
}
