//
//  ResultsViewController.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/2/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import "ResultsViewController.h"
#import "BOZPongRefreshControl.h"
#import "ThemeFactory.h"
#import "NSDate+SleepTime.h"
#import "SettingsAPI.h"
#import "SchedulerAPI.h"
#import "ActionSheetPresenter.h"
#import "ActionSheetHandler.h"
#import "FSAlertView.h"

@interface ResultsViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSArray *resultTimes;
@property (nonatomic, assign) BOOL isPongRefreshControlVisible;
@property (nonatomic, strong) BOZPongRefreshControl *pongRefreshControl;
@property (nonatomic, strong) ActionSheetPresenter *actionSheetPresenter;
@property (nonatomic, strong) ActionSheetHandler *actionSheetHandler;

// The top and bottom mask view are covering the slide to refresh view controller
@property (weak, nonatomic) IBOutlet UIView *topMaskView;
@property (weak, nonatomic) IBOutlet UIView *bottomMaskView;

// alarmButton outlet to control visibility
@property (weak, nonatomic) IBOutlet UIBarButtonItem *selectedTimeAlarmButton;

@end

@implementation ResultsViewController
{}

#pragma mark - View Management
- (void)viewWillAppear:(BOOL)animated
{
    // Register for theme change notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applyTheme)
                                                 name:AFThemeHasChangedNotification
                                               object:nil];
    
    // Register for Alarm and Reminder status notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(alarmPosted:)
                                                 name:AFAlarmHasPostedNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reminderPosted:)
                                                 name:AFReminderHasPostedNotification
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.applicationDelegate lockSlider];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.applicationDelegate unlockSlider];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set up model
    self.resultTimes = self.model.timeDataSource;
    
    // Create long press gesture recognizer
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPressGestureRecognizer.minimumPressDuration = 1.0f; // seconds
    longPressGestureRecognizer.delegate = self;
    
    // Add to table view
    [self.resultsTableView addGestureRecognizer:longPressGestureRecognizer];
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.isPongRefreshControlVisible = [[SettingsAPI sharedSettingsAPI] showEasterEgg];
        
    // Add the pong refresh target to the refreshTriggered action
    self.pongRefreshControl = [BOZPongRefreshControl attachToTableView:self.resultsTableView
                                                     withRefreshTarget:self
                                                      andRefreshAction:@selector(refreshTriggered)];

    if (!self.isPongRefreshControlVisible)
        self.resultsTableView.scrollEnabled = NO;
    else {
        self.resultsTableView.scrollEnabled = YES;
        self.pongRefreshControl.shouldCoverRefreshControlUnderHeader = YES;
    }
    
    [self applyTheme];
}

- (void)updateViewWithSelectedUserMode:(AFSelectedUserMode)selectedUserMode
{
    switch (selectedUserMode) {
        case AFSelectedUserModeCalculateWakeTime:
            self.resultsInformationLabel.text = NSLocalizedString(@"You should wake up at these times:", nil);
            // Hide the selectedTimeAlarm UIBarButtonItem from the navigation bar
            self.navigationItem.rightBarButtonItem = nil;
            break;
            
        case AFSelectedUserModeCalculateBedTime:
            self.resultsInformationLabel.text = NSLocalizedString(@"You should fall asleep at these times:", nil);
            break;
        
        default:
            break;
    }
}

#pragma mark - Model Management
- (void)updateCell:(UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath
{
    cell.textLabel.text = [(NSDate *)self.resultTimes[(NSUInteger)indexPath.row] shortTime];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    // Reverse base on the user choice
    BOOL reverse = (self.selectedUserMode == AFSelectedUserModeCalculateBedTime) ? YES: NO;
    
    id <Theme> themeSetter = [[ThemeFactory sharedThemeFactory] buildThemeForSettingsKey];
    
    // Indivudally theme the table cell
    [themeSetter themeTableViewCell:cell
                        inTableView:self.resultsTableView
                        atIndexPath:indexPath
                       reverseOrder:reverse];
}

#pragma mark - Theme Management
- (void)applyTheme
{
    dispatch_queue_t themeQueue = dispatch_queue_create("Theme Queue", NULL);
    
    dispatch_async(themeQueue, ^{
        // Set (or reset) the theme with the appropriate theme object
        id <Theme> themeSetter = [[ThemeFactory sharedThemeFactory] buildThemeForSettingsKey];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Theme the appropriate views
            [themeSetter themeNavigationBar:self.navigationController.navigationBar];
            
            // Theme pong refresh control
            if ([themeSetter respondsToSelector:@selector(themeRefreshControl:)])
                [themeSetter themeRefreshControl:self.pongRefreshControl];
            
            // Theme the background view
            [themeSetter themeViewBackground:self.view];
            [themeSetter themeViewBackground:self.topMaskView];
            [themeSetter themeViewBackground:self.bottomMaskView];
            
            // Theme cells in UITableViewDelegate method tableView:cellForRowAtIndexPath:
            [themeSetter themeTableView:self.resultsTableView];
            
            // Theme the information label
            UIFont *labelFont = [UIFont fontWithName:@"Futura" size:[UIFont labelFontSize]];
            [themeSetter alternateThemeLabel:self.resultsInformationLabel withFont:labelFont];
            [self updateViewWithSelectedUserMode:self.selectedUserMode];
        });
    });
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
    
    [self updateCell:cell atIndex:indexPath];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIGestureRecognizerDelegate
- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        CGPoint rowPoint = [gestureRecognizer locationInView:self.resultsTableView];
        
        NSIndexPath *indexPath = [self.resultsTableView indexPathForRowAtPoint:rowPoint];
        
        // Grab date and reset to current date based on string
        NSDate *oldDate = (NSDate *)self.resultTimes[indexPath.row];
        NSDate *date = [oldDate currentDateVersion];
        
        if (indexPath)
        {
            [self buildActionSheetPresenterAndHandler:date andState:self.selectedUserMode];
        }
    }
}

- (void)buildActionSheetPresenterAndHandler:(NSDate *)date andState:(AFSelectedUserMode)selectedUserMode
{
    if (!self.actionSheetPresenter)
    {
        // Build the action sheet present and add it's window
        self.actionSheetPresenter = [[ActionSheetPresenter alloc] init];
    }
    
    self.actionSheetPresenter.presenterWindow = self.view.window;
    
    // Lazy initialize the actionSheetHandler and set as presenter delegate
    if (!self.actionSheetHandler)
        self.actionSheetHandler = [[ActionSheetHandler alloc] init];
    
    self.actionSheetPresenter.delegate = self.actionSheetHandler;
    
    // Send the selected time from date picker to sharedScheduler
    [[SchedulerAPI sharedScheduler] setSelectedTime:self.selectedTime];
    
    
    [self.actionSheetPresenter buildActionSheetForState:selectedUserMode
                                                andDate:date];
}

#pragma mark - Reminder/Alarm Notifications
- (void)alarmPosted:(NSNotification *)aNotification
{
    NSLog(@"Observer at: %s", __PRETTY_FUNCTION__);
    BOOL success = (BOOL)aNotification.userInfo[AFAlarmReminderNotificationSuccessKey];
    NSDate *date = (NSDate *)aNotification.userInfo[AFScheduledTimeKey];

    NSString *title;
    NSString *message;
    
    if (success)
    {
        title = NSLocalizedString(@"Success!", nil);
        message = [NSString stringWithFormat:NSLocalizedString(@"Alarm at %@ created.", nil),
                   [date shortTimeLowerCase]];
    } else
    {
        title = NSLocalizedString(@"Uh Oh!", nil);
        message = NSLocalizedString(@"Something went wrong with creating the alarm.\n"
                                    @"If this issue persists, please contact the developer (me)", nil);
    }
    
    [self alertViewWithTitle:title message:message];
}

- (void)reminderPosted:(NSNotification *)aNotification
{
    BOOL success = (BOOL)aNotification.userInfo[AFAlarmReminderNotificationSuccessKey];
    
    NSDate *date = (NSDate *)aNotification.userInfo[AFScheduledTimeKey];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *title;
        NSString *message;
        
        if (success)
        {
            title = NSLocalizedString(@"Success!", nil);
            message = [NSString stringWithFormat:NSLocalizedString(@"Reminder for %@ added", nil),
                       [date shortTimeLowerCase]];
        } else
        {
            title = NSLocalizedString(@"Uh Oh!", nil);
            message = NSLocalizedString(@"Something went wrong with creating the reminder.\n"
                                        @"If this issue persists, please contact the developer (me)", nil);
        }
        
        [self alertViewWithTitle:title message:message];
    });
}

- (void)alertViewWithTitle:(NSString *)title message:(NSString *)message
{
    FSAlertView *alertView = [[FSAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"Dismiss", nil)
                                              otherButtonTitles:nil];
    [alertView showWithDismissHandler:nil];
}


#pragma mark - Target Action Methods
- (void)refreshTriggered
{
    double delayInSeconds = 10.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        // Finish loading the data, reset the refresh control
        [self.pongRefreshControl finishedLoading];
    });
}

- (IBAction)addSelectedTimeAlarm:(id)sender
{
    // Take advantage of special enum mode
    [self buildActionSheetPresenterAndHandler:self.selectedTime
                                     andState:AFSelectedUserModeCalculateBedTimeWithAlarmTime];
}

#pragma mark - End of Life
- (void)dealloc
{
    // Remove observer so notification is not sent to null object
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


@end
