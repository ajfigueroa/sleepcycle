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
    
    // Configure the segmented control
    [self.themeSegmentedControl addTarget:self action:@selector(changeTheme:) forControlEvents:UIControlEventValueChanged];
}

#pragma mark - View Management
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Register for Theme Change Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyTheme) name:AFThemeHasChangedNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self applyTheme];
}

- (void)viewDidLoad
{
    // This will not be in final release.
    [super viewDidLoad];
    
    NSInteger currentThemeSelection = [[NSUserDefaults standardUserDefaults] integerForKey:kAppTheme];
    
    NSInteger selectedIndex = 0;
    
    switch (currentThemeSelection) {
        case kBlueBeigeTheme:
            selectedIndex = 0;
            break;
        case kBlackGrayTheme:
            selectedIndex = 1;
            break;
        case kRedRoseTheme:
            selectedIndex = 2;
            break;
        default:
            break;
    }
    
    self.themeSegmentedControl.selectedSegmentIndex = selectedIndex;
}

#pragma mark - Theme Change Methods
- (void)applyTheme
{
    // Set (or reset) the theme with the appropriate theme object
    self.themeSetter = [ThemeProvider theme];
    
    // Theme the appropriate views
    [self.themeSetter themeNavigationBar:self.navigationController.navigationBar];
    
    [self.themeSetter themeViewBackground:self.view];
    
    // Theme the buttons
    for (FUIButton *button in @[self.calculateBedTimeButton, self.calculateWakeTimeButton, self.settingsButton])
    {
        UIFont *buttonFont = [UIFont fontWithName:@"Futura-Medium" size:[UIFont systemFontSize]];
        [self.themeSetter themeButton:button withFont:buttonFont];
    }
}

- (void)changeTheme:(UISegmentedControl *)segmentedControl
{
    NSLog(@"Theme is being changed");
    
    ThemeSelectionOption themeSelection;
    
    switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            themeSelection = kBlueBeigeTheme;
            NSLog(@"Theme is going Blue and Beige");
            break;
        case 1:
            themeSelection = kBlackGrayTheme;
            NSLog(@"Theme is going Black and Gray");
            break;
        case 2:
            themeSelection = kRedRoseTheme;
            NSLog(@"Theme is going Reddish");
            break;
        default:
            themeSelection = kBlueBeigeTheme;
            NSLog(@"Default");
            break;
    }
    
    // Write the theme to defaults
    [[NSUserDefaults standardUserDefaults] setInteger:(NSInteger)themeSelection forKey:kAppTheme];
    
    // Syncronize the views and update
    NSLog(@"Syncronizing and updating");
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"Posting notification");
    [[NSNotificationCenter defaultCenter] postNotificationName:AFThemeHasChangedNotification object:self];
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:AFCalculateBedTimeSegue])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:AFSelectedCalculateBedTimeNotification object:nil];
    }
    else if ([segue.identifier isEqualToString:AFCalculateWakeTimeSegue])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:AFSelectedCalculateWakeTimeNotification object:nil];
    }
}

#pragma mark - End of Life
- (void)dealloc
{
    // Remove observer so notification is not sent to null object
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

@end
