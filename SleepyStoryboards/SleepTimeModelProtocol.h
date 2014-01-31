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

/**
 @brief The interval length that one sleep cycle should be estimated as. This should default to 90 minutes or
 1 hour and a half (1:30 hour).
 */
@property (nonatomic, assign) NSInteger sleepCycleInterval;

/**
 @brief The time it takes to fall asleep in @b minutes. This should default is 14 minutes (840 seconds).
 */
@property (nonatomic, assign) NSInteger timeToFallAsleep;

/**
 @brief The number of sleep cycles to display time suggestions for and should default to 6. This also should dictate the size of the timeDataSource array.
 @note In the SleepCycle application, this defaults to 6 and the corresponding tableView is set to display only 6 rows. It's a feature, I swear.
 */
@property (nonatomic, assign) NSInteger totalSleepCycles;

/**
 @brief The interface to the internal data source array that stores the time suggestion data.
 */
@property (nonatomic, readonly) NSArray *timeDataSource;

/**
 @brief Populates the internal data source with wake times with the sleepTime set to the current time.
 */
- (void)calculateWakeTimeWithCurrentTime;

/**
 @brief Populates the internal data source with wake times based on the sleepTime.
 @param sleepTime The NSDate that represents the desired bed time.
 */
- (void)calculateWakeTimesWithSleepTime:(NSDate *)sleepTime;

/**
 @brief Populates the internal data source with bed times based on the wakeTime.
 @param wakeTime The NSDate that represents the desired wake up time.
 */
- (void)calculateBedTimesWithWakeTime:(NSDate *)wakeTime;

@end
