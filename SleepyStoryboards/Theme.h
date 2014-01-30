//
//  Theme.h
//  SleepCycleSeven
//
//  Created by Alexander Figueroa on 12/23/2013.
//  Copyright (c) 2013 Alexander Figueroa. All rights reserved.
//
//  Define the protocol which every theme must adhere to

#import <Foundation/Foundation.h>
@class AlarmCell;
@class IBActionSheet;
@class BOZPongRefreshControl;

@protocol Theme <NSObject>

@required

/**
 @brief Themes the backgroundColor property of a view in the primary manner.
 @param view The UIView to theme.
 */
- (void)themeViewBackground:(UIView *)view;

/**
 @brief Theme the backgroundColor property of a view in the secondary manner.
 @param view The UIView to theme.
 */
- (void)alternateThemeViewBackground:(UIView *)view;

/**
 @brief Theme the UINavigation bar to a light or dark style.
 @param navBar The UINavigationBar to theme.
 @code [themeObject themeNavigationBar:navigationController.navigationBar]; @endcode
 @sa UIStatusBarStyleLightContent, UIStatusBarStyleDefault
 */
- (void)themeNavigationBar:(UINavigationBar *)navBar;

/**
 @brief Theme the button's backgroundColor and textColor for both UIControlStateNormal
 and UIControlStateHighlighted in the primary manner.
 @param button The UIButton to theme.
 @param font The UIFont to apply to the button's titleLabel property.
 @sa -[UIButton setTitleColor:forState]
 */
- (void)themeButton:(UIButton *)button withFont:(UIFont *)font;

/**
 @brief Theme the button's backgroundColor and textColor for both UIControlStateNormal
 and UIControlStateHighlighted in the secondary manner.
 @param button The UIButton to theme.
 @param font The UIFont to apply to the button's titleLabel property.
 @sa -[UIButton setTitleColor:forState]
 */
- (void)alternateThemeButton:(UIButton *)button withFont:(UIFont *)font;

/**
 @brief Theme the label's backgroundColor, textColor, and font in the primary manner
 @param label The UILabel to theme.
 @param font The UIFont to use for the label's font property.
 */
- (void)themeLabel:(UILabel *)label withFont:(UIFont *)font;

/**
 @brief Theme the label's backgroundColor, textColor, and font in the secondary manner
 @param label The UILabel to theme.
 @param font The UIFont to use for the label's font property.
 */
- (void)alternateThemeLabel:(UILabel *)label withFont:(UIFont *)font;

/**
 @brief Theme the refreshControl's backgroundColor
 @param refreshControl The UIRefreshControl to theme.
 */
- (void)themePongRefreshControl:(BOZPongRefreshControl *)pongRefreshControl;

/**
 @brief Theme the tableView's backgroundColor and separatorColor.
 @param tableView The UITableView to theme
 */
- (void)themeTableView:(UITableView *)tableView;

/**
 @brief Map colors to each of the tableView's cells, in reference to a defined color map of the same size of the number of rows in a given section
 @param cell The UITableViewCell whose backgroundColor, textColor, and font to theme.
 @param tableView The UITableView instance of which the cell belongs to
 @param indexPath The NSIndexPath that corresponds to the cell's location in the tableView
 @param reverseOrder The BOOL that controls if an ascending or descending order is to be applied to the color mapping array
 */
- (void)themeTableViewCell:(UITableViewCell *)cell
               inTableView:(UITableView *)tableView
               atIndexPath:(NSIndexPath *)indexPath
              reverseOrder:(BOOL)reverseOrder;

/**
 @brief Theme the imageView property of a cell depending on the themeOption mode.
 @param cell The UITableViewCell whose imageView to theme.
 @param imageView The UIImageView on whose image property to set to desired image.
 @param themeOption A constant that specifies the current theme of the application. See SleepyTimeConstants.h for more information on valid constants.
 */
- (void)themeOptionCell:(UITableViewCell *)cell
          withImageView:(UIImageView *)imageView
         forThemeOption:(AFSettingsTableOption)themeOption;

/**
 @brief Theme the cell's backgroundColor.
 This method can simply call -themeViewBackground: passing in cell as the parameter
 @param cell The UITableViewCell to theme.
 */
- (void)themeCell:(UITableViewCell *)cell;

// Theme AlarmCells
- (void)themeAlarmCell:(AlarmCell *)cell;

// Theme the UISwitch
- (void)themeSwitch:(UISwitch *)switchControl;

// Theme the UISlider
- (void)themeSlider:(UISlider *)slider;

// Theme the UITextField
- (void)themeTextField:(UITextField *)textField;

// Theme the border used for a given view
- (void)themeBorderForView:(UIView *)view visible:(BOOL)isVisible;

// Theme Action Sheet of type IBAction
- (void)themeIBActionSheet:(IBActionSheet *)actionSheet;

@end
