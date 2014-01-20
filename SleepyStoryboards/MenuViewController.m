//
//  MenuViewController.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/7/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import "MenuViewController.h"
#import "SettingsViewController.h"
#import "JSSlidingViewController.h"
#import "ThemeProvider.h"
#import "SettingsSelectionConstants.h"
#import "TimeSelectionViewController.h"
#import "AlarmsViewController.h"

@interface MenuViewController ()

@property (nonatomic, strong) id <Theme> themeSetter;
// Keep track of which index was touched last
@property (nonatomic, assign) NSInteger lastIndex;
// Keep track of the current UINavigationController on the stack
@property (nonatomic, strong) UINavigationController *currentNavigationController;

@end

typedef NS_ENUM(NSInteger, AFSettingsTableHeader)
{
    AFSettingsTableHeaderSettings,
    AFSettingsTableHeaderCalculate = 2,
    AFSettingsTableHeaderManage = 5
};

#define SETTINGS_TABLE_ROWS 7

@implementation MenuViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // Initial index is the Bed time row
    self.lastIndex = AFSettingsTableOptionBedTime;
    
    // Get rid of unwanted UITableViewCells
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // Theme the UI
    [self applyTheme];
    
    // Register for Theme Change Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyTheme) name:AFThemeHasChangedNotification object:nil];
}

- (UINavigationController *)mainNavigationController
{
    if (!_mainNavigationController)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        _mainNavigationController = [storyboard instantiateViewControllerWithIdentifier:@"MainNav"];

    }
    
    return _mainNavigationController;
}

- (UINavigationController *)settingsNavigationViewController
{
    if (!_settingsNavigationViewController)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        UINavigationController *navController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"SettingsNav"];
        _settingsNavigationViewController = navController;
    }
    
    return _settingsNavigationViewController;
}

- (UINavigationController *)alarmsNavigationViewController
{
    if (!_alarmsNavigationViewController)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        _alarmsNavigationViewController = [storyboard instantiateViewControllerWithIdentifier:@"AlarmsNav"];
    }
    
    return _alarmsNavigationViewController;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (![self.tableView indexPathForSelectedRow]) {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.lastIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    }

}

#pragma mark - UITableViewDelegate Method
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case AFSettingsTableOptionSettings:
            [self presentSettingsViewController];
            break;
        case AFSettingsTableOptionBedTime:
            [self presentTimeSelectionControllerWithSelectedUserMode:AFSelectedUserModeCalculateBedTime];
            self.lastIndex = AFSettingsTableOptionBedTime;
            [self toggleSlider];
            break;
        case AFSettingsTableOptionWakeTime:
            [self presentTimeSelectionControllerWithSelectedUserMode:AFSelectedUserModeCalculateWakeTime];
            self.lastIndex = AFSettingsTableOptionWakeTime;
            [self toggleSlider];
            break;
        case AFSettingsTableOptionAlarm:
            [self presentAlarmViewController];
            self.lastIndex = AFSettingsTableOptionAlarm;
            [self toggleSlider];
            break;
        default:
            break;
    }
}

#pragma mark - Theming
- (void)applyTheme
{
    self.themeSetter = [ThemeProvider theme];

    [self.themeSetter themeViewBackground:self.tableView];
    
    [self themeTableViewCells];
}

- (void)themeTableViewCells
{
    for (int i = 0; i < SETTINGS_TABLE_ROWS; i++)
    {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        
        switch (i) {
            case AFSettingsTableHeaderSettings:
                [self.themeSetter alternateThemeViewBackground:cell];
                break;
            case AFSettingsTableHeaderCalculate:
                [self.themeSetter alternateThemeViewBackground:cell];
                break;
            case AFSettingsTableHeaderManage:
                [self.themeSetter alternateThemeViewBackground:cell];
                break;
            case AFSettingsTableOptionSettings:
                [self.themeSetter themeOptionCell:cell withImageView:self.settingsImageView forThemeOption:AFSettingsTableOptionSettings];
                [self.themeSetter themeTextField:self.settingsTextField];
                break;
            case AFSettingsTableOptionBedTime:
                [self.themeSetter themeOptionCell:cell withImageView:self.bedTimeImageView forThemeOption:AFSettingsTableOptionBedTime];
                [self.themeSetter themeTextField:self.bedTimeTextField];
                break;
            case AFSettingsTableOptionWakeTime:
                [self.themeSetter themeOptionCell:cell withImageView:self.wakeUpTimeImageView forThemeOption:AFSettingsTableOptionWakeTime];
                [self.themeSetter themeTextField:self.wakeTimeTextField];
                break;
            case AFSettingsTableOptionAlarm:
                [self.themeSetter themeOptionCell:cell withImageView:self.alarmImageView forThemeOption:AFSettingsTableOptionAlarm];
                [self.themeSetter themeTextField:self.alarmsTextField];
                break;
            default:
                [self.themeSetter themeViewBackground:cell];
                break;
        }
    }
}

#pragma mark - JSSlidingViewController Helpers
- (void)toggleSlider {
    if ([[self.applicationDelegate slidingViewController] isOpen]) {
        [[self.applicationDelegate slidingViewController] closeSlider:YES completion:nil];
    } else {
        [[self.applicationDelegate slidingViewController] openSlider:YES completion:nil];
    }
}

- (void)presentSettingsViewController
{
    // Dismiss the slider
    [self toggleSlider];
    
    // Grab a reference to the main navigation controller and verify it conforms to the
    // SettingsViewControllerDelegate protocol so it can handle dismissing of the settings
    // view controller
    UIViewController *viewController = self.mainNavigationController.viewControllers.firstObject;
    if ([viewController conformsToProtocol:@protocol(SettingsViewControllerDelegate)])
    {
        // Grab a reference to the settings view controller and assign its delegate
        SettingsViewController *settingsViewController = (SettingsViewController *)self.settingsNavigationViewController.viewControllers.firstObject;
        settingsViewController.delegate = (id <SettingsViewControllerDelegate>)viewController;
        
        // Delay modal presentation until JSSlidingViewController is dismissed
        double delayInSeconds = 0.2;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [viewController presentViewController:self.settingsNavigationViewController
                                         animated:YES
                                       completion:nil];
        });
    }
}

- (void)presentTimeSelectionControllerWithSelectedUserMode:(AFSelectedUserMode)option
{
    // Update the mode of the TimeSelectionViewController
    TimeSelectionViewController *timeSelectionViewController = (TimeSelectionViewController *)self.mainNavigationController.viewControllers.firstObject;
    timeSelectionViewController.selectedUserMode = option;
    
    if (![[[self.applicationDelegate slidingViewController] frontViewController] isEqual:self.mainNavigationController])
    {
        [[self.applicationDelegate slidingViewController] setFrontViewController:self.mainNavigationController animated:YES completion:nil];
    }
}

- (void)presentAlarmViewController
{
    if (!self.alarmsNavigationViewController)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        self.alarmsNavigationViewController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"AlarmsNav"];
        AlarmsViewController *alarmsViewController = (AlarmsViewController *)self.alarmsNavigationViewController.viewControllers.firstObject;
        alarmsViewController.applicationDelegate = self.applicationDelegate;
        
    }
    
    if (![[[self.applicationDelegate slidingViewController] frontViewController] isEqual:self.alarmsNavigationViewController])
    {
        [[self.applicationDelegate slidingViewController] setFrontViewController:self.alarmsNavigationViewController animated:YES completion:nil];
    }
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
