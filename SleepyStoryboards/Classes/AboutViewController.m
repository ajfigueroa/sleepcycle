//
//  AboutViewController.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 2/5/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *aboutTextView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *linkTitles;

@end

@implementation AboutViewController
{}

#pragma mark - View Management
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self buildAboutText];
    [self buildLinkTitles];
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
    self.linkTitles = @[@"Follow Developer", @"SleepCycle Github Repository", @"sleepyti.me"];
}

#pragma mark - UITableViewCell customization methods
- (void)updateCell:(UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath
{
    cell.textLabel.text = (NSString *)self.linkTitles[indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"Futura" size:12.0f];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor blueColor];
}

#pragma mark - UITableViewDataSource
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

@end
