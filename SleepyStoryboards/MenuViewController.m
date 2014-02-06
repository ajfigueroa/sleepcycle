//
//  MenuViewController.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/7/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import "MenuViewController.h"
#import "ThemeFactory.h"
#import "TimeSelectionViewController.h"
#import "AlarmsViewController.h"
#import "SettingsAPI.h"
#import "SettingsViewController.h"
#import "SliderMenuApplicationDelegate.h"

/**
 @brief The AFSettingsTableHeader constants refer to the cell row indexes in the static table view of
 the main application's Slider Menu (Refer to the main storyboard)
 */
typedef NS_ENUM(NSInteger, AFSettingsTableHeader)
{
    AFSettingsTableHeaderSettings,
    AFSettingsTableHeaderCalculate = 2,
    AFSettingsTableHeaderManage = 5
};

@interface MenuViewController ()

// Last index touched that is not the Settings index
@property (nonatomic, assign) NSInteger lastIndex;
// Keep track of the current UINavigationController on the stack
@property (nonatomic, strong) UINavigationController *currentNavigationController;

/**
 @brief An internal reference to the application delegate that conforms to the SliderMenuApplicationDelegate
 and thus can handle all interactions of the ApplicationDelegate's slider menu controller.
 */
@property (nonatomic, strong) id <SliderMenuApplicationDelegate> sliderApplication;

@end

// Constants
static NSInteger const settingsTableRowCount = 7;

@implementation MenuViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // Initial index is the Bed Time row
    self.lastIndex = AFSettingsTableOptionBedTime;
    
    // Get rid of blank trailing UITableViewCells
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // Theme the UI
    [self applyTheme];
    
    // Register for theme change notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyTheme) name:AFThemeHasChangedNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Initialize the application delegate reference
    self.sliderApplication = (id <SliderMenuApplicationDelegate>)[UIApplication sharedApplication].delegate;
}

#pragma mark - Override Accessor Methods
- (UINavigationController *)mainNavigationController
{
    if (!_mainNavigationController)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        _mainNavigationController = [storyboard instantiateViewControllerWithIdentifier:@"MainNav"];
    }
    
    // Update the currentNavigationController
    self.currentNavigationController = _mainNavigationController;
    
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
    
    // Update the currentNavigationController
    self.currentNavigationController = _alarmsNavigationViewController;
    
    return _alarmsNavigationViewController;
}

#pragma mark - View Management
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (![self.tableView indexPathForSelectedRow]) {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.lastIndex inSection:0]
                                    animated:YES
                              scrollPosition:UITableViewScrollPositionNone];
    }

}

#pragma mark - UITableViewDelegate Method
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case AFSettingsTableOptionSettings:
            [self toggleSlider];
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
    id <Theme> themeSetter = [[ThemeFactory sharedThemeFactory] buildThemeForSettingsKey];

    [themeSetter themeViewBackground:self.tableView];
    
    [self themeTableViewCellsWithThemeSetter:themeSetter];
}

- (void)themeTableViewCellsWithThemeSetter:(id <Theme>)themeSetter
{
    for (int i = 0; i < settingsTableRowCount; i++)
    {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        
        switch (i) {
            case AFSettingsTableHeaderSettings:
                [themeSetter alternateThemeViewBackground:cell];
                break;
                
            case AFSettingsTableHeaderCalculate:
                [themeSetter alternateThemeViewBackground:cell];
                break;
                
            case AFSettingsTableHeaderManage:
                [themeSetter alternateThemeViewBackground:cell];
                break;
                
            case AFSettingsTableOptionSettings:
                [themeSetter themeOptionCell:cell
                               withImageView:self.settingsImageView
                              forThemeOption:AFSettingsTableOptionSettings];
                [themeSetter themeTextField:self.settingsTextField];
                break;
                
            case AFSettingsTableOptionBedTime:
                [themeSetter themeOptionCell:cell withImageView:self.bedTimeImageView
                              forThemeOption:AFSettingsTableOptionBedTime];
                [themeSetter themeTextField:self.bedTimeTextField];
                break;
                
            case AFSettingsTableOptionWakeTime:
                [themeSetter themeOptionCell:cell withImageView:self.wakeUpTimeImageView
                              forThemeOption:AFSettingsTableOptionWakeTime];
                [themeSetter themeTextField:self.wakeTimeTextField];
                break;
                
            case AFSettingsTableOptionAlarm:
                [themeSetter themeOptionCell:cell withImageView:self.alarmImageView
                              forThemeOption:AFSettingsTableOptionAlarm];
                [themeSetter themeTextField:self.alarmsTextField];
                break;
                
            default:
                [themeSetter themeViewBackground:cell];
                break;
        }
    }
}

#pragma mark - JSSlidingViewController Helpers
- (void)toggleSlider {
    [self.sliderApplication toggleSlider];
}

#pragma mark - Presenters
- (void)presentSettingsViewController
{
    // Take currentNavigationController and verify it conforms to the SettingsViewControllerDelegate
    // protocol so it can dismiss SettingsViewController
    UIViewController *viewController = (UIViewController *)self.currentNavigationController.viewControllers.firstObject;
    
    if ([viewController conformsToProtocol:@protocol(SettingsViewControllerDelegate)])
    {
        // Assign the SettingsViewController delegate to the current viewController
        SettingsViewController *settingsViewController = (SettingsViewController *)self.settingsNavigationViewController.viewControllers.firstObject;
        settingsViewController.delegate = (id <SettingsViewControllerDelegate>)viewController;
        
        // Present modally the settingsNavigationViewController with a delay of about 0.2s
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

    if (![[self.sliderApplication frontViewController] isEqual:self.mainNavigationController])
        [self.sliderApplication setFrontViewController:self.mainNavigationController];
}

- (void)presentAlarmViewController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    self.alarmsNavigationViewController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"AlarmsNav"];

    if (![[self.sliderApplication frontViewController] isEqual:self.alarmsNavigationViewController])
        [self.sliderApplication setFrontViewController:self.alarmsNavigationViewController];
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
