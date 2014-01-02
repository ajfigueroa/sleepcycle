//
//  ThemeSelectionViewController.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/2/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import "ThemeSelectionViewController.h"

@interface ThemeSelectionViewController ()

@property (nonatomic, strong) NSArray *themes;
@property (nonatomic) NSUInteger selectedThemeIndex;

@end

@implementation ThemeSelectionViewController
{}

#pragma mark - View Management
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.themes = @[@"Blue & Beige",
                    @"Black & Gray",
                    @"Red & White"];
    
    self.selectedThemeIndex = [self.themes indexOfObject:self.themeName];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.themes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ThemeCell"];
    cell.textLabel.text = (NSString *)self.themes[indexPath.row];
    
    if (indexPath.row == self.selectedThemeIndex)
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Update the selected theme by adding the checkmark
    self.selectedThemeIndex = indexPath.row;
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    // Send the now selected theme to the delegate
    NSString *selectedThemeName = (NSString *)self.themes[indexPath.row];
    [self.delegate themeSelectionViewController:self didSelectTheme:selectedThemeName];
}

@end
