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

/**
 @brief Returns the shared factory for creating Image View Manager objects.
 @returns The shared image view manager factory.
 */
+ (instancetype)sharedImageViewManagerFactory;

/**
 @brief Asks the sharedImageViewManagerFactory to build an ImageViewManager object based on the themeKey constant value which corresponds to a Theme conforming object.
 @param themeKey The AFThemeSelectionOption constant that corresponds to a given theme.
 @sa ThemeFactory.h
 @returns An object that conforms to the ImageViewManager protocol that is responsible for providing images based on the Theme. (Dark themes are better suited to light overlay images, whereas light themes would be better suited to dark overlay images).  Returns @b nil, if the themeKey is not valid.
 */
- (id <ImageViewManager>)buildImageViewManagerForThemeKey:(AFThemeSelectionOption)themeKey;

@end
