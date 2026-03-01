import { z } from 'zod';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export const CreateWorkoutSchema = z.object({
  name: z.string().min(1).max(200).optional(),
  templateId: z.string().uuid().optional(),
  notes: z.string().max(1000).optional(),
});

export type CreateWorkoutInput = z.infer<typeof CreateWorkoutSchema>;

export class CreateWorkoutDto {
  @ApiPropertyOptional({ example: 'Push Day', minLength: 1, maxLength: 200 })
  name?: string;

  @ApiPropertyOptional({ type: String, format: 'uuid', description: 'Template to start workout from' })
  templateId?: string;

  @ApiPropertyOptional({ example: 'Feeling strong today', maxLength: 1000 })
  notes?: string;
}
