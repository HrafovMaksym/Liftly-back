import { Module } from '@nestjs/common';
import { WorkoutsModule } from '../modules/workouts/workouts.module.js';

@Module({
  imports: [WorkoutsModule],
  controllers: [],
  providers: [],
})
export class AppModule {}
