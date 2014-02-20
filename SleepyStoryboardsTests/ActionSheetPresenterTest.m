//
//  ActionSheetPresenterTest.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 2/19/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ActionSheetPresenter.h"
#import "SettingsAPI.h"

@interface ActionSheetPresenter (Test)

@property (nonatomic, strong) NSArray *alarmTimesPair;
@property (nonatomic, strong) NSArray *reminderTimesPair;

- (IBActionSheet *)alarmActionSheetForWakeTime:(NSDate *)wakeTime;
- (IBActionSheet *)reminderActionSheetForSleepTime:(NSDate *)sleepTime;

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


#pragma mark - -buildActionSheetForState:andDate Tests
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

#pragma mark - -alarmActionSheetForWakeTime: Tests
- (void)testNilWakeTimeCheck
{
    /* 
     Verify that on nil input, a nil action sheet is return
    */
    XCTAssertNil([self.subject alarmActionSheetForWakeTime:nil], @"Nil action sheet was not returned for nil wakeTime");
}

- (void)testCorrectActionSheetButtonCountForAlarmActionSheet
{
    /*
     Depending on the date, the returned action sheet for both the AFSelectedUserMode:
        AFSelectedUserModeCalculateWakeTime
        AFSelectedUserModeCalculateBedTimeWithAlarmTime
     will either return one (1) or two (2) buttons depending on the input time.
     Note: Add one to the count due to the "Cancel" button so two (2) and three (3) respectively.
     
     That is, if the time entered for an alarm is AFTER the current time, then both
     the options to set the alarm for today or tomorrow exist.
     Else, if the time entered for the alarm is BEFORE the current time, then only
     the option to set the alarm for tomorrow exists. (You can't set an alarm in the
     past unless you're Marty McFly).
     */
    
    // Create an array with a time before the current time and one after
    NSDate *currentTime = [NSDate date];
    NSDate *before = [currentTime dateByAddingTimeInterval:(- 1 * 60 * 60)]; // 1 hour behind
    NSDate *after = [currentTime dateByAddingTimeInterval:(1 * 60 * 60)]; // 1 hour ahead
    NSArray *inputTimes = @[before, after];
    
    // Define expected button count from the IBActionSheet
    NSArray *expectedButtonCounts = @[@(2), @(3)];
    
    [inputTimes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        IBActionSheet *actionSheet = [self.subject alarmActionSheetForWakeTime:(NSDate *)obj];
        NSInteger actualButtonCount = [actionSheet numberOfButtons];
        NSInteger expectedButtonCount = [expectedButtonCounts[idx] integerValue];
        XCTAssertEqual(expectedButtonCount, actualButtonCount, @"The button counts are not equal");
    }];
}

- (void)testValidAlarmTimesPair
{
    /*
     The ActionSheetPresenter creates two alarm times to be sent off to the delegate
     when interaction occurs of the action sheet.
     For the alarmActionSheetForWakeTime method, the alarmTimesPair sent off should 
     include, in order, the input date forwarded by 24 hours and the current input date.
     */
    
    // Create test times
    NSDate *testWakeTime = [NSDate date];
    NSDate *testWakeTimeTomorrow = [testWakeTime dateByAddingTimeInterval:(24 * 60 * 60)];
    
    // Perform alarmActionSheetForWakeTime: but do not store return value
    [self.subject alarmActionSheetForWakeTime:testWakeTime];
    
    // Generate expected pair array
    NSArray *expectedAlarmTimesPair = @[testWakeTimeTomorrow, testWakeTime];
    
    XCTAssertEqualObjects(expectedAlarmTimesPair, self.subject.alarmTimesPair, @"The arrays do not match times");
}

- (void)testNilAlarmTimesPair
{
    /*
     To avoid sending off the previous version of the alarmsTimePair in case one input 
     was nil and the proceeding was not-nil.
     The alarmTimesPair needs to be set to nil when the wakeTime is nil.
     */
    
    // Perform alarmActionSheetForWakeTime: but do not store return value
    [self.subject alarmActionSheetForWakeTime:nil];
    
    XCTAssertNil(self.subject.alarmTimesPair, @"The alarmTimesPair was not set to nil");
}

#pragma mark - -reminderActionSheetForSleepTime: Tests
- (void)testNilSleepTimeCheck
{
    /*
     Verify that on nil input, a nil action sheet is return
     */
    XCTAssertNil([self.subject reminderActionSheetForSleepTime:nil], @"Nil action sheet was not returned for nil sleepTime");
}

- (void)testCorrectActionSheetButtonCountForReminderActionSheet
{
    /*
     Depending on the date, the returned action sheet for: AFSelectedUserModeCalculateBedTime
     will either return one (1) or two (2) buttons depending on the input time.
     Note: Add one to the count due to the "Cancel" button so two (2) and three (3) respectively.
     
     Refer to -testCorrectActionSheetButtonCountForAlarmActionSheet for more information.
     The main difference is that the time it takes to fall asleep creates an initial 
     negative offset
     */
    // Create an array with a time before the current time and one after
    NSDate *currentTime = [NSDate date];
    NSDate *before = [currentTime dateByAddingTimeInterval:(- 1 * 60 * 60)]; // 1 hour behind
    NSDate *after = [currentTime dateByAddingTimeInterval:(1 * 60 * 60)]; // 1 hour ahead
    
    // Create time with offset timeToFallAsleep in the future.
    NSInteger timeToFallAsleep = [[SettingsAPI sharedSettingsAPI] timeToFallAsleep];
    NSDate *afterByTimeToFallAsleep = [currentTime dateByAddingTimeInterval:(timeToFallAsleep * 60)];
    
    // Add all times to the inputTimesArray
    NSArray *inputTimes = @[before, after, afterByTimeToFallAsleep];
    
    // Define expected button count from the IBActionSheet
    NSArray *expectedButtonCounts = @[@(2), @(3), @(2)];
    
    [inputTimes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        IBActionSheet *actionSheet = [self.subject reminderActionSheetForSleepTime:(NSDate *)obj];
        NSInteger actualButtonCount = [actionSheet numberOfButtons];
        NSInteger expectedButtonCount = [expectedButtonCounts[idx] integerValue];
        XCTAssertEqual(expectedButtonCount, actualButtonCount, @"The button counts are not equal");
    }];
}

@end
