//
//  WebViewController.m
//  Hack
//
//  Created by Alexander Figueroa on 2013-10-13.
//  Copyright (c) 2013 Alexander Figueroa. All rights reserved.
//

#import "WebViewController.h"
#import "UIColor+FlatUI.h"
#import "TUSafariActivity.h"

@interface WebViewController ()

@property (nonatomic, strong) NSURLRequest *linkRequest;
@property (nonatomic, strong) UIToolbar *toolbar;

@end

@implementation WebViewController

- (id)initWithRequestURL:(NSURL *)requestURL andTitle:(NSString *)title;
{
    self = [super init];
    
    if (self) {
        // Set the title (may conatenate)
        self.title = title;
        
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
    self.webView.backgroundColor = [UIColor lightSalmonColor];
    
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
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    
    // Add these to the toolbar that is now visible
    [self setToolbarItems:@[horizontalPaddingSpace,
                            self.backButton,
                            interButtonSpace,
                            self.forwardButton,
                            flexibleSpace,
                            self.shareButton]];
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
    self.backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(goBack)];
    
    self.forwardButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(goForward)];
    
    // Lastly, build the share button (SET TO NIL for now)
    self.shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareLink)];
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
    NSLog(@"webViewDidStart...");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad");
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

- (void)shareLink
{
    // Create the open in safari activity view
    TUSafariActivity *safariActivity = [[TUSafariActivity alloc] init];
    
    // Configure the share activity view controller
    UIActivityViewController *shareActivityViewController = [[UIActivityViewController alloc]
                                        initWithActivityItems:@[self.linkRequest.URL]
                                        applicationActivities:@[safariActivity]];
    shareActivityViewController.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll];
    
    shareActivityViewController.completionHandler = ^(NSString *activityType, BOOL completed){
        NSLog(@"Activity: %@", activityType);
        NSLog(@"Completed Status: %d", completed);
        
        if (completed && activityType == UIActivityTypeCopyToPasteboard) {
            NSString *title = @"Huzzah";
            NSString *message = @"Copied to clipboard!";
            
            UIAlertView *shareStatusAlertView = [[UIAlertView alloc] initWithTitle:title
                                                                           message:message
                                                                          delegate:nil
                                                                 cancelButtonTitle:@"Dismiss"
                                                                 otherButtonTitles:nil];
            [shareStatusAlertView show];
            shareStatusAlertView = nil;
        }
        
        else if (completed && (activityType == UIActivityTypePostToFacebook || activityType == UIActivityTypePostToTwitter)) {
            NSString *title = @"Huzzah";
            NSString *message = @"Succesfully posted!";
            
            UIAlertView *shareStatusAlertView = [[UIAlertView alloc] initWithTitle:title
                                                                           message:message
                                                                          delegate:nil
                                                                 cancelButtonTitle:@"Dismiss"
                                                                 otherButtonTitles:nil];
            [shareStatusAlertView show];
            shareStatusAlertView = nil;
        }
        else if (completed && (activityType == UIActivityTypeMessage || activityType == UIActivityTypeMail)) {
            NSString *title = @"Huzzah";
            NSString *message = @"Succesfully sent!";
            
            UIAlertView *shareStatusAlertView = [[UIAlertView alloc] initWithTitle:title
                                                                           message:message
                                                                          delegate:nil
                                                                 cancelButtonTitle:@"Dismiss"
                                                                 otherButtonTitles:nil];
            [shareStatusAlertView show];
            shareStatusAlertView = nil;
        }
    };
    
    // Present the activity indicator
    [self presentViewController:shareActivityViewController
                       animated:YES
                     completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
