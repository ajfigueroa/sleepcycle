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
#import "NSDate+SleepTime.h"

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
    [self.reminderScheduler addReminderForTime:reminderDate];
}

#pragma mark - Time Verification Methods
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


@end
