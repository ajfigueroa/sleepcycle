//
//  TimeSelectionHandlerTests.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/12/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TimeSelectionHandler.h"
#import "NSDate+SleepTime.h"

@interface TimeSelectionHandlerTests : XCTestCase

@property (nonatomic, strong) TimeSelectionHandler *timeSelectionHandler;

@end

@implementation TimeSelectionHandlerTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    if (!self.timeSelectionHandler)
        self.timeSelectionHandler = [[TimeSelectionHandler alloc] init];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
    
    self.timeSelectionHandler = nil;
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

@end
