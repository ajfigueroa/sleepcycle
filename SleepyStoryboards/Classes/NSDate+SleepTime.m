//
//  NSDate+SleepTime.m
//  SleepyTimeUpdate
//
//  Created by Alexander Figueroa on 11/25/2013.
//  Copyright (c) 2013 Alexander Figueroa. All rights reserved.
//

#import "NSDate+SleepTime.h"

@implementation NSDate (SleepTime)

+ (BOOL)spansMultipleDaysForTime:(NSDate *)candidateTime
{
    return [NSDate spansMultipleDaysForTime:candidateTime relativeToTime:[NSDate date]];
}

/**
 @brief A helper method for +spansMultipleDaysForTime: useful for testing. Returns YES
 if the candidateTime is greater than the baseTime and returns NO if the candidateTime
 is less than or equal to the baseTime.
 @param candidateTime The NSDate object whose time will be checked to determine if the date is valid for today and tomorrow or tomorrow only, relative to baseTime.
 @param baseTime The time that candidateTime will be compared to.
 @returns Returns YES if candidateTime is greater than baseTime. Returns NO if candidateTime
 is less than or equal to baseTime.
 */
+ (BOOL)spansMultipleDaysForTime:(NSDate *)candidateTime relativeToTime:(NSDate *)baseTime
{
    NSComparisonResult timeCompare = [candidateTime compareTimes:baseTime];
    
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

- (NSString *)stringUsingFormatter:(NSDateFormatter *)formatter;
{
    // Format the string according to the supplied formatter
    return [formatter stringFromDate:self];
}

- (NSString *)shortTime
{
    // Return the short time variant of the date (ex. 3:30 PM)
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateStyle:NSDateFormatterNoStyle];
    [timeFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    return [timeFormatter stringFromDate:self];
}

- (NSString *)shortTimeLowerCase
{
    return [[self shortTime] lowercaseString];
}

- (NSString *)shortDate
{
    // Format the date in the short variant (ex. 12/20/14)
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    
    return [self stringUsingFormatter:dateFormatter];
}


- (NSInteger)hourComponent
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSHourCalendarUnit fromDate:self];
    return components.hour;
}

- (NSDate *)zeroedSeconds
{
    // Zero the seconds of the current date's time
    NSDate *selfDate = [self copy];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *selfDateComponents = [calendar components:NSCalendarUnitSecond fromDate:selfDate];
    
    NSInteger seconds = selfDateComponents.second;
    
    return [selfDate dateByAddingTimeInterval:(-1 * seconds)];
}

- (NSDate *)currentDateTransform
{
    // Transform the self date to the current date implementation
    NSDate *oldDate = [self copy];
    
    // Get the current calendar instance
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // Define NSCalendarUnits to extract from oldDate
    NSCalendarUnit units = (NSYearCalendarUnit |
                            NSMonthCalendarUnit |
                            NSDayCalendarUnit |
                            NSHourCalendarUnit |
                            NSMinuteCalendarUnit |
                            NSSecondCalendarUnit |
                            NSTimeZoneCalendarUnit);
    
    
    NSDateComponents *oldComponents = [calendar components:units fromDate:oldDate];
    
    // Extract the day unit from currentDate (today)
    NSDate *currentDate = [NSDate date];
    NSDateComponents *currentComponents = [calendar components:(NSDayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSTimeZoneCalendarUnit) fromDate:currentDate];
    
    // Create a new date with componenets set to everything from oldDate minus the NSDayCalendarUnit
    NSDateComponents *newComponents = [[NSDateComponents alloc] init];
    
    [newComponents setHour:oldComponents.hour];
    [newComponents setMinute:oldComponents.minute];
    [newComponents setSecond:oldComponents.second];
    [newComponents setDay:currentComponents.day];
    [newComponents setMonth:currentComponents.month];
    [newComponents setYear:currentComponents.year];
    [newComponents setTimeZone:currentComponents.timeZone];
    
    return [calendar dateFromComponents:newComponents];
}

- (NSComparisonResult)compareHours:(NSDate *)anotherDate
{
    // Grab the hours of both dates
    NSInteger selfHour, anotherHour;
    
    // Grab hour of receiver
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSHourCalendarUnit fromDate:self];
    
    selfHour = dateComponents.hour;
    
    // Grab the hour of the anotherDate
    dateComponents = [calendar components:NSHourCalendarUnit fromDate:anotherDate];
    
    anotherHour = dateComponents.hour;
    
    // Compare the NSHourCalendarUnit
    if (selfHour == anotherHour)
        return NSOrderedSame;
    else if (selfHour > anotherHour)
        return NSOrderedDescending;
    else
        return NSOrderedAscending;
}

- (NSComparisonResult)compareMinutes:(NSDate *)anotherDate
{
    // Grab the minutes of both dates
    NSInteger selfMinute, anotherMinute;
    
    // Grab hour of receiver
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSMinuteCalendarUnit fromDate:self];
    
    selfMinute = dateComponents.minute;
    
    // Grab the hour of the anotherDate
    dateComponents = [calendar components:NSMinuteCalendarUnit fromDate:anotherDate];
    
    anotherMinute = dateComponents.minute;
    
    // Compare the hours
    if (selfMinute == anotherMinute)
        return NSOrderedSame;
    else if (selfMinute > anotherMinute)
        return NSOrderedDescending;
    else
        return NSOrderedAscending;
}

- (NSComparisonResult)compareTimes:(NSDate *)anotherDate
{
    // Compare the time where if the hours are equal, minutes comparison determines result
    NSComparisonResult hourCompare = [self compareHours:anotherDate];
    NSComparisonResult minuteCompare = [self compareMinutes:anotherDate];
    
    // If the hours are the same, the result of the minutes comparison determines
    // the overall result
    if (hourCompare == NSOrderedSame)
        return minuteCompare;
    else
        return hourCompare;
}


@end
