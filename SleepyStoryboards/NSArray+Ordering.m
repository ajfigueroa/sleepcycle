//
//  NSArray+Ordering.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/6/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import "NSArray+Ordering.h"

@implementation NSArray (Ordering)

- (NSArray *)reverseArray
{
    // Flips the array
    NSArray *reversed = [[NSArray alloc] initWithArray:self];
    return [[reversed reverseObjectEnumerator] allObjects];
}

@end
