//
//  AlarmNotificationScheduler.h
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/26/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AlarmNotificationSchedulerDelegate;

@interface AlarmNotificationScheduler : NSObject

/**
 @brief The time to trigger the alarm notification.
 */
@property (nonatomic, readonly) NSDate *alarmTime;

/**
 @brief The body to attach to the alarm notification.
 */
@property (nonatomic, strong) NSString *alarmAlertBody;

/**
 @brief The delegate object to receive updates on the status of setting an alarm notification.
 */
@property (nonatomic, weak) id <AlarmNotificationSchedulerDelegate> delegate;

- (void)createAlarmNotificationForDate:(NSDate *)alarmTime;

@end

/**
 The delegate of the AlarmNotificationScheduler must adhere to this protocol. The optional
 methods provide updates on the status of the alarm notification posting.
 */
@protocol AlarmNotificationSchedulerDelegate <NSObject>

@optional
- (void)alarmNotificationDidPostNotification:(AlarmNotificationScheduler *)alarmScheduler;
- (void)alarmNotificationSchedulerDidFailPost:(AlarmNotificationScheduler *)alarmScheduler;

@end
