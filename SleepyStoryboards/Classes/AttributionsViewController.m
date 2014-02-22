//
//  AttributionsViewController.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 2/6/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import "AttributionsViewController.h"
#import "WebViewController.h"
#import "AFUserDefaultKeyConstants.h"

#pragma mark - AttributionsViewController
@interface AttributionsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *attributionTableView;

@property (nonatomic, strong) WebViewController *webViewController;

@property (nonatomic, strong) NSArray *sectionHeaderTitles;

@property (nonatomic, strong) NSDictionary *attributionData;

@end

@implementation AttributionsViewController
{}

#pragma mark - View Management
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self buildAttributionData];
}

#pragma mark - Builder Functions
- (void)buildSectionHeaderTitles
{
    // These are the keys for the attributionData dictionary
    self.sectionHeaderTitles = @[@"Libraries",
                                 @"Icons",
                                 @"Sounds",
                                 @"Icon and Sounds Licenses"];
}

- (void)buildAttributionData
{
    if (!self.sectionHeaderTitles)
        [self buildSectionHeaderTitles];
    
    // Grab attribution date from user defaults.
    self.attributionData = (NSDictionary *)[[NSUserDefaults standardUserDefaults] dictionaryForKey:AFAttributionsDictionary];
}

#pragma mark - UITableViewCell Customization Methods
- (void)updateCell:(UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath
{
    NSString *sectionKey = (NSString *)self.sectionHeaderTitles[indexPath.section];
    
    // Grabs an array of title and url pairs (as strings).
    // Look into Defaults.plist for further clarification
    NSArray *attributionInfoList = (NSArray *)self.attributionData[sectionKey];

    // Grab title and url pair
    NSArray *attributionInfo = attributionInfoList[indexPath.row];

    // Customize the cell
    cell.textLabel.text = (NSString *)attributionInfo.firstObject;
    cell.textLabel.font = [UIFont fontWithName:@"Futura" size:[UIFont systemFontSize]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return count of array in dictionary for key at index section in sectionHeaderTitles
    NSString *sectionKey = (NSString *)self.sectionHeaderTitles[section];
    
    // Grabs an array of title and url pairs as strings.
    // Look into Defaults.plist for further clarification
    NSArray *attributionInfoList = (NSArray *)self.attributionData[sectionKey];
    
    return attributionInfoList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AttributionCell"];
    
    [self updateCell:cell atIndex:indexPath];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return count of keys in attributionData dictionary
    return self.attributionData.allKeys.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return (NSString *)self.sectionHeaderTitles[section];
}

#pragma mark - UITableViewDelegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Deselect row right away.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Grab list of link url pairs (as strings).
    NSString *sectionKey = (NSString *)self.sectionHeaderTitles[indexPath.section];
    NSArray *attributionInfoList = (NSArray *)self.attributionData[sectionKey];
    
    // Grab title and url pair.
    NSArray *attributionInfo = attributionInfoList[indexPath.row];
    
    // Create url from url string.
    NSURL *url = [NSURL URLWithString:(NSString *)attributionInfo.lastObject];
    
    // Load into the webview controller
    self.webViewController = [[WebViewController alloc] initWithRequestURL:url];
    
    // Push onto the stack
    [self.navigationController pushViewController:self.webViewController animated:YES];
}

@end
