//
//  AlarmNotificationScheduler.h
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/26/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlarmNotificationScheduler : NSObject

@property (nonatomic, readonly) NSDate *alarmTime;

- (void)createAlarmNotificationForDate:(NSDate *)alarmTime;

@end
