//
//  BaseTheme.h
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/22/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Theme.h"

@interface BaseTheme : NSObject <Theme>

// Primary refers to navigation bar color and buttons
@property (nonatomic, strong) UIColor *primaryColor;
// Secondary refers to background views
@property (nonatomic, strong) UIColor *secondaryColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *alternateSecondaryColor;
@property (nonatomic, strong) UIColor *alternateTextColor;

- (instancetype)initWithPrimaryColor:(UIColor *)primaryColor
                      secondaryColor:(UIColor *)secondaryColor
                           textColor:(UIColor *)textColor
             alternateSecondaryColor:(UIColor *)altSecondryColor
                  alternateTextColor:(UIColor *)altTextColor;

@end
