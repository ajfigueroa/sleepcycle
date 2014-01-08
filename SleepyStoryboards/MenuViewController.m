//
//  MenuViewController.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/7/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (UINavigationController *)mainNavigationController
{
    if (!_mainNavigationController)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        _mainNavigationController = [storyboard instantiateViewControllerWithIdentifier:@"MainNav"];
    }
    
    return _mainNavigationController;
}

@end
