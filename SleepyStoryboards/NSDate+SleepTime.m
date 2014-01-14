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

- (NSString *)stringShortTime
{
    // Return the short time variant of the date (ex. 3:30 PM)
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateStyle:NSDateFormatterNoStyle];
    [timeFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    return [timeFormatter stringFromDate:self];
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
    NSDate *oldDate = self;
    NSDate *currentDate = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *oldComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSTimeZoneCalendarUnit) fromDate:oldDate];
    
    NSDateComponents *currentComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSTimeZoneCalendarUnit) fromDate:currentDate];
    
    [currentComponents setHour:oldComponents.hour];
    [currentComponents setMinute:oldComponents.minute];
    [currentComponents setSecond:0];
    [currentComponents setDay:oldComponents.day];
    [currentComponents setMonth:oldComponents.month];
    [currentComponents setYear:oldComponents.year];
    [currentComponents setTimeZone:currentComponents.timeZone];
    
    return [calendar dateFromComponents:currentComponents];
}

@end
