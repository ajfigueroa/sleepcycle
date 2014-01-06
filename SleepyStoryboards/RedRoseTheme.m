//
//  RedRoseTheme.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 12/31/2013.
//  Copyright (c) 2013 Alexander Figueroa. All rights reserved.
//

#import "RedRoseTheme.h"
#import "UIColor+Colours.h"

@implementation RedRoseTheme
{}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.primaryColor = [UIColor lightCrimsonColor];
        self.secondaryColor = [UIColor paleRoseColor];
        self.textColor = [UIColor whiteColor];
        self.alternateSecondaryColor = [UIColor lightCrimsonColor];
        self.alternateTextColor = [UIColor blackColor];
    }
    
    return self;
}

@end
