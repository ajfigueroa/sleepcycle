//
//  AttributionsViewController.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 2/6/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import "AttributionsViewController.h"
#import "WebViewController.h"

/*
 Object to hold our attribution titles and links
 */
@interface AttributionInfo : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSURL *url;

- (instancetype)initWithTitle:(NSString *)title url:(NSURL *)url;

@end

@implementation AttributionInfo

- (instancetype)initWithTitle:(NSString *)title url:(NSURL *)url
{
    self = [super init];
    
    if (self)
    {
        self.title = title;
        self.url = url;
    }

    return self;
}

@end


@interface AttributionsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *attributionTableView;

@property (nonatomic, strong) WebViewController *webViewController;

@property (nonatomic, strong) NSArray *sectionHeaderTitles;

@property (nonatomic, strong) NSDictionary *attributionData;

@end

@implementation AttributionsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self buildAttributionData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Gets rid of trailing empty cells.
    self.attributionTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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
    NSMutableDictionary *attributionDataMutable = [NSMutableDictionary dictionary];
    
    // Generate corresponding title and link data
    NSArray *libraryRowTitles = @[@"FlatUIKit",
                                  @"IBActionSheet",
                                  @"SVProgressHUD",
                                  @"JSSlidingViewController",
                                  @"BOZPongRefreshControl",
                                  @"Colors-for-iOS"];
    
    NSArray *libraryRowURLS = @[[NSURL URLWithString:@"https://github.com/grouper/flatuikit"],
                                [NSURL URLWithString:@"https://github.com/ianb821/IBActionSheet"],
                                [NSURL URLWithString:@"https://github.com/samvermette/SVProgressHUD"],
                                [NSURL URLWithString:@"https://github.com/jaredsinclair/JSSlidingViewController"],
                                [NSURL URLWithString:@"https://github.com/boztalay/BOZPongRefreshControl"],
                                [NSURL URLWithString:@"https://github.com/bennyguitar/Colours"]];
    
    NSArray *iconRowTitles = @[@"Iconic",
                               @"Ionicons"];
    
    NSArray *iconRowURLS = @[[NSURL URLWithString:@"http://somerandomdude.com/work/iconic/"],
                             [NSURL URLWithString:@"http://ionicons.com/"]];
    
    NSArray *soundRowTitles = @[@"Joe DeShon"];
    
    NSArray *soundRowURLS = @[[NSURL URLWithString:@"http://www.freesound.org/people/joedeshon/"]];
    
    NSArray *licensesRowTitles = @[@"Creative Commons License",
                                   @"MIT License"];
    
    NSArray *licenseRowURLS = @[[NSURL URLWithString:@"http://creativecommons.org/licenses/by/3.0/"],
                                [NSURL URLWithString:@"http://opensource.org/licenses/MIT"]];
    
    // Create the lists for each of the above Titles and URL pairs
    NSArray *allRowTitles = @[libraryRowTitles, iconRowTitles, soundRowTitles, licensesRowTitles];
    NSArray *allRowURLS = @[libraryRowURLS, iconRowURLS, soundRowURLS, licenseRowURLS];
    
    // Verify counts are equal.
    assert(allRowTitles.count == allRowURLS.count);
    
    // Create the dictionary data source
    __weak AttributionsViewController *weakSelf = self;
    [weakSelf.sectionHeaderTitles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *headerTitle = (NSString *)obj;
        attributionDataMutable[headerTitle] = [weakSelf attributionInfoFromTitles:allRowTitles[idx]
                                                                          andURLS:allRowURLS[idx]];
    }];
    
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
    
    NSMutableArray *attributionInfoArray = [NSMutableArray arrayWithCapacity:titles.count];
    
    [titles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *title = (NSString *)obj;
        NSURL *url = (NSURL *)urls[idx];
        
        attributionInfoArray[idx] = [[AttributionInfo alloc] initWithTitle:title url:url];
    }];
    
    return (NSArray *)attributionInfoArray;
}

#pragma mark - UITableViewCell customization methods
- (void)updateCell:(UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath
{
    NSString *sectionKey = (NSString *)self.sectionHeaderTitles[indexPath.section];
    NSArray *attributionInfoList = (NSArray *)self.attributionData[sectionKey];
    AttributionInfo *info = (AttributionInfo *)attributionInfoList[indexPath.row];
    cell.textLabel.text = info.title;
    cell.textLabel.font = [UIFont fontWithName:@"Futura" size:[UIFont systemFontSize]];
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
    
    NSString *sectionKey = (NSString *)self.sectionHeaderTitles[indexPath.section];
    NSArray *attributionInfoList = (NSArray *)self.attributionData[sectionKey];
    AttributionInfo *info = (AttributionInfo *)attributionInfoList[indexPath.row];
    NSLog(@"Clicked Attribution Info:\nTitle:%@\nLink:%@", info.title, info.url);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0f;
}

@end
