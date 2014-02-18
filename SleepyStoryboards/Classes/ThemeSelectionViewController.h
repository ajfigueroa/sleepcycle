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

/**
 @brief The delegate that conforms to the ThemeSelectionViewControllerDelegate protocol
 and receives updates on the theme selection.
 */
@property (nonatomic, weak) id <ThemeSelectionViewControllerDelegate> delegate;

/**
 @brief The currently selected theme in human readable form.
 */
@property (nonatomic, strong) NSString *themeName;

/**
 @brief The list of human readable theme selections.
 */
@property (nonatomic, strong) NSArray *themes;

@end

/**
 @brief The ThemeSelectionViewControllerDelegate protocol defines methods that an object
 must conform to, in order to receive updates on Theme selection from this view controller.
 */
@protocol ThemeSelectionViewControllerDelegate <NSObject>

@required
/**
 @brief Notifies the delegate a theme off the Theme Selections has been selected.
 @param controller The ThemeSelectionViewController notifying the receiver.
 @param themeName The human readable string that represents the users current theme choice.
 */
- (void)themeSelectionViewController:(ThemeSelectionViewController *)controller
                      didSelectTheme:(NSString *)themeName;

@end