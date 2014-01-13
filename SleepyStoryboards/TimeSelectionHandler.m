//
//  TimeSelectionHandler.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/12/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import "TimeSelectionHandler.h"

@implementation TimeSelectionHandler

- (NSDate *)offsetInputDate:(NSDate *)inputDate
{
    // If the wake up time chosen is in the AM, offset the time by 24 hours
    // so that the bed times are for the current date
    NSDate *offsetDate = inputDate;
    NSInteger dayInSeconds = 24 * 60 * 60;
    
    if ([self hourComponent:inputDate] >= 0 && [self hourComponent:inputDate] <= 12)
    {
        [offsetDate dateByAddingTimeInterval:dayInSeconds];
    }
    
    return offsetDate;
}

- (NSInteger)hourComponent:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSHourCalendarUnit fromDate:date];
    return [components hour];
}

@end
