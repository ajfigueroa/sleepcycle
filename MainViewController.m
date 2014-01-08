//
//  MainViewController.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 12/30/2013.
//  Copyright (c) 2013 Alexander Figueroa. All rights reserved.
//

#import "MainViewController.h"
#import "ThemeProvider.h"
#import "TimeSelectionViewController.h"
#import "JSSlidingViewController.h"

@interface MainViewController ()

// Manage the theming of the view
@property (nonatomic, strong) id <Theme> themeSetter;

@end

// Segue Identifier
static NSString *const kTimeSelectionSegueIdentifier = @"SelectTime";

@implementation MainViewController
{}

#pragma mark - View Initialization
- (void)awakeFromNib
{
    [super awakeFromNib];
    NSLog(@"Awaking from nib: %s", __PRETTY_FUNCTION__);
}

#pragma mark - View Management
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self applyTheme];
    
    // Register for Theme Change Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyTheme) name:AFThemeHasChangedNotification object:nil];
    
    // Unlock the slider if this view controller is the root
    [self.applicationDelegate slidingViewController].locked = NO;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    // Lock the slider if a view controller is pushed onto the stack
    [self.applicationDelegate slidingViewController].locked = YES;
}

- (IBAction)toggleSlider:(id)sender
{
    if ([[self.applicationDelegate slidingViewController] isOpen]) {
        [[self.applicationDelegate slidingViewController] closeSlider:YES completion:nil];
    } else {
        [[self.applicationDelegate slidingViewController] openSlider:YES completion:nil];
    }
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
            
            [self.themeSetter themeViewBackground:self.view];
            
            // Theme the buttons
            for (FUIButton *button in @[self.calculateBedTimeButton, self.calculateWakeTimeButton, self.alarmButton])
            {
                UIFont *buttonFont = [UIFont fontWithName:@"Futura" size:[UIFont buttonFontSize]];
                [self.themeSetter themeButton:button withFont:buttonFont];
            }
        });
    });
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:AFCalculateBedTimeSegue])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:AFSelectedCalculateBedTimeNotification object:nil];
        TimeSelectionViewController *timeSelectionViewController = (TimeSelectionViewController *)segue.destinationViewController;
        timeSelectionViewController.selectedUserMode = AFSelectedUserModeCalculateBedTime;
    }
    else if ([segue.identifier isEqualToString:AFCalculateWakeTimeSegue])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:AFSelectedCalculateWakeTimeNotification object:nil];
        TimeSelectionViewController *timeSelectionViewController = (TimeSelectionViewController *)segue.destinationViewController;
        timeSelectionViewController.selectedUserMode = AFSelectedUserModeCalculateWakeTime;
    }
    else if ([segue.identifier isEqualToString:AFSettingsSegue])
    {
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        SettingsViewController *settingsViewController = (SettingsViewController *)navController.viewControllers.firstObject;
        settingsViewController.delegate = self;
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
    
}

@end
