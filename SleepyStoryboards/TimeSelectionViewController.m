//
//  TimeSelectionViewController.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 12/31/2013.
//  Copyright (c) 2013 Alexander Figueroa. All rights reserved.
//

#import "TimeSelectionViewController.h"
#import "ThemeProvider.h"
#import "ResultsViewController.h"

@interface TimeSelectionViewController ()

// Manage the theming of the view
@property (nonatomic, strong) id <Theme> themeSetter;
// Manage mode of calculation mode
@property (nonatomic) AFSelectedUserMode selectedUserMode;

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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applyTheme)
                                                 name:AFThemeHasChangedNotification
                                               object:nil];
    
    // Register for View Update Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateViewWithNotification:)
                                                 name:AFSelectedCalculateWakeTimeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateViewWithNotification:)
                                                 name:AFSelectedCalculateBedTimeNotification
                                               object:nil];
    
}

#pragma mark - Control View Management
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    BOOL applyBorder = [[NSUserDefaults standardUserDefaults] boolForKey:AFShowDatePickerBorder];
    
    if (applyBorder)
        [self applyBorderToView:self.timeSelectionDatePicker WithColor:nil width:1.5f];
}

- (void)updateViewWithNotification:(NSNotification *)notification
{
    if ([notification.name isEqualToString:AFSelectedCalculateWakeTimeNotification])
    {
        self.informationLabel.text = @"Choose your bed time";
        self.selectedUserMode = AFSelectedUserModeCalculateWakeTime;
    }
    else if ([notification.name isEqualToString:AFSelectedCalculateBedTimeNotification])
    {
        self.informationLabel.text = @"Choose your wake-up time";
        self.sleepNowButton.hidden = YES;
        self.selectedUserMode = AFSelectedUserModeCalculateBedTime;
    }
}

- (void)applyBorderToView:(UIView *)view WithColor:(UIColor *)color width:(CGFloat)width
{
    // If border color is nil, use default black.
    CGColorRef borderColor;

    if (!color)
        borderColor = [[UIColor blackColor] CGColor];
    else
        borderColor = [color CGColor];
    
    view.layer.borderColor = borderColor;
    view.layer.borderWidth = width;
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
    UIFont *buttonFont = [UIFont fontWithName:@"Futura" size:[UIFont buttonFontSize]];
    
    // Theme the confirm button normally
    [self.themeSetter themeButton:self.confirmTimeButton withFont:buttonFont];
    
    // The SleepNowButton is Themed differently to differentiate it from the ConfirmTimeButton
    if ([self.themeSetter respondsToSelector:@selector(alternateThemeButton:withFont:)])
        [self.themeSetter alternateThemeButton:self.sleepNowButton withFont:buttonFont];
    else
        [self.themeSetter themeButton:self.sleepNowButton withFont:buttonFont];
    
    // Theme the information label view and increase the font slightly
    UIFont *labelFont = [buttonFont fontWithSize:([UIFont labelFontSize])];
    [self.themeSetter themeLabel:self.informationLabel withFont:labelFont];
}

#pragma mark - Model Configuration
- (void)configureModel:(SleepyTimeModel *)model
{
    // Implement with additional properties
}

- (void)performModelCalculation:(SleepyTimeModel *)model
{
    NSDate *selectedDate = self.timeSelectionDatePicker.date;
    
    switch (self.selectedUserMode) {
        case AFSelectedUserModeCalculateWakeTime:
            [model calculateWakeTimesWithSleepTime:selectedDate];
            break;
        case AFSelectedUserModeCalculateBedTime:
            [model calculateBedTimesWithWakeTime:selectedDate];
            break;
        default:
            break;
    }
}

#pragma mark - View Transitioning
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ResultsViewController *resultsViewController = (ResultsViewController *)segue.destinationViewController;
    SleepyTimeModel *model = [[SleepyTimeModel alloc] init];

    if ([segue.identifier isEqualToString:AFConfirmTimeButtonSegue])
    {
        [self configureModel:model];
        [self performModelCalculation:model];
        resultsViewController.model = model;
    } else if ([segue.identifier isEqualToString:AFSleepNowButtonSegue])
    {
        [self configureModel:model];
        [model calculateWakeTimeWithCurrentTime];
        resultsViewController.model = model;
    }
}

#pragma mark - End of Life
- (void)dealloc
{
    // Remove observer so notification is not sent to null object
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

@end
