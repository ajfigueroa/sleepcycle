//
//  ActionSheetPresenterTest.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 2/19/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ActionSheetPresenter.h"

@interface ActionSheetPresenter (Test)

@end

@interface ActionSheetPresenterTest : XCTestCase

@property (nonatomic, strong) ActionSheetPresenter *subject;

@end

@implementation ActionSheetPresenterTest

- (void)setUp
{
    [super setUp];
    
    // Set up ActionSheetPresenter subject to test on
    self.subject = [[ActionSheetPresenter alloc] init];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
    self.subject = nil;
}


#pragma mark - -buildActionSheetForState:andDate Test Methods
- (void)testBuildActionSheetForInvalidState
{
    /* Method should return nil on invalid state parameter.
     Valid parameters are:
     
     AFSelectedUserModeCalculateWakeTime - 0
     AFSelectedUserModeCalculateBedTime - 1
     AFSelectedUserModeCalculateBedTimeWithAlarm - 2
     */
    NSArray *invalidInputs = @[@(-1), @(4), @"a", @"", @(NAN), @(INFINITY)];
    
    [invalidInputs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        XCTAssertNil([self.subject buildActionSheetForState:(AFSelectedUserMode)obj andDate:[NSDate date]],
                     @"Nil was not returned");
    }];
}

- (void)testBuildActionSheetForValidStates
{
    /* Method should return IBActionSheets on succesful return. 
     The valid parameters correspond to:
     
     AFSelectedUserModeCalculateWakeTime - 0
     AFSelectedUserModeCalculateBedTime - 1
     AFSelectedUserModeCalculateBedTimeWithAlarm - 2
     
     which then match to alarm sheets with the following respective tags:
     AFActionSheetTagAlarm
     AFActionSheetTagReminder
     AFAcetionSheetTagAlarm
     */
    NSArray *validParameters = @[@(AFSelectedUserModeCalculateWakeTime),
                                 @(AFSelectedUserModeCalculateBedTime),
                                 @(AFSelectedUserModeCalculateBedTimeWithAlarmTime)];
    
    NSArray *expectedTagResponse = @[@(AFActionSheetTagAlarm),
                                     @(AFActionSheetTagReminder),
                                     @(AFActionSheetTagAlarm)];
    
    [validParameters enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        IBActionSheet *actionSheet = [self.subject buildActionSheetForState:[obj integerValue]
                                                                    andDate:[NSDate date]];
        AFActionSheetTag actualTagResponse = actionSheet.tag;
        AFActionSheetTag expectedTag = [expectedTagResponse[idx] integerValue];
        XCTAssertEqual(expectedTag, actualTagResponse, @"The tags do not match");
    }];
    
}

@end
