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
#import "JSSlidingViewController.h"

@interface AlarmsViewController ()

@property (nonatomic, strong) NSMutableArray *alarmsArray;
@property (nonatomic, strong) UILabel *emptyTableLabel;

@end

@implementation AlarmsViewController
{}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // Get rid of unwanted UITableViewCells
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self populateAlarmsArray];
    
    // Register for theme change notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyTheme) name:AFThemeHasChangedNotification object:nil];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Apply theme
    [self applyTheme];

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
}

#pragma mark - SlidingViewController calls
- (IBAction)toggleSlider:(id)sender
{
    BOOL isSliderOpen = [self.applicationDelegate slidingViewController].isOpen;
    
    if (isSliderOpen)
        [[self.applicationDelegate slidingViewController] closeSlider:YES completion:nil];
    else
        [[self.applicationDelegate slidingViewController] openSlider:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.alarmsArray.count;
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

#pragma mark - End of Life
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
