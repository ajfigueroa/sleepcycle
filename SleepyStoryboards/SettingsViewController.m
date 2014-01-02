//
//  SettingsViewController.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/2/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@property (nonatomic, strong) NSString *currentThemeName;
@property (nonatomic, strong) NSMutableDictionary *themeDictionary;

@end

#define AVAILABLE_THEMES_COUNT 3

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
    
    for (int i = 0; i < AVAILABLE_THEMES_COUNT; i++)
    {
        self.themeDictionary[[@(i) stringValue]] = [self themeName:i];
    }
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
            return @"Red & White";
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

#pragma mark - ThemeSelectionViewControllerDelegate
- (void)themeSelectionViewController:(ThemeSelectionViewController *)controller didSelectTheme:(NSString *)themeName
{
    self.currentThemeName = themeName;
    self.themeSelectionLabel.text = self.currentThemeName;
    
    [self setCurrentApplicationTheme:themeName];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:AFThemeSelectionSegue])
    {
        ThemeSelectionViewController *themeSelectionViewController = (ThemeSelectionViewController *)segue.destinationViewController;
        themeSelectionViewController.delegate = self;
        themeSelectionViewController.themeName = self.currentThemeName;
    }
}

@end
