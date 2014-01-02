//
//  SettingsViewController.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/2/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import "SettingsViewController.h"
#import "ThemeProvider.h"

@interface SettingsViewController ()

@property (nonatomic, strong) NSString *currentThemeName;
@property (nonatomic, strong) NSMutableDictionary *themeDictionary;
// Manage the theming of the view
@property (nonatomic, strong) id <Theme> themeSetter;

@end

#define AVAILABLE_THEMES_COUNT 3
// Manage important sections and rows of the STATIC table view cell
#define BEHAVIOUR_SECTION 1
#define SHOW_PINGPONG_EASTER_EGG_ROW 0

@implementation SettingsViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        // Build Theme Dictionary
        [self buildThemeDictionary];
        
        self.currentThemeName = [self currentApplicationTheme];
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
    for (int i = 0; i < AVAILABLE_THEMES_COUNT; i++)
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
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.themeSelectionLabel.text = self.currentThemeName;
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
    self.themeSelectionLabel.text = self.currentThemeName;
    
    [self setCurrentApplicationTheme:themeName];
    
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.navigationController popViewControllerAnimated:YES];
    });
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch ((NSUInteger)indexPath.section) {
        case BEHAVIOUR_SECTION:
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
        case SHOW_PINGPONG_EASTER_EGG_ROW:
            [self updateShowPingPongEasterEggSetting];
            break;
            
        default:
            break;
    }
}

- (void)updateShowPingPongEasterEggSetting
{
    // Update the show ping pong easter egg setting
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:SHOW_PINGPONG_EASTER_EGG_ROW inSection:BEHAVIOUR_SECTION]];
    
    // Determine current state and toggle
    BOOL isVisible = (cell.accessoryType == UITableViewCellAccessoryCheckmark);
    
    if (isVisible)
    {
        // Toggle and update default settings to NOT show this easter egg
    }
    else
    {
        // Toggle and update default settings to show this easter egg
    }
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
