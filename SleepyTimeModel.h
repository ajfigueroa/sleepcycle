//
//  SleepyTimeModel.h
//  SleepyTimeUpdate
//
//  Created by Alexander Figueroa on 11/20/2013.
//  Copyright (c) 2013 Alexander Figueroa. All rights reserved.
//
//  The SleepyTimeModel is responsible for storing our sleep or bed times as
//  the timeDataSource and updating the current value of it depending on the desired actions.

#import <Foundation/Foundation.h>

@interface SleepyTimeModel : NSObject

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
