//
//  ImageViewManagerFactory.h
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/22/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageViewManager.h"

@interface ImageViewManagerFactory : NSObject

+ (instancetype)sharedImageViewManagerFactory;
- (id <ImageViewManager>)buildImageViewManagerForThemeKey:(AFThemeSelectionOption)themeKey;

@end
