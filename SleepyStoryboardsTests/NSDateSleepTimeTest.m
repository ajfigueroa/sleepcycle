//
//  NSDateSleepTimeTest.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 2/20/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSDate+SleepTime.h"

@interface NSDate (Test)

// Convenience methods for testing

/**
 @brief Returns an NSDate set to todays date at noon (12:00 pm or 1200 hours), using
 the current calendar.
 @returns An NSDate set to noon time.
 */
+ (NSDate *)noonDate;

/**
 @brief Returns an NSDate set to today with the given hour and minute, using the
 current calendar.
 @param hour The hour at which to set the time to.
 @param minute The minute at which to set the time to.
 @returns An NSDate set to time hour : minute
 */
+ (NSDate *)todaysDateWithHour:(NSInteger)hour minute:(NSInteger)minute;

@end

@implementation NSDate (Test)

+ (NSDate *)noonDate
{
    return [NSDate todaysDateWithHour:12 minute:0];
}

+ (NSDate *)todaysDateWithHour:(NSInteger)hour minute:(NSInteger)minute
{
    // Grab current calendar
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // Set up and initialize components
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.hour = hour;
    components.minute = minute;
    
    NSDate *dateFromComponents = [calendar dateFromComponents:components];
    return [dateFromComponents currentDateTransform];
}

@end

@interface NSDateSleepTimeTest : XCTestCase

@end

@implementation NSDateSleepTimeTest

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testExample
{
    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

@end
