//
//  SchedulerAPI.h
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/26/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SchedulerAPI : NSObject

// The date/time that was selected in the TimeSelection datePicker
@property (nonatomic, strong) NSDate *selectedTime;
// The window on which you want to display. weak since we do NOT own it.
@property (nonatomic, weak) UIWindow *parentWindow;

+ (instancetype)sharedScheduler;

- (void)createAlarmNotificationForDate:(NSDate *)alarmDate;
- (void)createReminderForDate:(NSDate *)reminderDate;

@end
