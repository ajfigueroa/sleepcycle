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
    
    // Register for Theme Change Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyTheme) name:AFThemeHasChangedNotification object:nil];
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
        case AFBehaviourSection:
            [self updateBehaviourSettings:(NSUInteger)indexPath.row];
            break;
            
        default:
            break;
    }
}

#pragma mark - Settings Management
- (void)updateBehaviourSettings:(NSUInteger)behaviourOption
{
    switch (behaviourOption) {
        case AFShowPingPongEasterEggRow:
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
    // Update the show ping pong easter egg setting based on the user defaults
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:AFShowPingPongEasterEggRow inSection:AFBehaviourSection]];
    
    // Grab current setting from user defaults
    BOOL isVisible = [[NSUserDefaults standardUserDefaults] boolForKey:AFShowEasterEgg];
    
    cell.accessoryType = isVisible ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
}

- (void)toggleShowPingPongEasterEggSetting
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:AFShowPingPongEasterEggRow inSection:AFBehaviourSection];
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
}

- (void)updateAllSettings
{
    // Update all settings based on their initialization methods
    [self updateThemeSelectionLabel];
    [self updateShowPingPongEasterEggSetting];
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
    
}

@end
