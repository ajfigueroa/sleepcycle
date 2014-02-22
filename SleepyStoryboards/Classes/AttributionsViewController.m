//
//  AttributionsViewController.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 2/6/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import "AttributionsViewController.h"
#import "WebViewController.h"
#import "AttributionInfo.h"

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
    self.sectionHeaderTitles = @[@"Libraries",
                                 @"Icons",
                                 @"Sounds",
                                 @"Icon and Sounds Licenses"];
}

- (void)buildAttributionData
{
    if (!self.sectionHeaderTitles)
        [self buildSectionHeaderTitles];
    
    // Create an array of AttributionInfo objects with the header titles as dictionary
    // keys for attributionData dictionary.
    self.attributionData = (NSDictionary *)attributionDataMutable;
}

/**
 @brief From two lists of titles and urls return a list of AttributionInfo objects.
 @param titles A list of NSString titles.
 @param urls A list of links that correspond to each of the NSStrings in titles.
 @returns An immutable array of AttributionInfo objects. Returns nil if arrays aren't the same size or if either are 
 nil.
 @sa AttributionInfo defined in AttributionsViewController
 */
- (NSArray *)attributionInfoFromTitles:(NSArray *)titles andURLS:(NSArray *)urls
{
    // Compare size of arrays and check for nil
    if (!titles || !urls || (titles.count != urls.count))
        return nil;
    
    NSMutableArray *attributionInfoList = [NSMutableArray arrayWithCapacity:titles.count];
    
    [titles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *title = (NSString *)obj;
        NSURL *url = (NSURL *)urls[idx];
        
        attributionInfoList[idx] = [[AttributionInfo alloc] initWithTitle:title url:url];
    }];
    
    return (NSArray *)attributionInfoList;
}

#pragma mark - UITableViewCell Customization Methods
- (void)updateCell:(UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath
{
    NSString *sectionKey = (NSString *)self.sectionHeaderTitles[indexPath.section];
    NSArray *attributionInfoList = (NSArray *)self.attributionData[sectionKey];
    
    // Grab AttributionInfo object from list
    AttributionInfo *info = (AttributionInfo *)attributionInfoList[indexPath.row];
    
    // Customize the cell
    cell.textLabel.text = info.title;
    cell.textLabel.font = [UIFont fontWithName:@"Futura" size:[UIFont systemFontSize]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return count of array in dictionary for key at index section in sectionHeaderTitles
    NSArray *rowData = (NSArray *)[self.attributionData objectForKey:(NSString *)self.sectionHeaderTitles[section]];
    return rowData.count;
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
    
    // Grab list of AttributionInfo objects
    NSString *sectionKey = (NSString *)self.sectionHeaderTitles[indexPath.section];
    NSArray *attributionInfoList = (NSArray *)self.attributionData[sectionKey];
    
    // Grab attribution info object from the list.
    AttributionInfo *info = (AttributionInfo *)attributionInfoList[indexPath.row];
    
    // Load into the webview controller
    self.webViewController = [[WebViewController alloc] initWithRequestURL:info.url];
    
    // Push onto the stack
    [self.navigationController pushViewController:self.webViewController animated:YES];
}

@end
