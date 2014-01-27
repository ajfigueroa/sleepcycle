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

@property (nonatomic, readonly) NSDate *alarmTime;
@property (nonatomic, strong) NSString *alarmAlertBody;
@property (nonatomic, weak) id <AlarmNotificationSchedulerDelegate> delegate;

- (void)createAlarmNotificationForDate:(NSDate *)alarmTime;

@end

// Protocol Definition
@protocol AlarmNotificationSchedulerDelegate <NSObject>

@optional
- (void)alarmNotificationDidPostNotification:(AlarmNotificationScheduler *)alarmScheduler;
- (void)alarmNotificationSchedulerDidFailPost:(AlarmNotificationScheduler *)alarmScheduler;

@end
