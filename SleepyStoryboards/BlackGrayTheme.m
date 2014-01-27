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

- (instancetype)init
{
    // Init with base class implementations
    self = [super initWithBackgroundColor:[UIColor coolGrayColor]
                 secondaryBackgroundColor:[UIColor black25PercentColor]
        alternateSecondaryBackgroundColor:[UIColor coolGrayColor]
                                textColor:[UIColor whiteColor]
                       secondaryTextColor:[UIColor blackColor]];
    
    // Assign themeEnum to allow for ImageViewManagerFactory to handle images properly
    self.themeEnum = AFThemeSelectionOptionBlackGrayTheme;
    
    return self;
}

#pragma mark - Overrides from BaseThemes implementation of Theme protocol
- (void)alternateThemeLabel:(UILabel *)label withFont:(UIFont *)font
{
    [super themeLabel:label withFont:font];
    label.textColor = self.primaryTextColor;
}

- (void)themeCell:(UITableViewCell *)cell
{
    [self themeViewBackground:cell];
    cell.textLabel.textColor = self.primaryTextColor;
    cell.detailTextLabel.textColor = self.primaryTextColor;
}

- (void)themeTextField:(UITextField *)textField
{
    textField.textColor = self.primaryTextColor;
}

- (void)themeBorderForView:(UIView *)view visible:(BOOL)isVisible
{
    CGColorRef borderColor;
    
    if (isVisible)
        borderColor = [[UIColor whiteColor] CGColor];
    else
        borderColor = [[UIColor clearColor] CGColor];
    
    view.layer.borderColor = borderColor;
    view.layer.borderWidth = 1.5f;
}


@end
