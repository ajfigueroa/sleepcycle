//
//  SleepyTimeModel.m
//  SleepyTimeUpdate
//
//  Created by Alexander Figueroa on 11/20/2013.
//  Copyright (c) 2013 Alexander Figueroa. All rights reserved.
//

#import "SleepyTimeModel.h"

@interface SleepyTimeModel ()

@property (nonatomic, strong) NSMutableArray *internalTimeDataSource;

@end

// The duration of twelve hours in seconds
const static NSInteger kTwelveHours = 43200;

@implementation SleepyTimeModel

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

- (void)setTimeToFallAsleep:(NSInteger)timeToFallAsleep
{
    // Assumes that the time to fall asleep is being passed in seconds
    _timeToFallAsleep = timeToFallAsleep * 60;
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
    // Shift wake time back by 12 hours so timing works out
    wakeTime = [wakeTime dateByAddingTimeInterval:-kTwelveHours];
    
    // Update array of shifted sleep times given the wake time
    self.internalTimeDataSource = [self modifyTimesForStartTime:wakeTime
                                                      timeShift:self.sleepCycleInterval
                                                    totalCycles:self.totalSleepCycles];
}

- (NSMutableArray *)modifyTimesForStartTime:(NSDate *)startTime
                                  timeShift:(NSInteger)shiftInSeconds
                                totalCycles:(NSUInteger)cycleLimit
{
    // Shifts the input time by consecutive shifts for a limit of cycles
    // Returns an array of the shifted times
    NSMutableArray *outputTimes = [[NSMutableArray alloc] init];
    
    for (int i = 1; i <= cycleLimit; i++){
        NSDate *shiftedTime = [startTime dateByAddingTimeInterval:(i * shiftInSeconds)];
        [outputTimes addObject:shiftedTime];
    }
    
    return outputTimes;
}



@end
