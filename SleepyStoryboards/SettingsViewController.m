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
   
    // Commit any unsaved changes
    [self commitMinutesSliderValue];
}


#pragma mark - Theme Management
- (void)applyTheme
{
    self.themeSetter = [ThemeProvider theme];
    
    [self.themeSetter themeNavigationBar:self.navigationController.navigationBar];
}

#pragma mark - ThemeSelectionViewControllerDelegate
- (void)themeSelectionViewController:(ThemeSelectionViewController *)controller didSelectTheme:(NSString *)themeName
{
    self.themeSettingsManager.themeName = themeName;
    [self updateThemeSelectionLabel];
    
    [self.themeSettingsManager setDefaultApplicationTheme:themeName];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch ((NSUInteger)indexPath.section) {
        case AFSectionTitleBehaviour:
            [self updateBehaviourSettings:(NSUInteger)indexPath.row];
            break;
        case AFSectionTitleAppearance:
            [self updateAppearanceSettings:(NSUInteger)indexPath.row];
            break;
        default:
            break;
    }
}

#pragma mark - Settings Management
- (void)updateAppearanceSettings:(NSUInteger)appearanceOption
{
    switch (appearanceOption) {
        case AFAppearanceSettingShowBorder:
            [self toggleShowBorderSetting];
            break;
            
        default:
            break;
    }
}

- (void)updateBehaviourSettings:(NSUInteger)behaviourOption
{
    switch (behaviourOption) {
        case AFBehaviourSettingShowEasterEgg:
            // Toggle the setting
            [self toggleShowPingPongEasterEggSetting];
            break;
            
        default:
            break;
    }
}

- (void)updateThemeSelectionLabel
{
    // Update the label based on the current theme inside the manager
    self.themeSelectionLabel.text = self.themeSettingsManager.themeName;
}


- (void)updateShowPingPongEasterEggSetting
{
    NSIndexPath *showPingPongSettingPath = [NSIndexPath indexPathForRow:AFBehaviourSettingShowEasterEgg inSection:AFSectionTitleBehaviour];
    
    [self updateBooleanSettingForTableView:self.tableView atIndexPath:showPingPongSettingPath forKey:AFShowEasterEgg];
}

- (void)updateShowBorderSetting
{
    NSIndexPath *showBorderSettingPath = [NSIndexPath indexPathForRow:AFAppearanceSettingShowBorder inSection:AFSectionTitleAppearance];
    [self updateBooleanSettingForTableView:self.tableView atIndexPath:showBorderSettingPath forKey:AFShowDatePickerBorder];
}

- (void)updateBooleanSettingForTableView:(UITableView *)tableView
                             atIndexPath:(NSIndexPath *)indexPath
                                  forKey:(NSString *)key
{
    // Update the show ping pong easter egg setting based on the user defaults
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    // Grab current setting from user defaults
    BOOL isVisible = [[NSUserDefaults standardUserDefaults] boolForKey:key];
    
    cell.accessoryType = isVisible ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
}

- (void)toggleShowBorderSetting
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:AFAppearanceSettingShowBorder inSection:AFSectionTitleAppearance];
    [self toggleBooleanSettingForTableView:self.tableView atIndexPath:indexPath forKey:AFShowDatePickerBorder];
}

- (void)toggleShowPingPongEasterEggSetting
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:AFBehaviourSettingShowEasterEgg inSection:AFSectionTitleBehaviour];
    [self toggleBooleanSettingForTableView:self.tableView atIndexPath:indexPath forKey:AFShowEasterEgg];
}

- (void)toggleBooleanSettingForTableView:(UITableView *)tableView
                             atIndexPath:(NSIndexPath *)indexPath
                                  forKey:(NSString *)key
{
    // Assumes that state is determined by prescence of a checkmark
    
    // Update the show ping pong easter egg setting based on the user defaults
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    // Grab prescence of checkmark
    BOOL hasCheckMarkAccessory = (cell.accessoryType == UITableViewCellAccessoryCheckmark);
    
    cell.accessoryType = hasCheckMarkAccessory ? UITableViewCellAccessoryNone : UITableViewCellAccessoryCheckmark;
    
    // Register the new state to user defaults
    [[NSUserDefaults standardUserDefaults] setBool:!hasCheckMarkAccessory forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)updateMinuteSlider
{
    NSInteger minutesToFallAsleep = [[NSUserDefaults standardUserDefaults] integerForKey:AFTimeToFallAsleepInMinutes];
    self.minutesSlider.value = minutesToFallAsleep;
    
    [self updateMinutesLabel:minutesToFallAsleep];
}

- (void)commitMinutesSliderValue
{
    [[NSUserDefaults standardUserDefaults] setInteger:(NSInteger)self.minutesSlider.value
                                               forKey:AFTimeToFallAsleepInMinutes];
    [[NSUserDefaults standardUserDefaults] synchronize];
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
