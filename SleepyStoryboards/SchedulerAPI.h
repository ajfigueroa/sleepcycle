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

+ (instancetype)sharedScheduler;

- (void)createAlarmNotificationForDate:(NSDate *)alarmTime;
- (void)createReminderForDate:(NSDate *)reminderTime;

@end
