//
//  SchedulerAPI.h
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/26/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SchedulerAPI : NSObject

/**
 @brief The selected time that was the seed time that produced the scheduledTime. This
 is usually the time from the UIDatePicker when it was selected.
 */
@property (nonatomic, strong) NSDate *selectedTime;

/**
 @brief The time that is used to set the trigger time for both alarms and/or reminders.
 */
@property (nonatomic, readonly) NSDate *scheduledTime;

/**
 @brief Returns the shared scheduler instance used for setting up alarms and notification tasks.
 @returns The shared scheduler instance.
 */
+ (instancetype)sharedScheduler;

/**
 @brief Sets up a UILocalNotification alarm to trigger at the selectedTime property.
 @note This is the SchedulerAPI's interface of the AlarmNotificationScheduler's method with the same name.
 */
- (void)createAlarmNotificationForDatePickerSelectedTime;

/**
 @brief Sets up a UILocalNotification alarm to trigger at the alarmTime.
 @param alarmTime The date to set as the trigger for the UILocalNotification.
 @note This is the SchedulerAPI's interface of the AlarmNotificationScheduler's method with the same name.
 */
- (void)createAlarmNotificationForDate:(NSDate *)alarmTime;

/**
 @brief Sets up a reminder instance to trigger at the reminderTime.
 @param reminderTime The time to trigger the reminder at.
 @note This is the SchedulerAPI's interface of the ReminderScheduler's method with the same name.
 */
- (void)createReminderForDate:(NSDate *)reminderTime;

@end
