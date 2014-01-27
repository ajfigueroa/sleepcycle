//
//  TimeSelectionHandlerTests.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/12/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SchedulerAPI.h"
#import "NSDate+SleepTime.h"

@interface TimeSelectionHandlerTests : XCTestCase

@property (nonatomic, strong) SchedulerAPI *scheduler;

@end

@implementation TimeSelectionHandlerTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    if (!self.scheduler)
        self.scheduler = [SchedulerAPI sharedScheduler];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
    
    self.scheduler = nil;
}

#pragma mark - Testing NSDate Category
- (void)testShortTime
{
    // Test the appropriate strings are coming through assuming non-military time
    NSArray *controlTimeStrings = @[@"12:00 PM",
                                    @"1:30 PM",
                                    @"3:00 PM",
                                    @"4:30 PM",
                                    @"6:00 PM",
                                    @"7:30 PM",
                                    @"9:00 PM",
                                    @"10:30 PM",
                                    @"12:00 AM"];
    
    // Form the first date
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.hour = 12;
    
    // Using created data as seed, add 1.5 hours incrementally
    NSDate *startDate = [calendar dateFromComponents:components];
    NSMutableArray *dates = [NSMutableArray arrayWithObject:startDate];
    
    for (NSInteger i = 1; i < controlTimeStrings.count; i++)
    {
        startDate = [startDate dateByAddingTimeInterval:1.5 * 60 * 60];
        [dates addObject:(startDate)];
    }
    
    // Verify the strings are equal for each string representation of the dates
    [dates enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *controlDateString = (NSString *)controlTimeStrings[idx];
        NSString *testDateString = (NSString *)[(NSDate *)obj shortTime];
        XCTAssert([controlDateString isEqualToString:testDateString], @"The string and returned string from date do not match");
    }];
}

- (void)testShortTimeLowerCase
{
    // Test the appropriate strings are coming through assuming non-military time
    NSArray *controlTimeStrings = @[@"12:00 pm",
                                    @"1:30 pm",
                                    @"3:00 pm",
                                    @"4:30 pm",
                                    @"6:00 pm",
                                    @"7:30 pm",
                                    @"9:00 pm",
                                    @"10:30 pm",
                                    @"12:00 am"];
    
    // Form the first date
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.hour = 12;
    
    // Using created data as seed, add 1.5 hours incrementally
    NSDate *startDate = [calendar dateFromComponents:components];
    NSMutableArray *dates = [NSMutableArray arrayWithObject:startDate];
    
    for (NSInteger i = 1; i < controlTimeStrings.count; i++)
    {
        startDate = [startDate dateByAddingTimeInterval:1.5 * 60 * 60];
        [dates addObject:(startDate)];
    }
    
    // Verify the strings are equal for each string representation of the dates
    [dates enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *controlDateString = (NSString *)controlTimeStrings[idx];
        NSString *testDateString = (NSString *)[(NSDate *)obj shortTimeLowerCase];
        BOOL match = [controlDateString isEqualToString:testDateString];
        XCTAssert(match, @"The string and returned string from date do not match in lower case versions");
    }];
}

- (void)testHourComponent
{
    // Create control array of hours (nsuinteger) in 24-hour clock mode
    NSUInteger controlCount = 24;
    NSMutableArray *controlHours = [NSMutableArray arrayWithCapacity:controlCount];
    
    // Prepare the date builders
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    // Build test dates array
    NSMutableArray *testDates = [NSMutableArray arrayWithCapacity:controlCount];
    
    // Create hours as nsuinteger array
    for (NSUInteger i = 0; i < controlCount; i++)
    {
        controlHours[i] = @(i);
        
        // Assign date component with hour
        components.hour = i;
        testDates[i] = [calendar dateFromComponents:components];
    }
    
    // Test that the hour components are the same
    [testDates enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSInteger controlHour = [(NSNumber *)controlHours[idx] integerValue];
        NSInteger testHour = [(NSDate *)obj hourComponent];
        
        XCTAssert(controlHour == testHour, @"The hours do not match");
    }];
    
}

- (void)testTimeCompareOrderedDescending
{
    // Create control time (12:00 pm)
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *controlDateComponents = [[NSDateComponents alloc] init];
    controlDateComponents.hour = 12;
    
    NSDate *noon = [calendar dateFromComponents:controlDateComponents];
    
    // Build array of hours before noon
    NSMutableArray *beforeNoon = [NSMutableArray arrayWithCapacity:11];
    
    for (NSInteger i = 12; i > 0; i--)
    {
        // Shift back by i hours
        // ranging from 12 to
        [beforeNoon addObject:[noon dateByAddingTimeInterval:-i * 60 * 60]];
    }
    
    [beforeNoon enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        XCTAssertEqual(NSOrderedDescending, [noon compareTimes:(NSDate *)obj], @"The hours are not earlier than noon");
    }];
    
}

- (void)testTimeCompareOrderedAscending
{
    // Create control time (12:00 pm)
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *controlDateComponents = [[NSDateComponents alloc] init];
    controlDateComponents.hour = 12;
    
    NSDate *noon = [calendar dateFromComponents:controlDateComponents];
    
    // Build array of hours after noon
    NSMutableArray *afterNoon = [NSMutableArray arrayWithCapacity:11];
    
    for (NSInteger i = 0; i < afterNoon.count; i++)
    {
        [afterNoon addObject:[noon dateByAddingTimeInterval:(i + 1) * 60 * 60]];
    }
    
    [afterNoon enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        XCTAssertEqual(NSOrderedAscending, [noon compareTimes:(NSDate *)obj], @"The hours are not later than noon");
    }];
}

- (void)testTimeCompareOrderedSame
{
    // Create control time (12:00 pm)
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *controlDateComponents = [[NSDateComponents alloc] init];
    controlDateComponents.hour = 12;
    
    NSDate *noon = [calendar dateFromComponents:controlDateComponents];
    
    XCTAssertEqual(NSOrderedSame, [noon compareTimes:noon], @"The hours are not the same");
}

- (void)testReminderTimeValid
{
    // Create control time (12:00 pm)
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *controlDateComponents = [[NSDateComponents alloc] init];
    controlDateComponents.hour = 12;
    
    NSDate *noon = [calendar dateFromComponents:controlDateComponents];

    // Populate the array with times shifted by multipled of 1.5 hours
    NSMutableArray *testTimes = [NSMutableArray arrayWithCapacity:8];
    [testTimes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        testTimes[idx] = [noon dateByAddingTimeInterval:(idx * 1.5) * 60 * 60];
    }];

    [testTimes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        XCTAssertEqual(YES, [self.scheduler spansMultipleDaysForTime:(NSDate *)obj], @"The object does not return whether it is a valid multiple reminder");
    }];
}

- (void)testReminderTimeInvalid
{
    // Create control time (12:00 pm)
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *controlDateComponents = [[NSDateComponents alloc] init];
    controlDateComponents.hour = 12;
    
    NSDate *noon = [calendar dateFromComponents:controlDateComponents];
    
    // Populate the array with times shifted by multipled of 1.5 hours
    NSMutableArray *testTimes = [NSMutableArray arrayWithCapacity:7];
    [testTimes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx == 0)
            testTimes[idx] = noon;
        else
            testTimes[idx] = [noon dateByAddingTimeInterval:(-idx * 1.5) * 60 * 60];
    }];
    
    [testTimes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        XCTAssertEqual(NO, [self.scheduler spansMultipleDaysForTime:(NSDate *)obj], @"The object does not return whether it is a valid multiple reminder");
    }];
}

- (void)testZeroDateSeconds
{
    // Create control time (12:00:30 pm)
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *controlDateComponents = [[NSDateComponents alloc] init];
    controlDateComponents.hour = 12;
    controlDateComponents.second = 30;
    
    NSDate *slightlyNoon = [calendar dateFromComponents:controlDateComponents];
    
    // Zero the seconds of this date and ensures it equals 0
    NSDate *dateWithZeroSeconds = [slightlyNoon zeroDateSeconds];
    
    // Grab the seconds component
    NSDateComponents *testDateComponents = [calendar components:NSCalendarUnitSecond
                                                       fromDate:dateWithZeroSeconds];
    NSInteger testSeconds = testDateComponents.second;
    NSInteger controlSeconds = 0;
    
    XCTAssertEqual(testSeconds, controlSeconds, @"The seconds have not been set to zero");
}

@end
