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
#import "AlarmCell.h"
#import "EmptyTableViewBackground.h"

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
    self.tableView.backgroundView = [[EmptyTableViewBackground alloc] initWithFrame:self.tableView.frame];
    
    // Apply theme
    [self applyTheme];

    // Register for theme change notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applyTheme)
                                                 name:AFThemeHasChangedNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Disable edit mode
    [self.tableView setEditing:NO animated:YES];
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
    
    [self.tableView reloadData];
}

- (void)updateCell:(AlarmCell *)cell atIndex:(NSIndexPath *)indexPath
{
    // Theme the cells with the primary theme
    id <Theme> themeSetter = [[ThemeFactory sharedThemeFactory] buildThemeForSettingsKey];
    [themeSetter themeAlarmCell:cell];
    
    NSDate *alarmTime = [(UILocalNotification *)self.alarmsArray[indexPath.row] fireDate];
    
    cell.alarmTimeLabel.text = [NSString stringWithFormat:@"%@", [alarmTime shortTime]];
    cell.alarmDateLabel.text = [NSString stringWithFormat:@"%@", [alarmTime shortDate]];
    cell.alarmTimeLabel.font = [UIFont fontWithName:@"Futura" size:[UIFont buttonFontSize] + 2];
    cell.alarmDateLabel.font = [UIFont fontWithName:@"Futura" size:[UIFont labelFontSize]];
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

#pragma mark - Helpers
- (void)configureViewForEmptyTableView
{
    [self.navigationItem setRightBarButtonItem:nil animated:YES];
    self.tableView.backgroundView.hidden = NO;
}

- (void)configureViewForNonEmptyTableView
{
    self.tableView.backgroundView.hidden = YES;
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
        [self configureViewForEmptyTableView];
    else
        [self configureViewForNonEmptyTableView];
    
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlarmCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlarmCell"];
    
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
