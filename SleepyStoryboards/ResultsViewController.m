//
//  ResultsViewController.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/2/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import "ResultsViewController.h"
#import "BOZPongRefreshControl.h"
#import "ThemeProvider.h"

@interface ResultsViewController ()

@property (nonatomic, strong) NSArray *resultTimes;
@property (nonatomic, strong) BOZPongRefreshControl *pongRefreshControl;
@property (nonatomic) BOOL isPongRefreshControlVisible;
@property (nonatomic, strong) id <Theme> themeSetter;

@end

@implementation ResultsViewController
{}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // Register for theme change notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyTheme) name:AFThemeHasChangedNotification object:nil];
}

#pragma mark - View Management
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.resultTimes = @[@"11:30 PM", @"1:00 AM", @"2:30 AM", @"4:00 AM", @"5:30 AM", @"7:00 AM"];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.isPongRefreshControlVisible = [[NSUserDefaults standardUserDefaults] boolForKey:AFShowEasterEgg];
    
    // Add the pong refresh target to the refreshTriggered action
    self.pongRefreshControl = [BOZPongRefreshControl attachToTableView:self.resultsTableView
                                                      withRefreshTarget:self
                                                       andRefreshAction:@selector(refreshTriggered)];
    
    if (!self.isPongRefreshControlVisible)
        self.resultsTableView.scrollEnabled = NO;
    else
    {
        self.resultsTableView.scrollEnabled = YES;
        self.pongRefreshControl.shouldCoverRefreshControlUnderHeader = YES;
    }
    
    [self applyTheme];
}

#pragma mark - Theme Management
- (void)applyTheme
{
    // Set (or reset) the theme with the appropriate theme object
    self.themeSetter = [ThemeProvider theme];
    
    // Theme the appropriate views
    [self.themeSetter themeNavigationBar:self.navigationController.navigationBar];
    
    // Theme pong refresh control
    if ([self.themeSetter respondsToSelector:@selector(themeRefreshControl:)])
        [self.themeSetter themeRefreshControl:self.pongRefreshControl];
    
    // Theme the background view
    [self.themeSetter themeViewBackground:self.view];
    
    // Theme table view but theme cells in UITableViewDelegate method tableView:cellForRowAtIndexPath:
    [self.themeSetter themeTableView:self.resultsTableView];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.isPongRefreshControlVisible)
        [self.pongRefreshControl scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.isPongRefreshControlVisible)
        [self.pongRefreshControl scrollViewDidEndDragging];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultTimes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ResultsCell"];
    
    cell.textLabel.text = (NSString *)self.resultTimes[(NSUInteger)indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    return cell;
}

#pragma mark - Target Action Methods
- (void)refreshTriggered
{
    // Ask the model for data for the data again although it won't change
    double delayInSeconds = 10.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        // Finish loading the data, reset the refresh control
        [self.pongRefreshControl finishedLoading];
    });
}

#pragma mark - End of Life
- (void)dealloc
{
    // Remove observer so notification is not sent to null object
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

@end
