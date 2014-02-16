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
    // Reverses the order of the elements within the array
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
    NSEnumerator *enumerator = [self reverseObjectEnumerator];
    
    for (id element in enumerator)
    {
        [array addObject:element];
    }
    
    return (NSArray *)array;
}

@end
