//
//  ThemeFactoryTest.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 2/19/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ThemeFactory.h"
#import "BlueBeigeTheme.h"
#import "BlackGrayTheme.h"
#import "RedRoseTheme.h"

@interface ThemeFactory (Test)

@end

@interface ThemeFactoryTest : XCTestCase

@end

@implementation ThemeFactoryTest

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

#pragma mark - -buildThemeForKey: Test Method
- (void)testValidThemeBuildRequest
{
    /*
     Verify for each enumeration of AFThemeSelectionOption, the proper object that conforms to the Theme protocol
     is returned.     */
    NSArray *themeOptions = @[@(AFThemeSelectionOptionBlueBeigeTheme),
                              @(AFThemeSelectionOptionBlackGrayTheme),
                              @(AFThemeSelectionOptionRedRoseTheme)];
    
    NSArray *classNames = @[[BlueBeigeTheme class],
                            [BlackGrayTheme class],
                            [RedRoseTheme class]];
    
    [themeOptions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        AFThemeSelectionOption option = (AFThemeSelectionOption)[obj integerValue];
        id <Theme> themeObj = [[ThemeFactory sharedThemeFactory] buildThemeForKey:option];
        
        XCTAssert([themeObj isKindOfClass:(Class)classNames[idx]], @"The object is not of the appropriate class");
    }];
}

- (void)testNilThemeBuildRequest
{
    /*
     Nil should be returned for invalid inputs.
     Valid inputs are enumerations 0 - 2 in AFThemeSelectionOption
     */
    NSArray *invalidInputs = @[@(-1), @(3), @(NAN), @(INFINITY)];
    
    [invalidInputs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        AFThemeSelectionOption option = (AFThemeSelectionOption)[obj integerValue];
        id <Theme> themeObj = [[ThemeFactory sharedThemeFactory] buildThemeForKey:option];
        
        XCTAssertNil(themeObj, @"The returned theme object was not nil");
    }];
}

@end
