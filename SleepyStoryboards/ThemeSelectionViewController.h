//
//  ThemeSelectionViewController.h
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/2/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ThemeSelectionViewControllerDelegate;

@interface ThemeSelectionViewController : UITableViewController

@end

@protocol ThemeSelectionViewControllerDelegate <NSObject>

- (void)themeSelectionViewController:(ThemeSelectionViewController *)controller didSelectTheme:(AFThemeSelectionOption)themeSelection;

@end