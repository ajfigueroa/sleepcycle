//
//  Theme.h
//  SleepCycleSeven
//
//  Created by Alexander Figueroa on 12/23/2013.
//  Copyright (c) 2013 Alexander Figueroa. All rights reserved.
//
//  Define the protocol which every theme must adhere to

#import <Foundation/Foundation.h>

@protocol Theme <NSObject>

@required

// Theming general UI Controls and Views
- (void)themeViewBackground:(UIView *)view;
- (void)themeNavigationBar:(UINavigationBar *)navBar;
- (void)themeButton:(UIButton *)button withFont:(UIFont *)font;

@optional

- (void)themeViewBackgroundAlternate:(UIView *)view;

@end
