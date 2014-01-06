//
//  BlueBeigeTheme.m
//  SleepCycleSeven
//
//  Created by Alexander Figueroa on 12/23/2013.
//  Copyright (c) 2013 Alexander Figueroa. All rights reserved.
//

#import "BlueBeigeTheme.h"
#import "UIColor+Colours.h"

@implementation BlueBeigeTheme
{}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.primaryColor = [UIColor blueberryColor];
        self.secondaryColor = [UIColor eggshellColor];
        self.textColor = [UIColor whiteColor];
        self.alternateSecondaryColor = [UIColor blueberryColor];
        self.alternateTextColor = [UIColor blackColor];
    }
    
    return self;
}

@end
