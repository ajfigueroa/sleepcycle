//
//  RedRoseTheme.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 12/31/2013.
//  Copyright (c) 2013 Alexander Figueroa. All rights reserved.
//

#import "RedRoseTheme.h"
#import "UIColor+Colours.h"
#import "UIColor+FlatUI.h"

@implementation RedRoseTheme

- (instancetype)init
{
    // Init with base class implementations
    self = [super initWithBackgroundColor:[UIColor persianRed]
                 secondaryBackgroundColor:[UIColor paleRoseColor]
        alternateSecondaryBackgroundColor:[UIColor persianRed]
                                textColor:[UIColor whiteColor]
                       secondaryTextColor:[UIColor blackColor]];
    
    // Assign themeEnum to allow for ImageViewManagerFactory to handle images properly
    self.themeEnum = AFThemeSelectionOptionRedRoseTheme;

    return self;
}

@end
