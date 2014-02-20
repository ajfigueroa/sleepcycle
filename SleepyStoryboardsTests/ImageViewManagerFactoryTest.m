//
//  ImageViewManagerFactoryTest.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 2/20/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ImageViewManagerFactory.h"
#import "BlackOverlayImageViewManager.h"
#import "WhiteOverlayImageViewManager.h"
#import "AFThemeConstants.h"

@interface ImageViewManagerFactoryTest : XCTestCase

@end

@implementation ImageViewManagerFactoryTest

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

#pragma mark - -buildImageViewManagerForThemeKey: Test Methods
- (void)testValidImageViewManagerBuildRequest
{
    /*
     Verify that for the given AFThemeSelectionOption enumerations, the proper object that conforms to the 
     ImageViewManager protocol is returned.
     Only the the AFThemeSelectionOptionBlackGray is unique in that it receives a WhiteOverlayImageViewManager while
     the other two options receive the BlackOverlayImageViewManager.
     */
    NSArray *themeOptions = @[@(AFThemeSelectionOptionBlueBeigeTheme),
                              @(AFThemeSelectionOptionBlackGrayTheme),
                              @(AFThemeSelectionOptionRedRoseTheme)];
    
    NSArray *expectedClasses = @[[BlackOverlayImageViewManager class],
                                 [WhiteOverlayImageViewManager class],
                                 [BlackOverlayImageViewManager class]];
    
    
    [themeOptions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        AFThemeSelectionOption option = (AFThemeSelectionOption)[obj integerValue];
        id <ImageViewManager> imageViewManagerObj = [[ImageViewManagerFactory sharedImageViewManagerFactory]
                                                     buildImageViewManagerForThemeKey:option];
        XCTAssert([imageViewManagerObj isKindOfClass:(Class)expectedClasses[idx]],
                  @"The returned object is not of the appropriate class.");
    }];
}

- (void)testNilImageViewManagerBuildRequest
{
    /*
     Nil should be returned for invalid inputs.
     Valid inputs are enumerations 0 - 2 in AFThemeSelectionOption
     */
    NSArray *invalidInputs = @[@(-1), @(3), @(NAN), @(INFINITY)];
    
    [invalidInputs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        AFThemeSelectionOption option = (AFThemeSelectionOption)[obj integerValue];
        id <ImageViewManager> imageViewManagerObj = [[ImageViewManagerFactory sharedImageViewManagerFactory]
                                                     buildImageViewManagerForThemeKey:option];
        
        XCTAssertNil(imageViewManagerObj, @"The returned imageViewManager object was not nil");
    }];
}

@end
