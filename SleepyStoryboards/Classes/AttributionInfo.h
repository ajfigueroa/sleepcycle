//
//  AttributionInfo.h
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 2/21/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

/*
 This object is used as the data object type in the Attributions Controller for holding link and strings.
 */

#import <Foundation/Foundation.h>

@interface AttributionInfo : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSURL *url;

- (instancetype)initWithTitle:(NSString *)title url:(NSURL *)url;


@end
