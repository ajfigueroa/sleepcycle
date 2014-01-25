//
//  ThemeSelectionViewController.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/2/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import "ThemeSelectionViewController.h"
#import "ThemeFactory.h"

@interface ThemeSelectionViewController ()

@property (nonatomic) NSUInteger selectedThemeIndex;

@end

@implementation ThemeSelectionViewController
{}

#pragma mark - View Management
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.selectedThemeIndex = [self.themes indexOfObject:self.themeName];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Register for Theme Change Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyTheme) name:AFThemeHasChangedNotification object:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.themes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ThemeCell"];

    cell.textLabel.text = (NSString *)self.themes[indexPath.row];
    
    // Apply Checkmark accessory to the selected indexpath
    if (indexPath.row == self.selectedThemeIndex)
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

#pragma mark - Theme Management
- (void)applyTheme
{
    id <Theme> themeSetter = [[ThemeFactory sharedThemeFactory] buildThemeForSettingsKey];
    
    [themeSetter themeNavigationBar:self.navigationController.navigationBar];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Deselect current row to avoid highlight
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Remove checkmark accessory rom the previously selected index path
    NSIndexPath *previousIndexPath = [NSIndexPath indexPathForRow:self.selectedThemeIndex inSection:0];
    
    UITableViewCell *previousCell = [tableView cellForRowAtIndexPath:previousIndexPath];
    previousCell.accessoryType = UITableViewCellAccessoryNone;

    // Update the selected theme by adding the checkmark accessory
    self.selectedThemeIndex = indexPath.row;
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;

    // Send the now selected theme to the delegate
    NSString *selectedThemeName = (NSString *)self.themes[indexPath.row];
    [self.delegate themeSelectionViewController:self didSelectTheme:selectedThemeName];
}

#pragma mark - End of Life
- (void)dealloc
{
    // Remove observer so notification is not sent to null object
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

@end
