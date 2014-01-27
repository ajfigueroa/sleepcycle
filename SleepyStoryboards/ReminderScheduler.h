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

@property (nonatomic, readonly) NSDate *reminderTime;
@property (nonatomic, assign) NSString *reminderNote;
@property (nonatomic, weak) id <ReminderSchedulerDelegate> delegate;

- (void)createReminderForDate:(NSDate *)reminderTime;

@end

// Protocol Definition
@protocol ReminderSchedulerDelegate <NSObject>

@optional
- (void)reminderSchedulerDidPostReminder:(ReminderScheduler *)scheduler;
- (void)reminderScheduler:(ReminderScheduler *)scheduler
         didFailWithError:(NSError *)error;

@end
