//
//  TimeSelectionHandlerTests.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/12/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TimeSelectionHandler.h"

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

- (void)testHourComponent
{
    
}

@end
