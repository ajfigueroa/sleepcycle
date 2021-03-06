//
//  SleepyTimeModel.m
//  SleepyTimeUpdate
//
//  Created by Alexander Figueroa on 11/20/2013.
//  Copyright (c) 2013 Alexander Figueroa. All rights reserved.
//

#import "SleepyTimeModel.h"

#define MINUTES_TO_SECONDS(x) (x * 60)

@interface SleepyTimeModel ()

@property (nonatomic, strong) NSMutableArray *internalTimeDataSource;

@end

// The duration of twelve hours in seconds
const static NSInteger kTwelveHours = 43200;

@implementation SleepyTimeModel
{
    // Instance variable to handle timeToFallAsleep changes since synthesize does not
    // generate an ivar for the timeToFallAsleep property.
    NSInteger _timeToFallAsleep;
}

// Synthesize the properties from the SleepTimeModelProtocol
@synthesize internalTimeDataSource, sleepCycleInterval, timeToFallAsleep, totalSleepCycles, timeDataSource;

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        // Assign default property values
        // Data source array is empty upon initialization
        self.internalTimeDataSource = [[NSMutableArray alloc] init];
        self.sleepCycleInterval = 5400; // 1.5 hours in seconds
        self.timeToFallAsleep = 840; // 14 min in seconds
        self.totalSleepCycles = 6;
        
    }
    
    return self;
}

#pragma mark - Override Accessor Methods
- (NSArray *)timeDataSource
{
    // Return the immutable version of the data source
    return (NSArray *)self.internalTimeDataSource;
}

- (void)setTimeToFallAsleep:(NSInteger)aTimeToFallAsleep
{
    _timeToFallAsleep = MINUTES_TO_SECONDS(aTimeToFallAsleep);
}

- (NSInteger)timeToFallAsleep
{
    return _timeToFallAsleep;
}

#pragma mark - Calculation Methods
- (void)calculateWakeTimeWithCurrentTime
{
    // Update array of shifted wake times for the current time
    NSDate *inputTime = [[NSDate date] dateByAddingTimeInterval:self.timeToFallAsleep];
    self.internalTimeDataSource = [self modifyTimesForStartTime:inputTime
                                                      timeShift:self.sleepCycleInterval
                                                    totalCycles:self.totalSleepCycles];
}

- (void)calculateWakeTimesWithSleepTime:(NSDate *)sleepTime
{
    // Update array of shifted wake times given the sleep time
    self.internalTimeDataSource = [self modifyTimesForStartTime:sleepTime
                                                      timeShift:self.sleepCycleInterval
                                                    totalCycles:self.totalSleepCycles];
}

- (void)calculateBedTimesWithWakeTime:(NSDate *)wakeTime
{
    // Shift wake time back by 12 hours so problem becomes a Wake Time problem
    wakeTime = [wakeTime dateByAddingTimeInterval:-kTwelveHours];
    
    // Update array of shifted sleep times given the wake time
    self.internalTimeDataSource = [self modifyTimesForStartTime:wakeTime
                                                      timeShift:self.sleepCycleInterval
                                                    totalCycles:self.totalSleepCycles];
}

/**
 @brief Creates a mutable array that contains the startTime shifted consecutively by shiftInSeconds 
 for cycleLimit times.
 @param startTime The seed time that all shifts are performed relative to.
 @param shiftInSeconds The amount to shift in seconds during each iteration.
 @param cycleLimit The amount of shifts to perform.
 @returns A NSMutableArray of the shifted times.
 */
- (NSMutableArray *)modifyTimesForStartTime:(NSDate *)startTime
                                  timeShift:(NSInteger)shiftInSeconds
                                totalCycles:(NSUInteger)cycleLimit
{
    // Shifts the input time by consecutive shifts for a limit of cycles
    NSMutableArray *outputTimes = [[NSMutableArray alloc] init];
    
    for (int i = 1; i <= cycleLimit; i++){
        NSDate *shiftedTime = [startTime dateByAddingTimeInterval:(i * shiftInSeconds)];
        [outputTimes addObject:shiftedTime];
    }
    
    return outputTimes;
}



@end
