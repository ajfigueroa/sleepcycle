//
//  MainViewController.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 12/30/2013.
//  Copyright (c) 2013 Alexander Figueroa. All rights reserved.
//

#import "MainViewController.h"
#import "ThemeProvider.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        // Grab the theme from the theme factory if it isn't provided already
        if (!self.themeSetter)
        {
            self.themeSetter = [ThemeProvider theme];
        }
        
        // Configure the segmented control
        [self.themeSegmentedControl addTarget:self action:@selector(changeTheme:) forControlEvents:UIControlEventValueChanged];
        
    }
    
    return self;
}

- (void)setTheme
{
    // Set (or reset) the theme with the appropriate theme object
    self.themeSetter = [ThemeProvider theme];
    // Theme the appropriate views using the appropriate theme object
    // conforming to <Theme>
    [self.themeSetter themeNavigationBar:self.navigationController.navigationBar];
    [self.themeSetter themeViewBackground:self.view];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *currentTheme = [[NSUserDefaults standardUserDefaults] valueForKey:kAppTheme];
    
    if ([currentTheme isEqualToString:kBlueBeigeTheme])
    {
        self.themeSegmentedControl.selectedSegmentIndex = 0;
    }
    else if ([currentTheme isEqualToString:kBlackGrayTheme])
    {
        self.themeSegmentedControl.selectedSegmentIndex = 1;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setTheme];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)changeTheme:(UISegmentedControl *)segmentedControl
{
    NSLog(@"Theme is being changed");
    NSLog(@"Sender is of type: %@", [[segmentedControl class] description]);
    
    switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            [[NSUserDefaults standardUserDefaults] setObject:kBlueBeigeTheme forKey:kAppTheme];
            NSLog(@"Theme is going bluebeige");
            break;
        case 1:
            [[NSUserDefaults standardUserDefaults] setObject:kBlackGrayTheme forKey:kAppTheme];
            NSLog(@"Theme is going blackgray");
            break;
        default:
            break;
    }
    
    // Syncronize the views and update
    NSLog(@"Syncronizing and updating");
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self setTheme];
    });
}
@end
