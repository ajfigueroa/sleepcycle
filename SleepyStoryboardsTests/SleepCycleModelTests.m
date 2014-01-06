//
//  SleepCycleModelTests.m
//  SleepCycleSeven
//
//  Created by Alexander Figueroa on 12/22/2013.
//  Copyright (c) 2013 Alexander Figueroa. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SleepyTimeModel.h"
#import "NSDate+SleepTime.h"

@interface SleepCycleModelTests : XCTestCase

// Model to perform tests upon
@property (nonatomic, strong) SleepyTimeModel *model;

@end

@implementation SleepCycleModelTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    self.model = [[SleepyTimeModel alloc] init];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
    self.model = nil;
}

- (void)testEmptyDataSource
{
    // Test upon init that the internal data source used for the table views
    // is not nil but is empty (i.e. [])
    XCTAssertEqualObjects(self.model.timeDataSource, @[], @"The data source is not an empty array upon initialization.");
}

- (void)testDesiredDataSourceSize
{
    // Using the totalSleepCycles property, the desired of the size can change.
    // Verify that the internal array is of the appropriate size for multiple ranges
    // Assume valid sizes.
    NSArray *sizes = @[@0, @1, @5, @10, @100];
    NSDate *startTime = [NSDate date];
    
    for (NSNumber *size in sizes){
        self.model.totalSleepCycles = [size integerValue];
        [self.model calculateWakeTimesWithSleepTime:startTime];
        
        XCTAssert([self.model.timeDataSource count] == [size integerValue], @"The data source size does not agree with the given input");
    }
}

- (void)testKnownWakeTimes
{
    // Using a seed sleep time and 6 cycles, verify that the wake times are valid
    NSArray *wakeTimes = @[@"11:30 PM", @"1:00 AM", @"2:30 AM", @"4:00 AM", @"5:30 AM", @"7:00 AM"];
    
    // Create the seed date to be 10:00pm
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *timeComponents = [[NSDateComponents alloc] init];
    [timeComponents setHour:[@22 integerValue]];
    [timeComponents setMinute:[@0 integerValue]];
    
    NSDate *seedBedTime = [gregorianCalendar dateFromComponents:timeComponents];
    
    // Calculate the wake times from seed
    [self.model calculateWakeTimesWithSleepTime:seedBedTime];
    
    NSMutableArray *timeStrings = [[NSMutableArray alloc] init];
    for (NSDate *date in self.model.timeDataSource){
        [timeStrings addObject:[date stringShortTime]];
    }
    
    XCTAssertEqualObjects(timeStrings, wakeTimes, @"The known values and what is returned as wake times do not agree");
}

- (void)testKnownBedTimes
{
    // Using a seed sleep time and 6 cycles, verify that the wake times are valid
    NSArray *bedTimes = @[@"8:30 PM", @"10:00 PM", @"11:30 PM", @"1:00 AM", @"2:30 AM", @"4:00 AM"];
    
    // Create the seed date to be 10:00pm
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *timeComponents = [[NSDateComponents alloc] init];
    [timeComponents setHour:[@7 integerValue]];
    [timeComponents setMinute:[@0 integerValue]];
    
    NSDate *seedWakeTime = [gregorianCalendar dateFromComponents:timeComponents];
    
    // Calculate the wake times from seed
    [self.model calculateBedTimesWithWakeTime:seedWakeTime];
    
    NSMutableArray *timeStrings = [[NSMutableArray alloc] init];
    for (NSDate *date in self.model.timeDataSource){
        [timeStrings addObject:[date stringShortTime]];
    }
    
    XCTAssertEqualObjects(timeStrings, bedTimes, @"The known values and what is returned as wake times do not agree");
}

@end
