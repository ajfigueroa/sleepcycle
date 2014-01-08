//
//  LightTheme.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 12/31/2013.
//  Copyright (c) 2013 Alexander Figueroa. All rights reserved.
//
//  The class is a semi-abstract method that should only be subclassed
//  Hence, the implementations for the <Theme> protocol are unimplemented and
//  must be done so by the child class.
//  The methods that are unimplemented are those that do not deal with theming of the
//  the nav and status bar

#import "LightTheme.h"
#import "UINavigationBar+FlatUI.h"
#import "BOZPongRefreshControl.h"
#import "NSArray+Ordering.h"

@interface LightTheme ()

@property (nonatomic, strong) NSArray *tableViewCellColorMapping;
@property (nonatomic) NSUInteger lastSection;

@end

@implementation LightTheme
{}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        // Register for clearing notifications of the color map
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearColorMapping) name:AFColorMappingResetNotification object:nil];
    }
    
    return self;
}

#pragma mark - Theme Protocol
- (void)themeNavigationBar:(UINavigationBar *)navBar
{

    // Theme the navigation bar to conform to the Light content
    navBar.tintColor = [UIColor whiteColor];
    navBar.titleTextAttributes = @{NSFontAttributeName: [UIFont fontWithName:@"Futura" size:21.0f],
                                   NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    // Theme status bar for light content
    [self themeStatusBar];
    
    // Set the navigation bar color
    [navBar configureFlatNavigationBarWithColor:self.primaryColor];
}

- (void)themeViewBackground:(UIView *)view
{
    // Configure the background color
    view.backgroundColor = self.secondaryColor;
}

- (void)themeButton:(UIButton *)button withFont:(UIFont *)font
{
    button.backgroundColor = self.primaryColor;
    button.titleLabel.font = font;
    [button setTitleColor:self.textColor forState:UIControlStateNormal];
    [button setTitleColor:self.textColor forState:UIControlStateHighlighted];
}

- (void)themeLabel:(UILabel *)label withFont:(UIFont *)font
{
    label.font = font;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = self.textColor;
    label.backgroundColor = [UIColor clearColor];
}

- (void)alternateThemeLabel:(UILabel *)label withFont:(UIFont *)font
{
    [self themeLabel:label withFont:font];
    label.textColor = self.primaryColor;
}

- (void)alternateThemeViewBackground:(UIView *)view
{
    // Configure view with alternate background cover
    view.backgroundColor = self.primaryColor;
}

- (void)alternateThemeButton:(UIButton *)button withFont:(UIFont *)font
{
    button.backgroundColor = self.primaryColor;
    button.titleLabel.font = font;
    [button setTitleColor:self.alternateTextColor forState:UIControlStateNormal];
    [button setTitleColor:self.alternateTextColor forState:UIControlStateHighlighted];
}

- (void)themeRefreshControl:(UIView *)refreshControl
{
    BOZPongRefreshControl *pongRefreshControl = (BOZPongRefreshControl *)refreshControl;
    pongRefreshControl.foregroundColor = self.secondaryColor;
    pongRefreshControl.backgroundColor = self.primaryColor;
}

- (void)themeTableView:(UITableView *)tableView
{
    tableView.backgroundColor = self.primaryColor;
    tableView.separatorColor = self.secondaryColor;
}

- (void)themeTableViewCell:(UITableViewCell *)cell inTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath reverseOrder:(BOOL)reverseOrder
{
    //  Reinitialize color mapping array if the section is different or if it has never been created
    if (!self.tableViewCellColorMapping || self.lastSection != indexPath.section)
    {
        self.lastSection = (NSUInteger)indexPath.section;
        self.tableViewCellColorMapping = [self themeTableViewCellMappingInTableView:tableView atSection:self.lastSection];
        
        // Reverse the array if needed
        if (reverseOrder)
        {
            NSArray *copyArray = [NSArray arrayWithArray:self.tableViewCellColorMapping];
            self.tableViewCellColorMapping = [copyArray reverseArray];
        }
        
    }
    
    cell.backgroundColor = (UIColor *)self.tableViewCellColorMapping[(NSUInteger)indexPath.row];
    cell.textLabel.textColor = self.textColor;
    cell.textLabel.font = [UIFont fontWithName:@"Futura" size:[UIFont labelFontSize]];
}

- (NSArray *)themeTableViewCellMappingInTableView:(UITableView *)tableView atSection:(NSUInteger)section
{
    // Returns an array where each index corresponds to a different color on a row in a table section
    NSUInteger rowCount = [tableView numberOfRowsInSection:section];
    NSMutableArray *colorMapping = [NSMutableArray arrayWithCapacity:rowCount];
    
    CGFloat h = 0, b = 0, s = 0, a = 0;
    [self.primaryColor getHue:&h saturation:&s brightness:&b alpha:&a];

    // Split the array into two sections
    // One half is darker, middle is normal, other half is lighter
    NSUInteger middle = (rowCount / 2);
    CGFloat brightnessIncrement = 0.18f;
    
    for (int i = 0; i < middle - 1; i++){
        colorMapping[i] = [UIColor colorWithHue:h
                                     saturation:s
                                     brightness:(b - brightnessIncrement)
                                          alpha:a];
    }
    
    colorMapping[middle - 1] = self.primaryColor;
    colorMapping[middle] = self.primaryColor;

    
    for (NSInteger i = middle + 1; i < rowCount; i++)
    {
        colorMapping[i] = [UIColor colorWithHue:h
                                     saturation:s
                                     brightness:(b + brightnessIncrement)
                                          alpha:a];
    }

    return (NSArray *)colorMapping;
}

# pragma mark - Helper
- (void)themeStatusBar
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma mark - Public Methods
- (void)clearColorMapping
{
    self.tableViewCellColorMapping = nil;
}

#pragma mark - End of Life
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
