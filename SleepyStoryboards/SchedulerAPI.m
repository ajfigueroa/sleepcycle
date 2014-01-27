//
//  SchedulerAPI.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/26/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//
//  Responsible for setting up all notifications (alarms) and reminders

#import "SchedulerAPI.h"
#import "ReminderScheduler.h"
#import "AlarmNotificationScheduler.h"
#import "NSDate+SleepTime.h"

@interface SchedulerAPI () <ReminderSchedulerDelegate, AlarmNotificationSchedulerDelegate>

@property (nonatomic, strong) ReminderScheduler *reminderScheduler;
@property (nonatomic, strong) AlarmNotificationScheduler *alarmScheduler;

@end

@implementation SchedulerAPI

+ (instancetype)sharedScheduler
{
    static SchedulerAPI *sharedScheduler = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedScheduler = [[SchedulerAPI alloc] init];
    });
    
    return sharedScheduler;
}

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        // Set reminderScheduler delegate
        self.reminderScheduler = [[ReminderScheduler alloc] init];
        self.reminderScheduler.delegate = (id <ReminderSchedulerDelegate>)self;
        
        // Set alarmScheduler delegate
        self.alarmScheduler = [[AlarmNotificationScheduler alloc] init];
        self.alarmScheduler.delegate = (id <AlarmNotificationSchedulerDelegate>)self;
    }
    
    return self;
}

#pragma mark - Reminder Configuration
- (void)configureReminderSchedulerNote
{
    NSString *reminderNote = [NSString stringWithFormat:NSLocalizedString(@"Hello, it's SleepCycle!\n"
                                                                          @"You should be in bed about now so that "
                                                                          @"you'll fall asleep in time to wake up at "
                                                                          @"your desired time of %@", nil),
                                                                            [self.selectedTime shortTime]];
    self.reminderScheduler.reminderNote = reminderNote;
}

- (void)configureAlarmSchedulerBody
{
    NSString *alertBody = [NSString stringWithFormat:NSLocalizedString(@"Time to wake up for your %@ alarm!", nil),
                                                                            [self.selectedTime shortTimeLowerCase]];
    
    self.alarmScheduler.alarmAlertBody = alertBody;
}

#pragma mark - Public Scheduling Methods
- (void)createAlarmNotificationForDate:(NSDate *)alarmTime
{
    // Configure alert body and send alarm notification post
    [self configureAlarmSchedulerBody];
    [self.alarmScheduler createAlarmNotificationForDate:alarmTime];
}

- (void)createReminderForDate:(NSDate *)reminderTime
{
    // Configure the reminder note and send the reminder request
    [self configureReminderSchedulerNote];
    [self.reminderScheduler createReminderForDate:reminderTime];
}

#pragma mark - Public Time Verification Methods
- (BOOL)spansMultipleDaysForTime:(NSDate *)candidateTime
{
    // Compare the candidateTime with currentTime to validate alarm/reminder setting
    // If candidateTime is earlier than currentTime, only a time in the future
    // 24 hours is possible. Otherwise, a time within 24 hours and in the next 24 hours
    // are possible
    NSDate *currentDate = [NSDate date];
    NSComparisonResult timeCompare = [candidateTime compareTimes:currentDate];
    
    switch (timeCompare) {
        case NSOrderedAscending:
            return NO;
            break;
            
        case NSOrderedDescending:
            return YES;
            break;
            
        case NSOrderedSame:
            return NO;
            break;
            
        default:
            return NO;
            break;
    }
}

#pragma mark - ReminderSchedulerDelegate
- (void)reminderScheduler:(ReminderScheduler *)scheduler didFailWithError:(NSError *)error
{
    
}

- (void)reminderSchedulerDidPostReminder:(ReminderScheduler *)scheduler
{
    
}

#pragma mark - AlarmNotificationSchedulerDelegate
- (void)alarmNotificationSchedulerDidFailPost:(AlarmNotificationScheduler *)alarmScheduler
{
    
}

- (void)alarmNotificationDidPostNotification:(AlarmNotificationScheduler *)alarmScheduler
{
    
}

@end
