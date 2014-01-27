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

@interface SchedulerAPI () <ReminderSchedulerDelegate>

@property (nonatomic, strong) ReminderScheduler *reminderScheduler;

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
        self.reminderScheduler = [[ReminderScheduler alloc] init];
        self.reminderScheduler.delegate = (id <ReminderSchedulerDelegate>)self;
    }
    
    return self;
}

#pragma mark - Public Scheduling Methods
- (void)createAlarmNotificationForDate:(NSDate *)alarmDate
{
    
}

- (void)createReminderForDate:(NSDate *)reminderDate
{
    
}

@end
