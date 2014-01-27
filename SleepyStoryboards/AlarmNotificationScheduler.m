//
//  AlarmNotificationScheduler.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/26/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import "AlarmNotificationScheduler.h"

@implementation AlarmNotificationScheduler

- (void)createAlarmNotificationForDate:(NSDate *)alarmTime
{
    _alarmTime = alarmTime;
    [self postAlarmForAlarmTime];
}

- (void)postAlarmForAlarmTime
{
    // Create and subscribe the UILocalNotification
    UILocalNotification *alarmNotification = [[UILocalNotification alloc] init];
    
    if (!alarmNotification)
    {
        // Notify the delegate if necessary
        return;
    }
    
    alarmNotification.fireDate = self.alarmTime;
    alarmNotification.timeZone = [NSTimeZone localTimeZone];
    
    // Lazy intiialize alert body
    if (!self.alarmAlertBody)
        self.alarmAlertBody = @"Time to wake up!";
    
    alarmNotification.alertBody = self.alarmAlertBody;
    alarmNotification.alertAction = NSLocalizedString(@"I'm awake...", nil);
    alarmNotification.soundName = @"newalarmsounds.caf";
    alarmNotification.applicationIconBadgeNumber = 0;
    
    // Post notification
    [[UIApplication sharedApplication] scheduleLocalNotification:alarmNotification];
    // Post success delegate message
}

@end
