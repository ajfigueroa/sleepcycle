//
//  SleepTimeModelProtocol.h
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/22/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SleepTimeModelProtocol <NSObject>

@required

// Model Configuration Properties
@property (nonatomic, assign) NSInteger sleepCycleInterval;
@property (nonatomic, assign) NSInteger timeToFallAsleep;
@property (nonatomic, assign) NSInteger totalSleepCycles;

// Data Source
@property (nonatomic, readonly) NSArray *timeDataSource;

// Model Access Methods
- (void)calculateWakeTimeWithCurrentTime;
- (void)calculateWakeTimesWithSleepTime:(NSDate *)sleepTime;
- (void)calculateBedTimesWithWakeTime:(NSDate *)wakeTime;

@end
