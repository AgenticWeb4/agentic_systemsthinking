import { writable } from 'svelte/store';

export type NotificationType = 'info' | 'success' | 'warning' | 'error';

export interface Notification {
  id: string;
  type: NotificationType;
  title: string;
  message: string;
  timestamp: Date;
  duration?: number; // 自动消失时间（毫秒），undefined表示不自动消失
  actions?: NotificationAction[];
}

export interface NotificationAction {
  label: string;
  action: () => void;
  variant?: 'primary' | 'secondary' | 'danger';
}

// 创建通知store
export const notifications = writable<Notification[]>([]);

// 显示通知
export function showNotification(
  type: NotificationType,
  title: string,
  message: string,
  duration?: number,
  actions?: NotificationAction[]
): string {
  const id = generateId();
  const notification: Notification = {
    id,
    type,
    title,
    message,
    timestamp: new Date(),
    duration,
    actions
  };
  
  notifications.update(current => [...current, notification]);
  
  // 如果设置了自动消失时间，则自动移除通知
  if (duration && duration > 0) {
    setTimeout(() => {
      removeNotification(id);
    }, duration);
  }
  
  return id;
}

// 移除通知
export function removeNotification(id: string): void {
  notifications.update(current => current.filter(n => n.id !== id));
}

// 清除所有通知
export function clearAllNotifications(): void {
  notifications.set([]);
}

// 清除特定类型的通知
export function clearNotificationsByType(type: NotificationType): void {
  notifications.update(current => current.filter(n => n.type !== type));
}

// 生成唯一ID
function generateId(): string {
  return Date.now().toString(36) + Math.random().toString(36).substr(2);
}

// 预定义的快捷方法
export const notify = {
  info: (title: string, message: string, duration = 5000) => 
    showNotification('info', title, message, duration),
  
  success: (title: string, message: string, duration = 3000) => 
    showNotification('success', title, message, duration),
  
  warning: (title: string, message: string, duration = 7000) => 
    showNotification('warning', title, message, duration),
  
  error: (title: string, message: string, duration?: number) => 
    showNotification('error', title, message, duration),
  
  // 带操作的通知
  withActions: (
    type: NotificationType,
    title: string,
    message: string,
    actions: NotificationAction[],
    duration?: number
  ) => showNotification(type, title, message, duration, actions)
};
