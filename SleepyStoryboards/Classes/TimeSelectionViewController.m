//
//  TimeSelectionViewController.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 12/31/2013.
//  Copyright (c) 2013 Alexander Figueroa. All rights reserved.
//

#import "TimeSelectionViewController.h"
#import "ThemeFactory.h"
#import "SettingsViewController.h"
#import "ResultsViewController.h"
#import "SleepyTimeModel.h"
#import "SettingsAPI.h"
#import "FUIButton.h"
#import "SliderMenuApplicationDelegate.h"
#import "AFNotificationConstants.h"
#import "AFSegueIdentifierConstants.h"
#import "FUIAlertView.h"

@interface TimeSelectionViewController ()

/**
 @brief An internal reference to the application delegate that conforms to the SliderMenuApplicationDelegate
 and thus can handle all interactions of the ApplicationDelegate's slider menu controller.
 */
@property (nonatomic, strong) id <SliderMenuApplicationDelegate> sliderApplication;

/*
 UI Components (Refer to storyboards for placement)
 */
@property (weak, nonatomic) IBOutlet UIDatePicker *timeSelectionDatePicker;

@property (weak, nonatomic) IBOutlet FUIButton *confirmTimeButton;

@property (weak, nonatomic) IBOutlet FUIButton *sleepNowButton;

@property (weak, nonatomic) IBOutlet UILabel *informationLabel;

- (IBAction)toggleSlider:(id)sender;

@end

@implementation TimeSelectionViewController
{}

#pragma mark - Accessors
- (void)setSelectedUserMode:(AFSelectedUserMode)selectedUserMode
{
    if (_selectedUserMode != selectedUserMode)
    {
        _selectedUserMode = selectedUserMode;
        [self updateViewWithSelectedUserMode:_selectedUserMode];
    }
}


#pragma mark - View Management
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Initialize the application delegate reference
    self.sliderApplication = (id <SliderMenuApplicationDelegate>)[UIApplication sharedApplication].delegate;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Apply the them just before the view is about to load onto the stack
    [self applyTheme];
    
    // Unlock the slider if this view controller is the current frontViewController
    [self.sliderApplication unlockSlider];
    
    // Register for Theme Change Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applyTheme)
                                                 name:AFThemeHasChangedNotification
                                               object:nil];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    [self prepareLaunchInfoAlertView];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    // Clear any color mapping from previous states
    [[NSNotificationCenter defaultCenter] postNotificationName:AFColorMappingResetNotification object:nil];
    
}


#pragma mark - Theme Change Methods
- (void)applyTheme
{
    // Set (or reset) the theme with the appropriate theme object
    id <Theme> themeSetter = [[ThemeFactory sharedThemeFactory] buildThemeForSettingsKey];

    // Theme the appropriate views
    [themeSetter themeNavigationBar:self.navigationController.navigationBar];
    
    // Theme the background view
    [themeSetter alternateThemeViewBackground:self.view];
    
    // Set up the button font
    UIFont *buttonFont = [UIFont fontWithName:@"Futura" size:[UIFont buttonFontSize]];

    // Theme both buttons the same
    [themeSetter alternateThemeButton:self.confirmTimeButton withFont:buttonFont];
    [themeSetter alternateThemeButton:self.sleepNowButton withFont:buttonFont];

    // Theme the information label view and increase the font slightly
    UIFont *labelFont = [buttonFont fontWithSize:([UIFont labelFontSize])];
    [themeSetter themeLabel:self.informationLabel withFont:labelFont];
    [self updateViewWithSelectedUserMode:self.selectedUserMode];

    // Lastly theme and add border if needed
    BOOL showBorder = [[SettingsAPI sharedSettingsAPI] showBorder];
    [themeSetter themeBorderForView:self.timeSelectionDatePicker visible:showBorder];
}

#pragma mark - Model Configuration
- (void)configureModel:(id <SleepTimeModeller>)model
{
    // Implement with additional properties
    model.timeToFallAsleep = [[SettingsAPI sharedSettingsAPI] timeToFallAsleep];
}

- (void)performModelCalculation:(id <SleepTimeModeller>)model
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

#pragma mark - Sliding View Management
- (IBAction)toggleSlider:(id)sender
{
    [self.sliderApplication toggleSlider];
}

#pragma mark - View Transitioning
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ResultsViewController *resultsViewController = (ResultsViewController *)segue.destinationViewController;
    resultsViewController.selectedUserMode = self.selectedUserMode;
    
    // Create the model to be used with the resultsViewController
    SleepyTimeModel *model = (id <SleepTimeModeller>)[[SleepyTimeModel alloc] init];

    // Configure the model depending on the button segue
    if ([segue.identifier isEqualToString:AFConfirmTimeButtonSegue])
    {
        [self configureModel:model];
        [self performModelCalculation:model];
        
    } else if ([segue.identifier isEqualToString:AFSleepNowButtonSegue])
    {
        [self configureModel:model];
        [model calculateWakeTimeWithCurrentTime];
    }
    
    // Assign the model and selectedTime
    resultsViewController.model = model;
    resultsViewController.selectedTime = self.timeSelectionDatePicker.date;
}

#pragma mark - SettingsViewControllerDelegate
- (void)settingsViewControllerDidFinish:(SettingsViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Helpers
- (void)updateViewWithSelectedUserMode:(AFSelectedUserMode)selectedUserMode
{
    // Modify the information label based on state and hide the sleep now button if
    // in AFSelectedUserModeCalculateBedTime mode
    switch (selectedUserMode) {
        case AFSelectedUserModeCalculateWakeTime:
            self.informationLabel.text = NSLocalizedString(@"I plan to sleep at", nil);
            self.sleepNowButton.hidden = NO;
            break;
            
        case AFSelectedUserModeCalculateBedTime:
            self.informationLabel.text = NSLocalizedString(@"I would like to wake up at", nil);
            self.sleepNowButton.hidden = YES;
            break;
            
        default:
            break;
    }
}

- (void)prepareLaunchInfoAlertView
{
    // Check the settings if we can show the launch view
    // It's the result of the AND of appJustLaunched and showInfoAlertView
    BOOL showInfoAlertView = [[SettingsAPI sharedSettingsAPI] showInfoAtLaunch];
    BOOL appJustLaunched = [[SettingsAPI sharedSettingsAPI] appJustLaunched];
    BOOL showAlertView = showInfoAlertView && appJustLaunched;
    
    if (showAlertView)
        [self showLaunchInfoAlertView];
    
    // Set the appJustLaunched to NO now.
    [[SettingsAPI sharedSettingsAPI] setAppJustLaunched:NO];
}

- (void)showLaunchInfoAlertView
{
    // The message to display to the user.
    NSString *text = @"The in-app alarm is meant to act as a supplement to the "
                     @"stock Alarm app and not as a replacement.\n\n"
                     @"The Sleep Now button takes into account the time it takes to fall asleep. You can change "
                     @"this in the Settings to the left.\n\n"
                     @"Enjoy :)";
    
    // Building the alertview
    FUIAlertView *launchInfoAlertView = (FUIAlertView *)[self buildAlertView:NSLocalizedString(text, nil)];
    
    // Grab the themeSetter object
    id <Theme> themeSetter = [[ThemeFactory sharedThemeFactory] buildThemeForSettingsKey];
    [themeSetter themeAlertView:launchInfoAlertView];
    
    // Show the alert view.
    [launchInfoAlertView show];
}

- (FUIAlertView *)buildAlertView:(NSString *)alertMessage
{
    FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:NSLocalizedString(@"Welcome!", nil)
                                                          message:alertMessage
                                                         delegate:nil
                                                cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                                                otherButtonTitles:nil];
    return alertView;
}

#pragma mark - End of Life
- (void)dealloc
{
    // Remove observer so notification is not sent to null object
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
