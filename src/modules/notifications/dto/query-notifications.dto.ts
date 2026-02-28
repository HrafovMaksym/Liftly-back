import { z } from 'zod';
import { ApiPropertyOptional } from '@nestjs/swagger';

export const QueryNotificationsSchema = z.object({
  cursor: z.string().uuid().optional(),
  limit: z.coerce.number().int().min(1).max(100).default(20),
});

export type QueryNotificationsInput = z.infer<typeof QueryNotificationsSchema>;

export class QueryNotificationsDto {
  @ApiPropertyOptional({ type: String, format: 'uuid', description: 'Cursor ID for pagination' })
  cursor?: string;

  @ApiPropertyOptional({ type: Number, example: 20, minimum: 1, maximum: 100, description: 'Items per page' })
  limit?: number;
}
