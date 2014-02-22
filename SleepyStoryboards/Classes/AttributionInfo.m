//
//  AttributionInfo.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 2/21/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import "AttributionInfo.h"

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
