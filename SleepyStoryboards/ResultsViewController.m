//
//  ResultsViewController.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/2/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import "ResultsViewController.h"
#import "BOZPongRefreshControl.h"

@interface ResultsViewController ()

@property (nonatomic, strong) NSArray *resultTimes;
@property (nonatomic, strong) BOZPongRefreshControl *pongRefreshControl;

@end

@implementation ResultsViewController
{}

#pragma mark - View Management
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.resultTimes = @[@"11:30 PM", @"1:00 AM", @"2:30 AM", @"4:00 AM", @"5:30 AM", @"7:00 AM"];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.pongRefreshControl = [BOZPongRefreshControl attachToTableView:self.resultsTableView withRefreshTarget:self andRefreshAction:@selector(refreshTriggered)];
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.pongRefreshControl scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
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

@end
