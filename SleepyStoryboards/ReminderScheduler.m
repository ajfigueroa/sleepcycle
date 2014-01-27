//
//  ReminderScheduler.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/26/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import "ReminderScheduler.h"
@import EventKit;

@interface ReminderScheduler ()

// Event Store to handle all notification requests
@property (nonatomic, strong) EKEventStore *eventStore;

@end

@implementation ReminderScheduler

- (void)addReminderForTime:(NSDate *)reminderTime
{
    _reminderTime = reminderTime;
    
    [self.eventStore requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError *error) {
        
        if (granted)
            [self setReminderForReminderTime];
        else
            [self showReminderFailureAlert];
    }];
}

- (void)setReminderForReminderTime
{
    
}

- (void)showReminderFailureAlert
{
    
}



@end
