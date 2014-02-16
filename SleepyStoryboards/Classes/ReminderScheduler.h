//
//  ReminderScheduler.h
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/26/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ReminderSchedulerDelegate;

@interface ReminderScheduler : NSObject

/**
 @brief The time that the reminder will be set to trigger at.
 */
@property (nonatomic, readonly) NSDate *reminderTime;

/**
 @brief The note that will be added to the reminder.
 */
@property (nonatomic, strong) NSString *reminderNote;

/**
 @brief The delegate object to recieve updates on the status of a reminder.
 */
@property (nonatomic, weak) id <ReminderSchedulerDelegate> delegate;


- (void)createReminderForDate:(NSDate *)reminderTime;

@end

/**
 @brief The delegate of the ReminderScheduler object must adhere to this protocol. 
 The optional methods provide updates on whether or not a reminder did post successfully.
 */
@protocol ReminderSchedulerDelegate <NSObject>

@optional
- (void)reminderSchedulerDidPostReminder:(ReminderScheduler *)scheduler;
- (void)reminderScheduler:(ReminderScheduler *)scheduler
         didFailWithError:(NSError *)error;

@end
