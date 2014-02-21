//
//  AboutViewController.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 2/5/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import "AboutViewController.h"
#import "WebViewController.h"

typedef NS_ENUM(NSInteger, AFLinkType)
{
    /**
     This enumeration represents the twitter link index in the linkURLS array.
     */
    AFLinkTypeTwitter
};

@interface AboutViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *aboutTextView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *linkTitles;

@property (nonatomic, strong) NSArray *linkURLS;

@property (nonatomic, strong) WebViewController *webViewController;

@end

@implementation AboutViewController
{}

#pragma mark - View Management
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self buildAboutText];
    [self buildLinkTitles];
    [self buildLinkURLS];
    
    // Verify buildLinkTitles and buildLinkURLS produce arrays with the same size
    assert(self.linkTitles.count == self.linkURLS.count);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Get rid of empty cells.
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - Builder Methods
- (void)buildAboutText
{
    NSString *text = @"SleepCycle was inspired by the website sleepyti.me, feel free to check it out.\n\n"
                     @"This project is also open source and if you would like to contribute or use anything from "
                     @"within this application in yours, feel free to.\n\n"
                     @"If you have any questions or critiques about my design choices, feel free to get in touch with "
                     @"me as I still have a lot to learn.";
    
    self.aboutTextView.text = NSLocalizedString(text, nil);
    self.aboutTextView.textAlignment = NSTextAlignmentCenter;
    self.aboutTextView.font = [UIFont fontWithName:@"Futura" size:14.0f];
    self.aboutTextView.textContainerInset = UIEdgeInsetsMake(10.0f, 4.0f, 10.0f, 4.0f);
    self.aboutTextView.editable = NO;
}

- (void)buildLinkTitles
{
    self.linkTitles = @[@"Follow @alexjfigueroa", @"SleepCycle Github Repo", @"sleepyti.me"];
}

- (void)buildLinkURLS
{
    self.linkURLS = @[[NSURL URLWithString:@"twitter://user?id=alexjfigueroa"],
                      [NSURL URLWithString:@"https://github.com/ajfigueroa/sleepcycle"],
                      [NSURL URLWithString:@"http://sleepyti.me/"]];
}

#pragma mark - UITableViewCell Customization Methods
- (void)updateCell:(UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath
{
    cell.textLabel.text = (NSString *)self.linkTitles[indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"Futura" size:14.0f];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

#pragma mark - UITableViewDataSource Method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.linkTitles)
        [self buildLinkTitles];
    
    return self.linkTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AboutCell" forIndexPath:indexPath];
    
    [self updateCell:cell atIndex:indexPath];
    
    return cell;
}

#pragma mark - UITableViewDelegate Method
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Deselect the row right away
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == AFLinkTypeTwitter)
        [self loadTwitterLink:(NSURL *)self.linkURLS[AFLinkTypeTwitter]];
    else
        [self loadLink:(NSURL *)self.linkURLS[indexPath.row]];
}

#pragma mark - NSURL Handling
- (void)loadTwitterLink:(NSURL *)twitterLink
{
    
}

- (void)loadLink:(NSURL *)link
{
    
}

@end
