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

@interface MenuViewController ()

@end

static NSInteger const AFSettingsTableViewCellRow = 1;

@implementation MenuViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // Get rid of unwanted UITableViewCells
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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

#pragma mark - UITableViewDelegate Method
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case AFSettingsTableViewCellRow:
            [self presentSettingsViewController];
            break;
            
        default:
            break;
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
        double delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [viewController presentViewController:self.settingsNavigationViewController
                                         animated:YES
                                       completion:nil];
        });
    }
}

#pragma mark - SettingsViewControllerDelegate
- (void)settingsViewControllerDidFinish:(SettingsViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
