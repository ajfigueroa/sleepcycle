//
//  ReminderScheduler.h
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/26/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReminderScheduler : NSObject

@property (nonatomic, readonly) NSDate *reminderTime;
@property (nonatomic, assign) NSString *reminderNote;

- (void)addReminderForTime:(NSDate *)reminderTime;

@end
