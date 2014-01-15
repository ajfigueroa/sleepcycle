//
//  NSDate+SleepTime.m
//  SleepyTimeUpdate
//
//  Created by Alexander Figueroa on 11/25/2013.
//  Copyright (c) 2013 Alexander Figueroa. All rights reserved.
//

#import "NSDate+SleepTime.h"

@implementation NSDate (SleepTime)

- (NSString *)stringUsingFormatter:(NSDateFormatter *)formatter;
{
    // Return the formatter specific string
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

- (NSString *)shortDate
{
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

- (NSArray *)allDateComponents
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:self];
    
    return @[@(components.day),
             @(components.hour),
             @(components.minute),
             @(components.second)];
}

- (NSDate *)zeroDateSeconds
{
    NSTimeInterval time = round([self timeIntervalSinceReferenceDate] / 60.0f) * 60.0f;
    return [NSDate dateWithTimeIntervalSinceReferenceDate:time];
}

- (NSDate *)currentDateVersion
{
    NSDate *oldDate = [self copy];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *oldComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSTimeZoneCalendarUnit) fromDate:oldDate];
    
    NSDate *currentDate = [NSDate date];
    NSDateComponents *currentComponents = [calendar components:NSDayCalendarUnit fromDate:currentDate];
    
    NSDateComponents *newComponents = [[NSDateComponents alloc] init];
    
    [newComponents setHour:oldComponents.hour];
    [newComponents setMinute:oldComponents.minute];
    [newComponents setSecond:oldComponents.second];
    [newComponents setDay:currentComponents.day];
    [newComponents setMonth:oldComponents.month];
    [newComponents setYear:oldComponents.year];
    [newComponents setTimeZone:newComponents.timeZone];
    
    return [calendar dateFromComponents:newComponents];
}

- (NSComparisonResult)compareHours:(NSDate *)anotherDate
{
    // Compare the given hours of two dates.
    
    // Grab the hours of both dates
    NSInteger selfHour, anotherHour;
    
    // Grab hour of receiver
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSHourCalendarUnit fromDate:self];
    
    selfHour = dateComponents.hour;
    
    // Grab the hour of the anotherDate
    dateComponents = [calendar components:NSHourCalendarUnit fromDate:anotherDate];
    
    anotherHour = dateComponents.hour;
    
    // Compare the hours
    if (selfHour == anotherHour)
        return NSOrderedSame;
    else if (selfHour > anotherHour)
        return NSOrderedDescending;
    else
        return NSOrderedAscending;
    
    
}

@end
