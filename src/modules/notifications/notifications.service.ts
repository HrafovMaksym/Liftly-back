import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import prisma from '../../database/prisma.js';
import { QueryNotificationsInput } from './dto/query-notifications.dto.js';

const NOTIFICATION_SELECT = {
  id: true,
  type: true,
  title: true,
  body: true,
  readAt: true,
  createdAt: true,
} as const;

@Injectable()
export class NotificationsService {
  private readonly logger = new Logger(NotificationsService.name);

  async findAll(userId: string, query: QueryNotificationsInput) {
    const limit = query.limit ?? 20;

    const notifications = await prisma.notification.findMany({
      where: { userId },
      orderBy: { createdAt: 'desc' },
      take: limit + 1,
      ...(query.cursor
        ? { cursor: { id: query.cursor }, skip: 1 }
        : {}),
      select: NOTIFICATION_SELECT,
    });

    const hasMore = notifications.length > limit;
    const items = notifications.slice(0, limit);
    const nextCursor = hasMore ? items[items.length - 1]?.id : null;

    this.logger.debug(`Fetched ${items.length} notifications for user ${userId}`);

    return {
      data: items,
      meta: { pagination: { nextCursor, hasMore } },
    };
  }

  async markAsRead(userId: string, notificationId: string) {
    const notification = await prisma.notification.findUnique({
      where: { id: notificationId },
      select: { id: true, userId: true },
    });

    if (!notification || notification.userId !== userId) {
      throw new NotFoundException('Notification not found');
    }

    const updated = await prisma.notification.update({
      where: { id: notificationId },
      data: { readAt: new Date() },
      select: NOTIFICATION_SELECT,
    });

    this.logger.debug(`Marked notification ${notificationId} as read`);

    return updated;
  }

  async deleteAll(userId: string): Promise<void> {
    const { count } = await prisma.notification.deleteMany({
      where: { userId },
    });

    this.logger.debug(`Deleted ${count} notifications for user ${userId}`);
  }
}
