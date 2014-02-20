//
//  NSArray+Ordering.h
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/6/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Ordering)

/**
 @brief Reverse the order of the receiver's copy.
 @returns A copy of the receiver that is in the reverse order.
 */
- (NSArray *)reversedArray;

@end
