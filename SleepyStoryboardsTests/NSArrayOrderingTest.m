//
//  NSArrayOrderingTest.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 2/20/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSArray+Ordering.h"

@interface NSArrayOrderingTest : XCTestCase

@end

@implementation NSArrayOrderingTest

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

#pragma mark - -reversedArray Test Method
- (void)testOriginArrayReturned
{
    /*
     Given an array in a defined order, performing [[array reversedArray] reversedArray] should return the
     original array.
     */
    NSInteger arrayCapacity = 100;
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:arrayCapacity];
    
    for (int i = 0; i < arrayCapacity; i++) {
        // Store a random number between 0-100
        array[i] = [NSNumber numberWithUnsignedInteger:arc4random_uniform(101)];
    }
    
    NSArray *doubleReversedArray = [[array reversedArray] reversedArray];
    XCTAssertEqualObjects((NSArray *)array, doubleReversedArray, @"The arrays are not equal");
}

@end
