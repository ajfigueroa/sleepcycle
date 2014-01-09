//
//  SettingsViewController.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/2/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import "SettingsViewController.h"
#import "ThemeProvider.h"
#import "SettingsSelectionConstants.h"
#import "ThemeSettingsManager.h"
#import "SettingsManager.h"

@interface SettingsViewController ()

// Theme Settings
@property (nonatomic, strong) ThemeSettingsManager *themeSettingsManager;
// Manage the theming of the view
@property (nonatomic, strong) id <Theme> themeSetter;

@end

@implementation SettingsViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        // Setup ThemeSettingManager
        self.themeSettingsManager = [[ThemeSettingsManager alloc] init];
    }
    
    return self;
}

#pragma mark - View Management
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self applyTheme];
    [self updateAllSettings];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Register the minutes slider to update the label
    [self.minutesSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    // Register for Theme Change Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyTheme) name:AFThemeHasChangedNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
   
    // Commit any unsaved changes in case the user confirms full disappear of view
    [self commitMinutesSliderValue];
    
    // Commit current state of toggle buttons
    [[SettingsManager sharedSettings] setShowBorder:self.showBorderSwitch.on];
    [[SettingsManager sharedSettings] setShowEasterEgg:self.showPingPongSwitch.on];
    
    // Lastly, scroll to top
    [self.tableView scrollsToTop];
}


#pragma mark - Theme Management
- (void)applyTheme
{
    self.themeSetter = [ThemeProvider theme];
    
    [self.themeSetter themeNavigationBar:self.navigationController.navigationBar];
    [self.themeSetter themeSwitch:self.showBorderSwitch];
    [self.themeSetter themeSwitch:self.showPingPongSwitch];
    [self.themeSetter themeSwitch:self.showTutorialSwitch];
    [self.themeSetter themeSlider:self.minutesSlider];
    
}

#pragma mark - ThemeSelectionViewControllerDelegate
- (void)themeSelectionViewController:(ThemeSelectionViewController *)controller didSelectTheme:(NSString *)themeName
{
    self.themeSettingsManager.themeName = themeName;
    [self updateThemeSelectionLabel];
    
    [self.themeSettingsManager setDefaultApplicationTheme:themeName];
}

#pragma mark - Settings Management
- (void)updateThemeSelectionLabel
{
    // Update the label based on the current theme inside the manager
    self.themeSelectionLabel.text = self.themeSettingsManager.themeName;
}


- (void)updateShowPingPongEasterEggSetting
{
    self.showPingPongSwitch.on = [[SettingsManager sharedSettings] showEasterEgg];
}

- (void)updateShowBorderSetting
{
    self.showBorderSwitch.on = [[SettingsManager sharedSettings] showBorder];
}

- (void)updateMinuteSlider
{
    NSInteger minutesToFallAsleep = [[SettingsManager sharedSettings] timeToFallAsleep];
    self.minutesSlider.value = minutesToFallAsleep;
    
    [self updateMinutesLabel:minutesToFallAsleep];
}

- (void)commitMinutesSliderValue
{
    // Update the settings manager with the new minutes value
    [[SettingsManager sharedSettings] setTimeToFallAsleep:(NSInteger)self.minutesSlider.value];
}

- (void)updateMinutesLabel:(NSInteger)minutes
{
    if (minutes <= 1)
        self.minutesLabel.text = [NSString stringWithFormat:@"%ld min", (long)minutes];
    else
        self.minutesLabel.text = [NSString stringWithFormat:@"%ld mins", (long)minutes];
}

- (void)updateAllSettings
{
    // Update all settings based on their initialization methods
    [self updateThemeSelectionLabel];
    [self updateShowPingPongEasterEggSetting];
    [self updateShowBorderSetting];
    [self updateMinuteSlider];
}

#pragma mark - Target Action Methods
- (void)sliderValueChanged:(UISlider *)slider
{
    [self updateMinutesLabel:(NSInteger)slider.value];
}

- (IBAction)done:(id)sender
{
    // Inform delegate that business is done.
    [self.delegate settingsViewControllerDidFinish:self];
}


#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:AFThemeSelectionSegue])
    {
        ThemeSelectionViewController *themeSelectionViewController = (ThemeSelectionViewController *)segue.destinationViewController;
        themeSelectionViewController.delegate = self;
        themeSelectionViewController.themeName = self.themeSettingsManager.themeName;
        themeSelectionViewController.themes = [self.themeSettingsManager themeNamesSortedByIndex];
    }
}

#pragma mark - End of Life
- (void)dealloc
{
    // Remove observer so notification is not sent to null object
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // Deregister the minutes slider to update the label
    [self.minutesSlider removeTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
}

@end
