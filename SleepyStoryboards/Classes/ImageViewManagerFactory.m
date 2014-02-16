//
//  ImageViewManagerFactory.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/22/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import "ImageViewManagerFactory.h"
#import "BlackOverlayImageViewManager.h"
#import "WhiteOverlayImageViewManager.h"

@implementation ImageViewManagerFactory

+ (instancetype)sharedImageViewManagerFactory
{
    static ImageViewManagerFactory *sharedImageViewManagerFactory = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedImageViewManagerFactory = [[ImageViewManagerFactory alloc] init];
    });
    
    return sharedImageViewManagerFactory;
}

- (id <ImageViewManager>)buildImageViewManagerForThemeKey:(AFThemeSelectionOption)themeKey
{
    switch (themeKey) {
        case AFThemeSelectionOptionBlueBeigeTheme:
            return [[BlackOverlayImageViewManager alloc] init];
            break;
            
        case AFThemeSelectionOptionBlackGrayTheme:
            return [[WhiteOverlayImageViewManager alloc] init];
            break;
            
        case AFThemeSelectionOptionRedRoseTheme:
            return [[BlackOverlayImageViewManager alloc] init];
            break;
            
        default:
            return nil;
            break;
    }
}

@end
