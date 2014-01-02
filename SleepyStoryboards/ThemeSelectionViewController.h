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

@property (nonatomic, weak) id <ThemeSelectionViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString *themeName;

@end

@protocol ThemeSelectionViewControllerDelegate <NSObject>

- (void)themeSelectionViewController:(ThemeSelectionViewController *)controller didSelectTheme:(NSString *)themeName;

@end