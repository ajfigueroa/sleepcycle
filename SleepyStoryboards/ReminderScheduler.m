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
    EKReminder *reminder = [EKReminder reminderWithEventStore:self.eventStore];
    reminder.title = NSLocalizedString(@"You should be in bed now", nil);
    reminder.timeZone = [NSTimeZone localTimeZone];
    
    // Lazy initialize the reminderNote if not already set
    if (!self.reminderNote)
        self.reminderNote = NSLocalizedString(@"Reminder to be in bed for this time!", nil);
    reminder.notes = self.reminderNote;
    
    // Add the alarm to the reminder
    EKAlarm *alarm = [EKAlarm alarmWithAbsoluteDate:self.reminderTime];
    [reminder addAlarm:alarm];
    
    // Grab the default reminders list in Reminders.app and add it to the reminder
    EKCalendar *defaultReminderList = [self.eventStore defaultCalendarForNewReminders];
    reminder.calendar = defaultReminderList;
    
    // Check if an error has occured
    NSError *error = nil;
    
    BOOL success = [self.eventStore saveReminder:reminder
                                          commit:YES
                                           error:&error];
    
    if (!success)
        NSLog(@"Error saving reminder: %@", error.localizedDescription);
}

- (void)showReminderFailureAlert
{
    
}



@end
