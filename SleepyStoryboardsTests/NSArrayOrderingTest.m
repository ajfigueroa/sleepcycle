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
- (void)testOriginalArrayReturned
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

- (void)testCorrectReversedArrayReturned
{
    /*
     Given two arrays, both defined as the reverse of each other.
     When the -reversedArray is called, they should equal regardless of which was reversed.
     Combinations for comparing are, given array A and array B:
        A compared to B reversed.
        A reversed compared to B
        A reversed twice compared to B reversed
        A reversed compared to B reversed twice
     */
    NSInteger arrayCapacity = 100;
    
    NSMutableArray *ascendingArray = [NSMutableArray arrayWithCapacity:arrayCapacity];
    
    for (NSInteger i = 0; i < arrayCapacity; i++) {
        ascendingArray[i] = [NSNumber numberWithInteger:i];
    }
    
    NSMutableArray *descendingArray = [NSMutableArray arrayWithCapacity:arrayCapacity];
    
    for (NSInteger i = 0; i < arrayCapacity; i++) {
        descendingArray[i] = [NSNumber numberWithInteger:(arrayCapacity - 1 - i)];
    }
    
    // Check that the two sizes are correct and equal
    assert(ascendingArray.count == descendingArray.count);
    
    NSInteger testCombinations = 4;
    
    for (int i = 0; i < testCombinations; i++) {
        switch (i) {
            case 0:
                XCTAssertEqualObjects(ascendingArray, [descendingArray reversedArray],
                                      @"Case 0: A and B reversed did not equal");
                break;
            case 1:
                XCTAssertEqualObjects([ascendingArray reversedArray], descendingArray,
                                      @"Case 1: A reversed and B did not equal");
                break;
            case 2:
                XCTAssertEqualObjects([[ascendingArray reversedArray] reversedArray], [descendingArray reversedArray],
                                      @"Case 2: A reversed twice and B reversed did not equal");
                break;
            case 3:
                XCTAssertEqualObjects([ascendingArray reversedArray], [[descendingArray reversedArray] reversedArray],
                                      @"Case 3: A reversed and B reversed twice did not equal");
                break;
            default:
                // Ideally, should not reach here.
                NSLog(@"Default switch reached in %s", __PRETTY_FUNCTION__);
                break;
        }
    }
        
}

- (void)testNilArrayReturned
{
    /*
     If nil is entered, nil should be expected back.
     */
    NSArray *nilArray = nil;
    XCTAssertNil([nilArray reversedArray], @"Nil was not returned");
}

@end
