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

/* 
 Private method to be used for testing in place of +spansMultipleDaysForTime:
 Ignore warning in implementation 
 */
+ (BOOL)spansMultipleDaysForTime:(NSDate *)candidateTime relativeToTime:(NSDate *)baseTime;

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

#pragma mark - +spansMultipleDaysForTime:relativeToTime:
- (void)testSpansMultipleDaysForTimesBeforeAndIncludingRelativeTime
{
    /*
     Verify that when comparing hours and minutes (seconds are assumed to be zero and thus
     irrelevant in the comparison) that all times before and including a relativeTime return NO.
     */
    
    // Relative time is noon.
    NSDate *relativeTime = [NSDate noonDate];
    
    // Generate times before noon up and including 12 pm
    NSInteger hoursBeforeAndIncludingNoon = 13;
    NSMutableArray *timesBeforeNoon = [NSMutableArray arrayWithCapacity:hoursBeforeAndIncludingNoon];
    
    for (int i = 0; i < hoursBeforeAndIncludingNoon; i++) {
        timesBeforeNoon[i] = [NSDate todaysDateWithHour:i minute:0];
    }
    
    // Assert array is not nil.
    assert(timesBeforeNoon);
    
    [timesBeforeNoon enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDate *testTime = (NSDate *)obj;
        XCTAssertEqual(NO, [NSDate spansMultipleDaysForTime:testTime relativeToTime:relativeTime],
                       @"Comparison does not equal the expected boolean NO.");
    }];
}

- (void)testSpansMultipleDaysForTimesAfterRelativeTime
{
    /*
     Verify that when comparing hours and minutes (seconds are assumed to be zero and thus
     irrelevant in the comparison) that all times after relativeTime return YES.
     */

    // Relative time is noon.
    NSDate *relativeTime = [NSDate noonDate];

    // Generate times after noon until 11 pm
    NSInteger hoursAfterNoon = 11;
    NSMutableArray *timesAfterNoon = [NSMutableArray arrayWithCapacity:hoursAfterNoon];
    
    for (int i = 0; i < hoursAfterNoon; i++) {
        timesAfterNoon[i] = [NSDate todaysDateWithHour:(13 + i) minute:0];
    }
    
    assert(timesAfterNoon);
    
    [timesAfterNoon enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDate *testTime = (NSDate *)obj;
        XCTAssertEqual(YES, [NSDate spansMultipleDaysForTime:testTime relativeToTime:relativeTime],
                       @"Comparison does not equal the expected boolean YES.");
    }];
    
}

- (void)testSpansMultipleDaysForNilInputTime
{
    /*
     Verify that NO is returned if the receiver is set to nil.
     */
    NSDate *testDate = nil;
    
    XCTAssertEqual(NO, [NSDate spansMultipleDaysForTime:testDate], @"The nil date does not return NO.");
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

#pragma mark - -shortTimeLowerCase Test Method
- (void)testValidShortTimeLowerCase
{
    /*
     Procedure is the same as the shortTime test method just with an additional
     lowercaseString added to it.
     */
    
    // Create seed time
    NSDate *seedTime = [NSDate noonDate];
    NSTimeInterval hourInterval = 1 * 60 * 60;
    NSInteger count = 24;
    
    // Change time stamps to lower case version
    NSArray *expectedTimeStamps = [self generateTimeStampsFromTime:seedTime
                                                       inIntervals:hourInterval
                                                          forCount:count];
    
    NSMutableArray *mutableExpectedTimeStamps = [NSMutableArray arrayWithCapacity:expectedTimeStamps.count];
    
    for (int i = 0; i < expectedTimeStamps.count; i++) {
        mutableExpectedTimeStamps[i] = [(NSString *)expectedTimeStamps[i] lowercaseString];
    }
    
    expectedTimeStamps = (NSArray *)mutableExpectedTimeStamps;
    
    // Generate array of NSDate times
    NSMutableArray *testTimes = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count; i++) {
        testTimes[i] = [seedTime dateByAddingTimeInterval:(i * hourInterval)];
    }
    
    [testTimes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *timeStamp = [(NSDate *)obj shortTimeLowerCase];
        
        XCTAssertEqualObjects((NSString *)expectedTimeStamps[idx], timeStamp,
                              @"The time stamps are not equal when lower cased.");
    }];
}


- (void)testNilShortTimeLowerCase
{
    /*
     Test nil is returned on nil input date.
     */
    NSDate *testDate = nil;
    NSString *testTimeStamps = [testDate shortTimeLowerCase];
    
    XCTAssertNil(testTimeStamps, @"The returned lower case string was not nil");
}

@end
