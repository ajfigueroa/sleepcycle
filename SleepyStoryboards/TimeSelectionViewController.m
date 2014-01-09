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
#import "SettingsManager.h"
#import "JSSlidingViewController.h"

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
    
    // Register for Theme Change Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applyTheme)
                                                 name:AFThemeHasChangedNotification
                                               object:nil];
}

#pragma mark - Accessors
- (void)setSelectedUserMode:(AFSelectedUserMode)selectedUserMode
{
    if (_selectedUserMode != selectedUserMode)
    {
        _selectedUserMode = selectedUserMode;
        [self updateViewWithSelectedUserMode:_selectedUserMode];
    }
}


#pragma mark - Control View Management
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Update theme
    [self applyTheme];
    
    dispatch_queue_t borderQueue = dispatch_queue_create("Border Queue", NULL);
    
    dispatch_async(borderQueue, ^{
        BOOL applyBorder = [[SettingsManager sharedSettings] showBorder];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (applyBorder)
                [self applyBorderToView:self.timeSelectionDatePicker WithColor:nil width:1.5f];
        });
    });
    
    // Unlock the slider if this view controller is the root
    [self.applicationDelegate slidingViewController].locked = NO;
}

- (void)updateViewWithSelectedUserMode:(AFSelectedUserMode)selectedUserMode
{
    // Modify the information label based on state and hide the sleep now button if
    // in AFSelectedUserModeCalculateBedTime
    switch (selectedUserMode) {
        case AFSelectedUserModeCalculateWakeTime:
            self.informationLabel.text = @"I plan to sleep at:";
            self.sleepNowButton.hidden = NO;
            break;
            
        case AFSelectedUserModeCalculateBedTime:
            self.informationLabel.text = @"I have to wake up at";
            self.sleepNowButton.hidden = YES;
            break;
            
        default:
            break;
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

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    // Clear any color mapping from previous states
    [[NSNotificationCenter defaultCenter] postNotificationName:AFColorMappingResetNotification object:nil];
    
    // Lock the slider if a view controller is pushed onto the stack
    [self.applicationDelegate slidingViewController].locked = YES;
}


#pragma mark - Theme Change Methods
- (void)applyTheme
{
    dispatch_queue_t setupThemeQueue = dispatch_queue_create("Theme Queue", NULL);
    dispatch_async(setupThemeQueue, ^{
        // Set (or reset) the theme with the appropriate theme object
        self.themeSetter = [ThemeProvider theme];
        
        dispatch_async(dispatch_get_main_queue(), ^{
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
            
            [self updateViewWithSelectedUserMode:self.selectedUserMode];
        });
    });
}

#pragma mark - Model Configuration
- (void)configureModel:(SleepyTimeModel *)model
{
    // Implement with additional properties
    model.timeToFallAsleep = [[SettingsManager sharedSettings] timeToFallAsleep];
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

#pragma mark - Sliding View Management
- (IBAction)toggleSlider:(id)sender
{
    if ([[self.applicationDelegate slidingViewController] isOpen]) {
        [[self.applicationDelegate slidingViewController] closeSlider:YES completion:nil];
    } else {
        [[self.applicationDelegate slidingViewController] openSlider:YES completion:nil];
    }
}

#pragma mark - View Transitioning
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ResultsViewController *resultsViewController = (ResultsViewController *)segue.destinationViewController;
    resultsViewController.selectedUserMode = self.selectedUserMode;
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

#pragma mark - SettingsViewControllerDelegate
- (void)settingsViewControllerDidFinish:(SettingsViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - End of Life
- (void)dealloc
{
    // Remove observer so notification is not sent to null object
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"Deallocating: %s", __PRETTY_FUNCTION__);
}


@end
