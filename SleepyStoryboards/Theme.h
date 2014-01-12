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

// Theming general UI Controls and Views
- (void)themeViewBackground:(UIView *)view;

- (void)alternateThemeViewBackground:(UIView *)view;

- (void)themeNavigationBar:(UINavigationBar *)navBar;

- (void)themeButton:(UIButton *)button withFont:(UIFont *)font;

- (void)alternateThemeButton:(UIButton *)button withFont:(UIFont *)font;

- (void)themeLabel:(UILabel *)label withFont:(UIFont *)font;

- (void)alternateThemeLabel:(UILabel *)label withFont:(UIFont *)font;

- (void)themeRefreshControl:(UIView *)refreshControl;

- (void)themeTableView:(UITableView *)tableView;

- (void)themeTableViewCell:(UITableViewCell *)cell
               inTableView:(UITableView *)tableView
               atIndexPath:(NSIndexPath *)indexPath
              reverseOrder:(BOOL)reverseOrder;

- (void)themeSwitch:(UISwitch *)switchControl;

- (void)themeSlider:(UISlider *)slider;

- (void)themeOptionCell:(UITableViewCell *)cell withImageView:(UIImageView *)imageView forThemeOption:(NSInteger)themeOption;

- (void)themeTextField:(UITextField *)textField;

- (void)themeBorderForView:(UIView *)view;

@end
