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

@interface SettingsViewController ()

@property (nonatomic, strong) NSString *currentThemeName;
@property (nonatomic, strong) NSMutableDictionary *themeDictionary;
// Manage the theming of the view
@property (nonatomic, strong) id <Theme> themeSetter;

@end

@implementation SettingsViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        // Build Theme Dictionary
        [self buildThemeDictionary];
        
    }
    
    return self;
}

#pragma mark - Updating Theme
- (NSString *)currentApplicationTheme
{
    AFThemeSelectionOption option = (AFThemeSelectionOption)[[NSUserDefaults standardUserDefaults] integerForKey:AFAppTheme];
    
    if (!self.themeDictionary)
        [self buildThemeDictionary];
    
    return (NSString *)self.themeDictionary[[@(option) stringValue]];
}

- (void)buildThemeDictionary
{
    if (!self.themeDictionary)
        self.themeDictionary = [[NSMutableDictionary alloc] init];
    
    // Map the indices as strings to the theme name values
    for (int i = 0; i < AFAvailableThemesCount; i++)
    {
        self.themeDictionary[[@(i) stringValue]] = [self themeName:i];
    }
}

- (NSArray *)sortedThemeNames
{
    // Assumes the theme dictionary has been built
    if (!self.themeDictionary)
        [self buildThemeDictionary];
    
    NSArray *sortedKeys = [[self.themeDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)];
    NSMutableArray *sortedValues = [NSMutableArray array];
    
    for (NSString *key in sortedKeys)
    {
        [sortedValues addObject:[self.themeDictionary objectForKey:key]];
    }
    
    return (NSArray *)sortedValues;
}

- (NSString *)themeName:(AFThemeSelectionOption)option
{
    switch (option) {
        case AFBlueBeigeTheme:
            return @"Blue & Beige";
            break;
        case AFBlackGrayTheme:
            return @"Black & Gray";
            break;
        case AFRedRoseTheme:
            return @"Red & Rose";
            break;
        default:
            return @"";
            break;
    }
}

- (void)setCurrentApplicationTheme:(NSString *)newThemeName
{
    NSArray *validIndices = [self.themeDictionary allKeysForObject:newThemeName];
    
    if (validIndices.count > 0)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:AFThemeHasChangedNotification object:nil];
        });
        
        NSInteger option = [(NSString *)validIndices.firstObject integerValue];
        [[NSUserDefaults standardUserDefaults] setInteger:option forKey:AFAppTheme];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
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
    self.currentThemeName = themeName;
    [self updateThemeSelectionLabel];
    
    [self setCurrentApplicationTheme:themeName];
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
    if (!self.currentThemeName)
        self.currentThemeName = [self currentApplicationTheme];
    
    self.themeSelectionLabel.text = self.currentThemeName;
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
        themeSelectionViewController.themeName = self.currentThemeName;
        themeSelectionViewController.themes = [self sortedThemeNames];
    }
}

#pragma mark - End of Life
- (void)dealloc
{
    // Remove observer so notification is not sent to null object
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

@end
