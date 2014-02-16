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

/**
@brief The UIColor to apply to UINavigationBar, UITabBar, UIToolBar etc. 
In the init, this is the backgroundColor parameter.
*/
@property (nonatomic, strong) UIColor *primaryBackgroundColor;

/**
@brief The UIColor to apply to UIView backgrounds and complementary text. 
In the init, this is the secondaryBackgroundColor parameter.
 */
@property (nonatomic, strong) UIColor *secondaryBackgroundColor;

/**
@brief The alternate UIColor to apply to view backgrounds and complementary text. 
In the init, this is the altSecondaryBackgroundColor parameter.
*/
@property (nonatomic, strong) UIColor *alternateSecondaryBackgroundColor;

/**
@brief The primary color to use for all textColor properties of Labels and Buttons. 
In the init, this is the textColor parameter.
*/
@property (nonatomic, strong) UIColor *primaryTextColor;

/**
@brief The secondary color to use for all textColor properties of Labels and Buttons
where it would make sense to use a different color. 
In the init, this is the secondaryTextColor property.
*/
@property (nonatomic, strong) UIColor *secondaryTextColor;

/**
@brief The enumeration value that represents the AFThemeSelectionOption value of the subclass object.
@sa AFThemeSelectionOption constants in SleepyTimeConstants.h
*/
@property (nonatomic, assign) NSInteger themeEnum;

/**
@brief Initialize the BaseTheme with set color properties for views and text.
@param backgroundColor The UIColor to apply to UINavigationBar, UITabBar, UIToolBar etc.
@param secondaryBackgroundColor The UIColor to apply to UIView backgrounds and complementary text.
@param altSecondaryBackgroundColor The alternate UIColor to apply to view backgrounds and complementary text.
@param textColor The primary color to use for all textColor properties of Labels and Buttons
@param secondaryTextColor The secondary color to use for all textColor properties of Labels and Buttons
where it would make sense to use a different color.
@returns An initialized BaseTheme object.
 */
- (instancetype)initWithBackgroundColor:(UIColor *)backgroundColor
               secondaryBackgroundColor:(UIColor *)secondaryBackgroundColor
      alternateSecondaryBackgroundColor:(UIColor *)altSecondaryBackgroundColor
                              textColor:(UIColor *)textColor
                     secondaryTextColor:(UIColor *)secondaryTextColor;

@end
