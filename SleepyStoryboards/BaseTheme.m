//
//  BaseTheme.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/22/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import "BaseTheme.h"
#import "UINavigationBar+FlatUI.h"
#import "FUIButton.h"
#import "BOZPongRefreshControl.h"
#import "NSArray+Ordering.h"
#import "ImageViewManagerFactory.h"
#import "AlarmCell.h"
#import "IBActionSheet.h"

@interface BaseTheme ()

/**
 @brief The color map to apply to a UITableView's cells. It contains the three brightness variants.
 */
@property (nonatomic, strong) NSArray *tableViewCellColorMapping;

/**
 @brief The last section that a color map was applied to. Different sections may want different color maps.
 */
@property (nonatomic, assign) NSUInteger previousTableViewSection;

@end

@implementation BaseTheme 

- (instancetype)initWithBackgroundColor:(UIColor *)backgroundColor
               secondaryBackgroundColor:(UIColor *)secondaryBackgroundColor
      alternateSecondaryBackgroundColor:(UIColor *)altSecondaryBackgroundColor
                              textColor:(UIColor *)textColor
                     secondaryTextColor:(UIColor *)secondaryTextColor
{
    self = [super init];
    
    if (self)
    {
        // Set the appropriate colors to be used within theming
        self.primaryBackgroundColor = backgroundColor;
        self.secondaryBackgroundColor = secondaryBackgroundColor;
        self.alternateSecondaryBackgroundColor = altSecondaryBackgroundColor;
        self.primaryTextColor = textColor;
        self.secondaryTextColor = secondaryTextColor;
        
        // Register for clearing of color mapping
        [self addNotificationObserverForColorMapClearing];
    }

    return self;
}

#pragma mark - Build Helper Functions
/**
 @brief A method to add an observer for the AFColorMappingResetNotification so that the
 clearColorMapping method can be called and reset the tableViewCellColorMapping property.
 */
- (void)addNotificationObserverForColorMapClearing
{
    // Register for clearing notifications of the color map
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clearColorMapping)
                                                 name:AFColorMappingResetNotification
                                               object:nil];
}

#pragma mark - Theme Protocol
- (void)themeViewBackground:(UIView *)view
{
    // Configure the background color with primary background color
    view.backgroundColor = self.secondaryBackgroundColor;
}

- (void)alternateThemeViewBackground:(UIView *)view
{
    // Configure view with alternate background cover
    view.backgroundColor = self.primaryBackgroundColor;
}

- (void)themeNavigationBar:(UINavigationBar *)navBar
{
    // Theme the navigation color to have whiteColor text.
    navBar.tintColor = [UIColor whiteColor];
    navBar.titleTextAttributes = @{NSFontAttributeName: [UIFont fontWithName:@"Futura" size:21.0f],
                                   NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    // Adjust the status bar for whiteColor text
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // Configure the navigation bars background color
    [navBar configureFlatNavigationBarWithColor:self.primaryBackgroundColor];
}

- (void)themeButton:(UIButton *)button withFont:(UIFont *)font
{
    button.backgroundColor = self.primaryBackgroundColor;
    
    button.titleLabel.font = font;
    [button setTitleColor:self.primaryTextColor forState:UIControlStateNormal];
    [button setTitleColor:self.primaryTextColor forState:UIControlStateHighlighted];
}

- (void)alternateThemeButton:(UIButton *)button withFont:(UIFont *)font
{
    FUIButton *flatButton = (FUIButton *)button;
    
    flatButton.buttonColor = [UIColor clearColor];
    flatButton.shadowColor = [UIColor clearColor];
    flatButton.shadowHeight = 0.0f;
    flatButton.cornerRadius = 3.0f;
    
    flatButton.titleLabel.font = font;
    [flatButton setTitleColor:self.primaryTextColor forState:UIControlStateNormal];
    [flatButton setTitleColor:self.primaryTextColor forState:UIControlStateHighlighted];
}

- (void)themeLabel:(UILabel *)label withFont:(UIFont *)font
{
    label.font = font;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = self.primaryTextColor;
    label.backgroundColor = [UIColor clearColor];
}

- (void)alternateThemeLabel:(UILabel *)label withFont:(UIFont *)font
{
    [self themeLabel:label withFont:font];
    label.textColor = self.primaryBackgroundColor;
}

- (void)themePongRefreshControl:(BOZPongRefreshControl *)pongRefreshControl
{
    pongRefreshControl.foregroundColor = self.secondaryBackgroundColor;
    pongRefreshControl.backgroundColor = self.primaryBackgroundColor;
}

- (void)themeTableView:(UITableView *)tableView
{
    tableView.backgroundColor = self.primaryBackgroundColor;
    tableView.separatorColor = self.secondaryBackgroundColor;
}

- (void)themeTableViewCell:(UITableViewCell *)cell
               inTableView:(UITableView *)tableView
               atIndexPath:(NSIndexPath *)indexPath
              reverseOrder:(BOOL)reverseOrder
{

    // Build color map array
    [self buildColorMapForTableView:tableView inSection:indexPath.section reversed:reverseOrder];
    
    // Theme the UITableViewCell
    cell.backgroundColor = (UIColor *)self.tableViewCellColorMapping[(NSUInteger)indexPath.row];
    cell.textLabel.textColor = self.primaryTextColor;
    cell.textLabel.font = [UIFont fontWithName:@"Futura" size:[UIFont labelFontSize]];
}

/**
@brief A specific method to help with -[BaseTheme themeTableViewCell:inTableView:atIndexPath:reverseOrder:]
 that builds a color mapped array on the BaseTheme's tableViewCellColorMapping array property.
@param tableView A UITableView on which to build the tableViewCellColorMapping for.
@param section An NSInteger that represents the current section in the tableView.
@param reverse A BOOL control that indicates the order of the tableViewCellColorMapping array property.
@sa -[BaseTheme themeTableViewCell:inTableView:atIndexPath:reverseOrder:]
 */
- (void)buildColorMapForTableView:(UITableView *)tableView inSection:(NSInteger)section reversed:(BOOL)reverse
{
    //  Reinitialize color mapping array on null or new section (UITableView section)
    if (!(self.tableViewCellColorMapping ||
          self.previousTableViewSection != section))
    {
        self.previousTableViewSection = (NSUInteger)section;
        self.tableViewCellColorMapping = [self themeTableViewCellMappingInTableView:tableView
                                                                          atSection:self.previousTableViewSection];
        
        // Reverse the array if needed
        if (reverse)
        {
            NSArray *copyArray = [NSArray arrayWithArray:self.tableViewCellColorMapping];
            self.tableViewCellColorMapping = [copyArray reverseArray];
        }
    }
}

/**
 @brief Generates an array of three colors based on the primaryBackgroundColor property.
 The three sections of colors are darker, normal, and brighter. It is @b recommended
  that the -[UITableView numberOfRowsInSection] method returns a count divisible by 3.
 @param tableView The UITableView that the color map will base itself off.
 @param section The section index of the tableView on which the color map will be applied
 to
 @returns An NSArray of three sections, each a variation of the primaryBackgroundColor.
 @sa -[BaseTheme buildColorMappingArrayInReverseOrder:atIndexPath:inTableView:]
 @sa -[BaseTheme themeTableViewCell:inTableView:atIndexPath:reverseOrder:]
 */
- (NSArray *)themeTableViewCellMappingInTableView:(UITableView *)tableView
                                        atSection:(NSUInteger)section
{
    // Assumes that the section size is fixed and can be divided into sections (3)
    // Returns an array where each index corresponds to a different color on a row in a table section
    NSUInteger rowCount = [tableView numberOfRowsInSection:section];
    
    // Check that the row count is able to be divided into three sections
    assert(rowCount % 3 == 0 && rowCount > 0);
    
    NSMutableArray *colorMapping = [NSMutableArray arrayWithCapacity:rowCount];
    
    CGFloat h = 0, b = 0, s = 0, a = 0;
    [self.primaryBackgroundColor getHue:&h saturation:&s brightness:&b alpha:&a];
    
    // Color Map Array is split into three sections:
    // First section has a darker brightness
    // Second section has normal brightness
    // Third section has a higher brightness
    NSInteger sectionSize = rowCount / 3;
    CGFloat brightnessIncrement = 0.18f;
    
    // Darker section
    for (NSInteger i = 0; i < sectionSize; i++){
        colorMapping[i] = [UIColor colorWithHue:h
                                     saturation:s
                                     brightness:(b - brightnessIncrement)
                                          alpha:a];
    }
    
    // Normal brightness section
    for (NSInteger i = sectionSize; i < 2 * sectionSize; i++)
    {
        colorMapping[i] = self.primaryBackgroundColor;
    }
    
    // Lighter section
    for (NSInteger i = 2 * sectionSize; i < 3 * sectionSize; i++)
    {
        colorMapping[i] = [UIColor colorWithHue:h
                                     saturation:s
                                     brightness:(b + brightnessIncrement)
                                          alpha:a];
    }
    
    return (NSArray *)colorMapping;
}

- (void)themeOptionCell:(UITableViewCell *)cell
          withImageView:(UIImageView *)imageView
         forThemeOption:(AFSettingsTableOption)themeOption
{
    cell.backgroundColor = self.secondaryBackgroundColor;
    cell.textLabel.textColor = self.secondaryTextColor;
    
    // Build the factory
    ImageViewManagerFactory *factory = [ImageViewManagerFactory sharedImageViewManagerFactory];
    id <ImageViewManager> imageViewManager = [factory buildImageViewManagerForThemeKey:self.themeEnum];
    
    switch (themeOption) {
        case AFSettingsTableOptionSettings:
            imageView.image = [imageViewManager settingsImage];
            break;
        case AFSettingsTableOptionBedTime:
            imageView.image = [imageViewManager bedTimeImage];;
            break;
        case AFSettingsTableOptionWakeTime:
            imageView.image = [imageViewManager wakeTimeImage];
            break;
        case AFSettingsTableOptionAlarm:
            imageView.image = [imageViewManager alarmImage];
        default:
            imageView = nil;
            break;
    }
}

- (void)themeCell:(UITableViewCell *)cell
{
    [self themeViewBackground:cell];
}

- (void)themeAlarmCell:(AlarmCell *)cell
{
    [self themeViewBackground:cell];
    cell.alarmTimeLabel.textColor = self.secondaryTextColor;
    cell.alarmDateLabel.textColor = self.secondaryTextColor;
}

- (void)themeSwitch:(UISwitch *)switchControl
{
    switchControl.onTintColor = self.primaryBackgroundColor;
}

- (void)themeSlider:(UISlider *)slider
{
    slider.tintColor = self.primaryBackgroundColor;
}

- (void)themeTextField:(UITextField *)textField
{
    textField.textColor = self.secondaryTextColor;
}

- (void)themeBorderForView:(UIView *)view visible:(BOOL)isVisible
{
    CGColorRef borderColor;
    
    if (isVisible)
        borderColor = [[UIColor blackColor] CGColor];
    else
        borderColor = [[UIColor clearColor] CGColor];
    
    view.layer.borderColor = borderColor;
    view.layer.borderWidth = 1.5f;
}

- (void)themeIBActionSheet:(IBActionSheet *)actionSheet
{
    // Theme all subviews
    [actionSheet setTitleTextColor:self.primaryTextColor];
    [actionSheet setTitleBackgroundColor:self.secondaryBackgroundColor];
    [actionSheet setButtonBackgroundColor:self.secondaryBackgroundColor];
    [actionSheet setButtonTextColor:self.primaryBackgroundColor];
    
}

#pragma mark - Target Action Method
/**
 @brief Clear the tableViewCellColorMapping array by setting it to nil.
 */
- (void)clearColorMapping
{
    self.tableViewCellColorMapping = nil;
}

#pragma mark - End of Life
- (void)dealloc
{
    // Removing notification to avoid sending messages to null
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
