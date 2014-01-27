//
//  Theme.h
//  SleepCycleSeven
//
//  Created by Alexander Figueroa on 12/23/2013.
//  Copyright (c) 2013 Alexander Figueroa. All rights reserved.
//
//  Define the protocol which every theme must adhere to

#import <Foundation/Foundation.h>

@protocol Theme <NSObject>

@required

// Themes the background color of the view in primary fashion
- (void)themeViewBackground:(UIView *)view;

// Themes the background view in the alternate fashion
- (void)alternateThemeViewBackground:(UIView *)view;

// Theme the UINavigationBar
- (void)themeNavigationBar:(UINavigationBar *)navBar;

// Theme the UIButton's in primary or alternate fashion
- (void)themeButton:(UIButton *)button withFont:(UIFont *)font;
- (void)alternateThemeButton:(UIButton *)button withFont:(UIFont *)font;

// Theme the UILabel's in primary or alternate fashion
- (void)themeLabel:(UILabel *)label withFont:(UIFont *)font;
- (void)alternateThemeLabel:(UILabel *)label withFont:(UIFont *)font;

// Theme the refresh control
- (void)themeRefreshControl:(UIView *)refreshControl;

// Theme the UITableView and its corresponding UITableViewCells in
// ascending/descending brightness pattern
- (void)themeTableView:(UITableView *)tableView;
- (void)themeTableViewCell:(UITableViewCell *)cell
               inTableView:(UITableView *)tableView
               atIndexPath:(NSIndexPath *)indexPath
              reverseOrder:(BOOL)reverseOrder;

// Theme the image view that will be used in case of theming issues
- (void)themeOptionCell:(UITableViewCell *)cell
          withImageView:(UIImageView *)imageView
         forThemeOption:(NSInteger)themeOption;

// Theme general UITableViewCell
- (void)themeCell:(UITableViewCell *)cell;

// Theme the UISwitch
- (void)themeSwitch:(UISwitch *)switchControl;

// Theme the UISlider
- (void)themeSlider:(UISlider *)slider;

// Theme the UITextField
- (void)themeTextField:(UITextField *)textField;

// Theme the border used for a given view
- (void)themeBorderForView:(UIView *)view visible:(BOOL)isVisible;

@end
