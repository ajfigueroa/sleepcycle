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
 the current calendar and time zone.
 @returns An NSDate set to noon time.
 */
+ (NSDate *)noonDate;

/**
 @brief Returns an NSDate set to today with the given hour and minute, using the
 current calendar and time zone.
 @param hour The hour at which to set the time to. @b Must be within 0-23
 @param minute The minute at which to set the time to. @b Must be within 0-59
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
    // To prevent potentially unexpected behaviour, change hour and minute if invalid
    if (hour > 23 || hour < 0)
        hour = ABS(hour) % 24;
    
    if (minute > 59 || minute < 0)
        minute = ABS(minute) % 60;
    
    // Grab current calendar
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // Set up and initialize components
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.hour = hour;
    components.minute = minute;
    components.second = 0; // Zero seconds by default
    components.timeZone = [NSTimeZone localTimeZone];
    
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

/**
 @brief Generates an array of NSDate represented as strings from startTime in intervals
 of interval until count has been reached.
 @param startTime The seed time to increment from.
 @param interval The NSTimeInterval to incrememt each time from seed time.
 @param count The number of times to increment.
 @returns An array of human readable time stamps, of size count.
 */
- (NSArray *)generateTimeStampsFromTime:(NSDate *)startTime
                            inIntervals:(NSTimeInterval)interval
                               forCount:(NSInteger)count
{
    if (!startTime)
        return nil;
    
    NSMutableArray *timeStamps = [NSMutableArray arrayWithCapacity:count];
    
    // Create formatter
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterNoStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    
    for (int i = 0; i < count; i++) {
        NSDate *time = [startTime dateByAddingTimeInterval:(i * interval)];
        timeStamps[i] = [formatter stringFromDate:time];
    };
    
    return (NSArray *)timeStamps;
}

#pragma mark - +todaysDateWithHour:minute: Test Method
- (void)testValidTimeBuildRequest
{
    /*
     Testing convenience method from (Test) category. You're only as good as your tools.
     Essentially, given a few times, the returned date should return the correct hours
     and minutes (seconds to 0) as well as having the same day, month, and year properties.
     */
    NSInteger hoursInDay = 24;
    NSMutableArray *testHours = [NSMutableArray arrayWithCapacity:hoursInDay];
    
    for (int i = 0; i < hoursInDay; i++) {
        testHours[i] = [NSNumber numberWithInteger:i];
    }
    
    // Hold reference to current date for comparison of appropriate components
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unitFlags = (NSYearCalendarUnit | NSMonthCalendarUnit |
                                NSDayCalendarUnit | NSTimeZoneCalendarUnit);
    NSDateComponents *todayComponents = [calendar components:unitFlags fromDate:today];
    
    [testHours enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        // Make request for date using current hour and random minutes within 0-59
        NSInteger minutes = (NSInteger)arc4random_uniform(60);
        NSInteger hours = (NSInteger)[obj integerValue];
        
        NSDate *requestDate = [NSDate todaysDateWithHour:hours minute:minutes];
        
        // Break up date into components to compare
        NSCalendarUnit requestUnitFlags = (NSHourCalendarUnit | NSMinuteCalendarUnit |
                                           NSSecondCalendarUnit | NSDayCalendarUnit |
                                           NSMonthCalendarUnit | NSYearCalendarUnit |
                                           NSTimeZoneCalendarUnit);
        NSDateComponents *requestComponents = [calendar components:requestUnitFlags
                                                          fromDate:requestDate];
        
        
        NSArray *expectedComponents = @[@(todayComponents.year),
                                        @(todayComponents.month),
                                        @(todayComponents.day),
                                        @(hours),
                                        @(minutes),
                                        @(0), // Expected second count of 0
                                        todayComponents.timeZone];
        
        NSArray *actualComponents = @[@(requestComponents.year),
                                      @(requestComponents.month),
                                      @(requestComponents.day),
                                      @(requestComponents.hour),
                                      @(requestComponents.minute),
                                      @(requestComponents.second),
                                      requestComponents.timeZone];
        
        XCTAssertEqualObjects(expectedComponents, actualComponents,
                              @"The components returned did not equal the expected");
        
    }];
}

#pragma mark - -generateTimeStampsFromTime:inIntervals:forCount: Test Method
- (void)testValidGenerateTimeStampsCompare
{
    /*
     Test the returned time stamps equals a desired time stamp array
     */
    
    NSArray *controlTimeStamps = @[@"12:00 AM",
                                   @"1:00 AM",
                                   @"2:00 AM",
                                   @"3:00 AM",
                                   @"4:00 AM",
                                   @"5:00 AM",
                                   @"6:00 AM",
                                   @"7:00 AM",
                                   @"8:00 AM",
                                   @"9:00 AM",
                                   @"10:00 AM",
                                   @"11:00 AM",
                                   @"12:00 PM",
                                   @"1:00 PM",
                                   @"2:00 PM",
                                   @"3:00 PM",
                                   @"4:00 PM",
                                   @"5:00 PM",
                                   @"6:00 PM",
                                   @"7:00 PM",
                                   @"8:00 PM",
                                   @"9:00 PM",
                                   @"10:00 PM",
                                   @"11:00 PM"];
    
    // Create seed time
    NSDate *seedTime = [NSDate todaysDateWithHour:0 minute:0];
    NSTimeInterval hourInterval = 1 * 60 * 60;
    NSInteger count = controlTimeStamps.count;
    
    NSArray *testTimeStamps = [self generateTimeStampsFromTime:seedTime
                                                   inIntervals:hourInterval
                                                      forCount:count];
    
    XCTAssertEqualObjects(controlTimeStamps, testTimeStamps,
                          @"The time stamp arrays are not equal");
}

- (void)testNilGenerateTimeStamps
{
    /*
     Test that on nil date, a nil array is returned.
     */
    
    // Create seed time
    NSDate *seedTime = nil;
    NSTimeInterval hourInterval = 1 * 60 * 60;
    NSInteger count = 24;
    
    NSArray *testTimeStamps = [self generateTimeStampsFromTime:seedTime
                                                   inIntervals:hourInterval
                                                      forCount:count];
    
    XCTAssertNil(testTimeStamps, @"The array returned is not nil");
}

#pragma mark - +spansMultipleDaysForTime:
- (void)testSpansMultipleDaysForTime
{
    /*
     There is an issue with this test case and that is, since the method depends
     on the current time ([NSDate date]). This test will fail if adding or subtracting
     1 minute from the current time pushes you past the date lines (i.e. 
     If it's currently 11:59 pm or 12:00 am).
     
     Nonetheless, the method should return YES or NO depending on whether the time is
     */
    NSDate *beforeMidnight = [NSDate todaysDateWithHour:23 minute:59];
    NSDate *afterMidnight = [NSDate todaysDateWithHour:0 minute:0];
    
    NSDate *currentTime = [NSDate date];
    
    // If the time is 11:59pm or 12:00am, fail the test and explain
    if ([currentTime compareTimes:beforeMidnight] == NSOrderedSame ||
        [currentTime compareTimes:afterMidnight] == NSOrderedSame) {
        XCTAssertNotNil(nil, @"This time scenario makes the test fail. Read test information, I'm working on fix");
    }
    
    NSArray *testTimeIntervals = @[@(-60), @(0), @(60)];
    NSArray *expectedBools = @[@(NO), @(NO), @(YES)];
    
    [testTimeIntervals enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSInteger interval = [(NSNumber *)obj integerValue];
        NSDate *testTime = [[NSDate date] dateByAddingTimeInterval:interval];
        BOOL spans = [NSDate spansMultipleDaysForTime:testTime];
        
        XCTAssertEqual([expectedBools[idx] boolValue], spans,
                       @"The spans value does not equal the expected boolean value");
    }];
}

#pragma mark - -shortTime Test Method
- (void)testValidShortTime
{
    /*
     Generate an array of short time stamps 
     (generateTimeStampsFromTime:inIntervals:forCount:) and compare to an
     array of times with the -shortTime method applied to each and stored in a
     string array.
     */
    
    // Create seed time
    NSDate *seedTime = [NSDate noonDate];
    NSTimeInterval hourInterval = 1 * 60 * 60;
    NSInteger count = 24;
    
    NSArray *expectedTimeStamps = [self generateTimeStampsFromTime:seedTime
                                                       inIntervals:hourInterval
                                                          forCount:count];
    
    // Generate array of NSDate times
    NSMutableArray *testTimes = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count; i++) {
        testTimes[i] = [seedTime dateByAddingTimeInterval:(i * hourInterval)];
    }
    
    [testTimes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *timeStamp = [(NSDate *)obj shortTime];
        
        XCTAssertEqualObjects((NSString *)expectedTimeStamps[idx], timeStamp,
                              @"The time stamps are not equal");
    }];
}

- (void)testNilShortTime
{
    /*
     Test nil is returned on nil input date.
     */
    NSDate *testDate = nil;
    NSString *testTimeStamps = [testDate shortTime];
    
    XCTAssertNil(testTimeStamps, @"The returned string was not nil");
}

#pragma mark -

@end
