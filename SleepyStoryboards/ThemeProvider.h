//
//  ThemeProvider.h
//  SleepCycleSeven
//
//  Created by Alexander Figueroa on 12/23/2013.
//  Copyright (c) 2013 Alexander Figueroa. All rights reserved.
//
//  Through dependency injection, fetch at runtime the desired theme.

#import <Foundation/Foundation.h>
#import "Theme.h"

@interface ThemeProvider : NSObject

+ (id <Theme>)theme;

@end
