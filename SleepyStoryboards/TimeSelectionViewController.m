//
//  TimeSelectionViewController.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 12/31/2013.
//  Copyright (c) 2013 Alexander Figueroa. All rights reserved.
//

#import "TimeSelectionViewController.h"
#import "ThemeProvider.h"

@interface TimeSelectionViewController ()

// Manage the theming of the view
@property (nonatomic, strong) id <Theme> themeSetter;

@end

@implementation TimeSelectionViewController
{}

#pragma mark - View Initialization
- (void)awakeFromNib
{
    [super awakeFromNib];
    NSLog(@"Awaking from nib: %s", __PRETTY_FUNCTION__);
    [self applyTheme];
    
    // Register for Theme Change Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyTheme) name:AFThemeHasChangedNotification object:nil];
    
    // Register for View Update Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateViewWithNotification:) name:AFSelectedCalculateWakeTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateViewWithNotification:) name:AFSelectedCalculateBedTimeNotification object:nil];
    
}

#pragma mark - Control View Management
- (void)updateViewWithNotification:(NSNotification *)notification
{
    if ([notification.name isEqualToString:AFSelectedCalculateWakeTimeNotification])
    {
        self.informationLabel.text = @"Choose your bed time";
    }
    else if ([notification.name isEqualToString:AFSelectedCalculateBedTimeNotification])
    {
        self.informationLabel.text = @"Choose your wake-up time";
        self.sleepNowButton.hidden = YES;
    }
}

#pragma mark - Theme Change Methods
- (void)applyTheme
{
    // Set (or reset) the theme with the appropriate theme object
    self.themeSetter = [ThemeProvider theme];
    
    // Theme the appropriate views
    [self.themeSetter themeNavigationBar:self.navigationController.navigationBar];
    
    // Theme the background view differently if the alternateThemeViewBackground has been implemented
    if ([self.themeSetter respondsToSelector:@selector(alternateThemeViewBackground:)])
        [self.themeSetter alternateThemeViewBackground:self.view];
    else
       [self.themeSetter themeViewBackground:self.view];
    
    // Set up the button font
    UIFont *buttonFont = [UIFont fontWithName:@"Futura-Medium" size:[UIFont systemFontSize]];
    
    // Theme the confirm button normally
    [self.themeSetter themeButton:self.confirmTimeButton withFont:buttonFont];
    
    // The SleepNowButton is Themed differently to differentiate it from the ConfirmTimeButton
    if ([self.themeSetter respondsToSelector:@selector(alternateThemeButton:withFont:)])
        [self.themeSetter alternateThemeButton:self.sleepNowButton withFont:buttonFont];
    else
        [self.themeSetter themeButton:self.sleepNowButton withFont:buttonFont];
    
    // Theme the information label view
    UIFont *labelFont = buttonFont;
    [self.themeSetter themeLabel:self.informationLabel withFont:labelFont];
}

#pragma mark - End of Life
- (void)dealloc
{
    // Remove observer so notification is not sent to null object
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

@end
