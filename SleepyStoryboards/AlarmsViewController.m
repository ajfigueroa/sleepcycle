//
//  AlarmsViewController.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/9/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import "AlarmsViewController.h"
#import "ThemeFactory.h"
#import "NSDate+SleepTime.h"

@interface AlarmsViewController ()

@property (nonatomic, strong) NSMutableArray *alarmsArray;
@property (nonatomic, strong) UILabel *emptyTableLabel;

@end

@implementation AlarmsViewController
{}

#pragma mark - View Management
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Set up data source
    [self populateAlarmsArray];
    
    // Get rid of unwanted UITableViewCells
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // Apply theme
    [self applyTheme];

    // Register for theme change notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applyTheme)
                                                 name:AFThemeHasChangedNotification
                                               object:nil];
}
#pragma mark - Data Source
- (void)populateAlarmsArray
{
    // Lazy initialize the array
    if (!self.alarmsArray)
        self.alarmsArray = [[[UIApplication sharedApplication] scheduledLocalNotifications] mutableCopy];
}

#pragma mark - Theming
- (void)applyTheme
{
    // Apply the theme through the Theme factory
    id <Theme> themeSetter = [[ThemeFactory sharedThemeFactory] buildThemeForSettingsKey];
    
    [themeSetter themeNavigationBar:self.navigationController.navigationBar];
    [themeSetter alternateThemeViewBackground:self.view];
    [themeSetter themeTableView:self.tableView];
    self.tableView.separatorColor = [UIColor blackColor];
}

- (void)updateCell:(UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath
{
    NSDate *alarmTime = [(UILocalNotification *)self.alarmsArray[indexPath.row] fireDate];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [alarmTime shortTime]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [alarmTime shortDate]];
    cell.textLabel.font = [UIFont fontWithName:@"Futura" size:[UIFont buttonFontSize] + 2];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Futura" size:[UIFont labelFontSize]];
    cell.gestureRecognizers = nil;
}

#pragma mark - SlidingViewController calls
- (IBAction)toggleSlider:(id)sender
{
    [self.applicationDelegate toggleSlider];
}

- (IBAction)toggleEditMode:(id)sender
{
    [self.tableView setEditing:!self.tableView.editing animated:YES];
}

#pragma mark - UITableViewDelegate
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowCount = self.alarmsArray.count;
    
    if (rowCount == 0)
        self.navigationItem.rightBarButtonItem = nil;
    else
        self.navigationItem.rightBarButtonItem = self.editButton;
    
    
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlarmCell"];
    
    // Theme the cells with the primary theme
    id <Theme> themeSetter = [[ThemeFactory sharedThemeFactory] buildThemeForSettingsKey];
    [themeSetter themeViewBackground:cell];
    
    [self updateCell:cell atIndex:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILocalNotification *localNotification = (UILocalNotification *)self.alarmsArray[(NSUInteger)indexPath.row];
    
    // Remove from array
    [self.alarmsArray removeObject:localNotification];
    
    // Remove from application scheduled notifications
    [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
    
    [tableView deleteRowsAtIndexPaths:@[indexPath]
                     withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - SettingsViewControllerDelegate
- (void)settingsViewControllerDidFinish:(SettingsViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - End of Life
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
