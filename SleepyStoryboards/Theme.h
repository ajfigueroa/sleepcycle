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
- (void)themeNavigationBar:(UINavigationBar *)navBar;
- (void)themeButton:(UIButton *)button withFont:(UIFont *)font;
- (void)themeLabel:(UILabel *)label withFont:(UIFont *)font;
- (void)alternateThemeViewBackground:(UIView *)view;
- (void)alternateThemeButton:(UIButton *)button withFont:(UIFont *)font;
- (void)themeRefreshControl:(UIView *)refreshControl;
- (void)themeTableView:(UITableView *)tableView;
- (void)themeTableViewCell:(UITableViewCell *)cell inTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath reverseOrder:(BOOL)reverseOrder;

@end
