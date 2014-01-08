//
//  BlackGrayTheme.m
//  SleepCycleSeven
//
//  Created by Alexander Figueroa on 12/23/2013.
//  Copyright (c) 2013 Alexander Figueroa. All rights reserved.
//

#import "BlackGrayTheme.h"
#import "UIColor+Colours.h"
#import "SettingsSelectionConstants.h"

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

#pragma mark - Overrides
- (void)alternateThemeLabel:(UILabel *)label withFont:(UIFont *)font
{
    [super themeLabel:label withFont:font];
    label.textColor = self.textColor;
}

- (void)themeOptionCell:(UITableViewCell *)cell withImageView:(UIImageView *)imageView forThemeOption:(NSInteger)themeOption
{
    cell.backgroundColor = self.secondaryColor;
    
    switch (themeOption) {
        case AFSettingsTableOptionSettings:
            imageView.image = [UIImage imageNamed:@"settingswhite.png"];
            break;
        case AFSettingsTableOptionBedTime:
            imageView.image = [UIImage imageNamed:@"mooniconwhite.png"];
            break;
        case AFSettingsTableOptionWakeTime:
            imageView.image = [UIImage imageNamed:@"suniconwhite.png"];
            break;
        case AFSettingsTableOptionAlarm:
            imageView.image = [UIImage imageNamed:@"alarmclockwhite.png"];
        default:
            imageView = nil;
            break;
    }
}

- (void)themeTextField:(UITextField *)textField
{
    textField.textColor = self.textColor;
}

@end
