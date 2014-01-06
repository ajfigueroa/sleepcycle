//
//  BlackGrayTheme.m
//  SleepCycleSeven
//
//  Created by Alexander Figueroa on 12/23/2013.
//  Copyright (c) 2013 Alexander Figueroa. All rights reserved.
//

#import "BlackGrayTheme.h"
#import "UIColor+Colours.h"

@implementation BlackGrayTheme
{}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.primaryColor = [UIColor coolGrayColor];
        self.secondaryColor = [UIColor black25PercentColor];
        self.textColor = [UIColor whiteColor];
        self.alternateSecondaryColor = [UIColor coolGrayColor];
        self.alternateTextColor = [UIColor blackColor];
    }
    
    return self;
}

@end
