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
    _scheduledTime = alarmTime;
 
    // Configure alert body and send alarm notification post
    [self configureAlarmSchedulerBody];
    [self.alarmScheduler createAlarmNotificationForDate:alarmTime];
    NSLog(@"Creating alarm for: %@", [alarmTime descriptionWithLocale:[NSLocale currentLocale]]);
}

- (void)createReminderForDate:(NSDate *)reminderTime
{
    _scheduledTime = reminderTime;
    
    // Configure the reminder note and send the reminder request
    [self configureReminderSchedulerNote];
    [self.reminderScheduler createReminderForDate:reminderTime];
        NSLog(@"Creating alarm for: %@", [reminderTime descriptionWithLocale:[NSLocale currentLocale]]);
}


#pragma mark - ReminderSchedulerDelegate
- (void)reminderScheduler:(ReminderScheduler *)scheduler didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error.localizedDescription);
    [[NSNotificationCenter defaultCenter] postNotificationName:AFReminderHasPostedNotification
                                                        object:nil
                                                      userInfo:@{AFAlarmReminderNotificationSuccess: @NO}];
}

- (void)reminderSchedulerDidPostReminder:(ReminderScheduler *)scheduler
{
    [[NSNotificationCenter defaultCenter] postNotificationName:AFReminderHasPostedNotification
                                                        object:nil
                                                      userInfo:@{AFAlarmReminderNotificationSuccess: @YES}];
}

#pragma mark - AlarmNotificationSchedulerDelegate
- (void)alarmNotificationSchedulerDidFailPost:(AlarmNotificationScheduler *)alarmScheduler
{
    [[NSNotificationCenter defaultCenter] postNotificationName:AFAlarmHasPostedNotification
                                                        object:nil
                                                      userInfo:@{AFAlarmReminderNotificationSuccess: @NO}];
}

- (void)alarmNotificationDidPostNotification:(AlarmNotificationScheduler *)alarmScheduler
{
    [[NSNotificationCenter defaultCenter] postNotificationName:AFAlarmHasPostedNotification
                                                        object:nil
                                                      userInfo:@{AFAlarmReminderNotificationSuccess: @YES}];
}

@end
