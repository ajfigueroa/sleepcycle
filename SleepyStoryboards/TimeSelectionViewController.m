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
    // Update theme
    [self applyTheme];
    
}

#pragma mark - Control View Management
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    dispatch_queue_t borderQueue = dispatch_queue_create("Border Queue", NULL);
    
    dispatch_async(borderQueue, ^{
        BOOL applyBorder = [[NSUserDefaults standardUserDefaults] boolForKey:AFShowDatePickerBorder];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (applyBorder)
                [self applyBorderToView:self.timeSelectionDatePicker WithColor:nil width:1.5f];
        });
    });
}

- (void)updateViewWithSelectedUserMode:(AFSelectedUserMode)selectedUserMode
{
    // Modify the information label based on state and hide the sleep now button if
    // in AFSelectedUserModeCalculateBedTime
    switch (selectedUserMode) {
        case AFSelectedUserModeCalculateWakeTime:
            self.informationLabel.text = @"Choose your bed time";
            break;
            
        case AFSelectedUserModeCalculateBedTime:
            self.informationLabel.text = @"Choose your wake-up time";
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
    model.timeToFallAsleep = [[NSUserDefaults standardUserDefaults] integerForKey:AFTimeToFallAsleepInMinutes];
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

#pragma mark - End of Life
- (void)dealloc
{
    // Remove observer so notification is not sent to null object
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"Deallocating: %s", __PRETTY_FUNCTION__);
}

@end
