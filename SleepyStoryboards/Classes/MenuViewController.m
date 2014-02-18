//
//  MenuViewController.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/7/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import "MenuViewController.h"
#import "SettingsAPI.h"
#import "ThemeFactory.h"
#import "AlarmsViewController.h"
#import "SettingsViewController.h"
#import "TimeSelectionViewController.h"
#import "SliderMenuApplicationDelegate.h"
#import "AFNotificationConstants.h"

/**
 @brief The AFSettingsTableHeader constants refer to the cell row indexes in the static table view of
 the main application's Slider Menu (Refer to the main storyboard)
 */
typedef NS_ENUM(NSInteger, AFSettingsTableHeader)
{
    /**
     @brief The header with the label "Settings"
     */
    AFSettingsTableHeaderSettings,
    /**
     @brief The header with the label "Calculate"
     */
    AFSettingsTableHeaderCalculate = 2,
    /**
     @brief The header with the label "Manage"
     */
    AFSettingsTableHeaderManage = 5
};

@interface MenuViewController ()

/**
 @brief The last index touched in the side Menu View Controller. This is meant
 to keep track of the last touched index when the user enters the Settings view.
*/
@property (nonatomic, assign) NSInteger lastIndex;

/**
 @brief The current navigation controller that is set as frontViewController stack.
*/
@property (nonatomic, strong) UINavigationController *currentNavigationController;

/**
 @brief An internal reference to the application delegate that conforms to the SliderMenuApplicationDelegate
 and thus can handle all interactions of the ApplicationDelegate's slider menu controller.
 */
@property (nonatomic, strong) id <SliderMenuApplicationDelegate> sliderApplication;

/**
 @brief The navigation controller that holds the SettingsViewController as its root navigation
 controller.
 */
@property (nonatomic, strong) UINavigationController *settingsNavigationViewController;

/**
 @brief The navigation controller that holds the AlarmsViewController as its root navigation
 controller
 */
@property (nonatomic, strong) UINavigationController *alarmsNavigationViewController;

// The Settings table static cell text fields
@property (weak, nonatomic) IBOutlet UITextField *settingsTextField;

@property (weak, nonatomic) IBOutlet UITextField *bedTimeTextField;

@property (weak, nonatomic) IBOutlet UITextField *wakeTimeTextField;

@property (weak, nonatomic) IBOutlet UITextField *alarmsTextField;

// The Settings table static cell image views
@property (weak, nonatomic) IBOutlet UIImageView *settingsImageView;

@property (weak, nonatomic) IBOutlet UIImageView *bedTimeImageView;

@property (weak, nonatomic) IBOutlet UIImageView *wakeUpTimeImageView;

@property (weak, nonatomic) IBOutlet UIImageView *alarmImageView;

@end

/** 
 @brief The constant value represents the number of options in the menu table including headers.
*/
 static NSInteger const AFSliderMenuSelectionOptions = 7;

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
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(applyTheme) 
                                                 name:AFThemeHasChangedNotification 
                                               object:nil];
}

#pragma mark - Navigation View Controller Setup Methods
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
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Initialize the application delegate reference
    self.sliderApplication = (id <SliderMenuApplicationDelegate>)[UIApplication sharedApplication].delegate;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (![self.tableView indexPathForSelectedRow])
    {
        // Since the options in the slider menu consists of purely cells (headers are pseudo-headers).
        // The section is unified and thus the lastIndex updates in section 0.
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.lastIndex inSection:0]
                                    animated:YES
                              scrollPosition:UITableViewScrollPositionNone];
    }

}

#pragma mark - UITableViewDelegate Method
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Switch based on the indexPath row that corresponds to a selectable row:
    // AFSettingsTableOption constants
    switch (indexPath.row) {
        case AFSettingsTableOptionSettings:
            // Toggle slider first and present the view controller (modally)
            [self toggleSlider];
            [self presentSettingsViewController];
            break;
            
        case AFSettingsTableOptionBedTime:
            // Update the front view controller then toggle slider
            [self presentTimeSelectionControllerWithSelectedUserMode:AFSelectedUserModeCalculateBedTime];
            self.lastIndex = AFSettingsTableOptionBedTime;
            [self toggleSlider];
            break;
            
        case AFSettingsTableOptionWakeTime:
            // Update the front view controller then toggle slider
            [self presentTimeSelectionControllerWithSelectedUserMode:AFSelectedUserModeCalculateWakeTime];
            self.lastIndex = AFSettingsTableOptionWakeTime;
            [self toggleSlider];
            break;
            
        case AFSettingsTableOptionAlarm:
            // Update the front view controller then toggle slider
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

    // Theme the table view background
    [themeSetter themeViewBackground:self.tableView];
    
    // Theme the static table view cells represent the slider menu options
    [self themeTableViewCellsWithThemeSetter:themeSetter];
}

/**
 @brief Themes each of the Slider Menu Setting Cells including the Headers.
 @param themeSetter The object that conforms to the Theme protocol and is responsible for theming the cells.
 */
- (void)themeTableViewCellsWithThemeSetter:(id <Theme>)themeSetter
{
    for (int i = 0; i < AFSliderMenuSelectionOptions; i++)
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

#pragma mark - Presenting Navigation View Controllers
/**
 @brief Creates and presents (modally) the Settings Navigation View Controller. The view stack that this
 Settings Navigation View Controller pushes itself on must conform to the SettingsViewControllerDelegate
 protocol as it will need to handle dismissal of the Settings Navigation View Controller
 */
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

/**
 @brief Creates and sets the main navigation controller (whose root view controller is the Time Selection
 View Controller) as the Slider Application's frontViewController.
 @param option The AFSelectedUserMode constant that configures the TimeSelectionViewController.
 */
- (void)presentTimeSelectionControllerWithSelectedUserMode:(AFSelectedUserMode)option
{
    // Update the mode of the TimeSelectionViewController
    TimeSelectionViewController *timeSelectionViewController = (TimeSelectionViewController *)self.mainNavigationController.viewControllers.firstObject;
    timeSelectionViewController.selectedUserMode = option;

    if (![[self.sliderApplication frontViewController] isEqual:self.mainNavigationController])
        [self.sliderApplication setFrontViewController:self.mainNavigationController];
}

/**
 @brief Creates and sets the alarms navigation controller (whose root view is the AlarmsViewController)
 as the Slider Application's frontViewController.
 */
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
