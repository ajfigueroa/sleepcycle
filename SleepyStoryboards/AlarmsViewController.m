//
//  AlarmsViewController.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/9/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import "AlarmsViewController.h"
#import "ThemeProvider.h"

@interface AlarmsViewController ()

@property (nonatomic, strong) id <Theme> themeSetter;
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
    
    // Register for theme change notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyTheme) name:AFThemeHasChangedNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self applyTheme];
}


#pragma mark - Data Source
- (void)populateAlarmsArray
{
    // Lazy initialize the array
    if (!self.alarmsArray)
    {
        self.alarmsArray = [NSMutableArray array];
    }
}

#pragma mark - Theming
- (void)applyTheme
{
    // Apply the theme through the Theme factory
    self.themeSetter = [ThemeProvider theme];
    
    [self.themeSetter themeNavigationBar:self.navigationController.navigationBar];
    [self.themeSetter alternateThemeViewBackground:self.view];
    [self.themeSetter themeTableView:self.tableView];
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
    [self.themeSetter themeViewBackground:cell];
    
    return cell;
}

#pragma mark - End of Life
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
