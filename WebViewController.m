//
//  WebViewController.m
//  Hack
//
//  Created by Alexander Figueroa on 2013-10-13.
//  Copyright (c) 2013 Alexander Figueroa. All rights reserved.
//

#import "WebViewController.h"
#import "UIColor+FlatUI.h"
#import "ThemeFactory.h"

@interface WebViewController ()

@property (nonatomic, strong) NSURLRequest *linkRequest;

@end

@implementation WebViewController

- (instancetype)initWithRequestURL:(NSURL *)requestURL
{
    self = [super init];
    
    if (self) {
        
        // Store the request (link)
        self.linkRequest = [NSURLRequest requestWithURL:requestURL];
    }
    
    return self;
}

#pragma mark - View Management
- (void)loadView
{
    // Define our custom view
    // Grab the screen properties
    CGRect screenFrame = [[UIScreen mainScreen] bounds];
    
    // Create the WebView
    self.webView = [[UIWebView alloc] initWithFrame:screenFrame];
    
    UIView *mainView = [[UIView alloc] initWithFrame:screenFrame];
    
    // Don't explode the users retina.
    [self.webView setOpaque:NO];
    self.webView.backgroundColor = [UIColor blackColor];
    
    // Configure the webview
    self.webView.delegate = self;
    
    // Scale the page to fit
    self.webView.scalesPageToFit = YES;
    
    // Load the user request
    [self.webView loadRequest:self.linkRequest];
    
    // Add the webview as subview to the mainView
    [mainView addSubview:self.webView];
    
    // Define the view for this view controller
    self.view = mainView;
}

- (void)viewWillAppear:(BOOL)animated
{
    // Show the toolbar
    [[self navigationController] setToolbarHidden:NO animated:YES];
    
    // Create the bar button items
    [self buildBrowserButtons];
    
    // Create a fixed space to be used between buttons and before
    UIBarButtonItem *interButtonSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    interButtonSpace.width = 20.0;
    
    UIBarButtonItem *horizontalPaddingSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    horizontalPaddingSpace.width = 8.0;
    
    // Add these to the toolbar that is now visible
    [self setToolbarItems:@[horizontalPaddingSpace,
                            self.backButton,
                            interButtonSpace,
                            self.forwardButton]];
    
    // Theme the tool bar
    id <Theme> themeSetter = [[ThemeFactory sharedThemeFactory] buildThemeForSettingsKey];
    [themeSetter themeToolbar:self.navigationController.toolbar];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // Hide the toolbar
    [[self navigationController] setToolbarHidden:YES animated:NO];
}

#pragma mark - Helper Functions
- (void)buildBrowserButtons
{
    // Create the forward and back buttons for the web browser
    self.backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"leftbarbuttonitem"]
                                                       style:UIBarButtonItemStylePlain
                                                      target:self
                                                      action:@selector(goBack)];
    
    self.forwardButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"rightbarbuttonitem"]
                                                          style:UIBarButtonItemStylePlain
                                                         target:self
                                                         action:@selector(goForward)];
}

- (void)updateButtons
{
    self.backButton.enabled = self.webView.canGoBack;
    self.forwardButton.enabled = self.webView.canGoForward;
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    // Turn on activation bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // Change the background so any views that blend with their views appear as normal
    self.webView.backgroundColor = [UIColor whiteColor];
    
    // Update the toolbar buttons
    [self updateButtons];
    
    // Turn on activation bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Error: %@", error.localizedDescription);
    if ([error code] == NSURLErrorCancelled) {
        NSLog(@"Ignore this error, just NSURLErrorCancelled");
    }
    else {
        UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [errorAlertView show];
    }
    
}

#pragma mark - Target/Action
- (void)goBack
{
    // Go back in the Web View Page
    [self.webView goBack];
    [self updateButtons];
}

- (void)goForward
{
    // Go forward in the Web View page
    [self.webView goForward];
    [self updateButtons];
}

@end
