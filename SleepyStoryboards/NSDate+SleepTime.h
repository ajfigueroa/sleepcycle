//
//  NSDate+SleepTime.h
//  SleepyTimeUpdate
//
//  Created by Alexander Figueroa on 11/25/2013.
//  Copyright (c) 2013 Alexander Figueroa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (SleepTime)

// Returns bool indicating if the time exists today and tomorrow
// or just tomorrow
+ (BOOL)spansMultipleDaysForTime:(NSDate *)candidateTime;

- (NSString *)stringUsingFormatter:(NSDateFormatter *)formatter;
- (NSString *)shortTime;
- (NSString *)shortTimeLowerCase;
- (NSString *)shortDate;
- (NSInteger)hourComponent;
- (NSArray *)allDateComponents;
- (NSDate *)zeroDateSeconds;
- (NSDate *)currentDateVersion;
- (NSComparisonResult)compareHours:(NSDate *)anotherDate;
- (NSComparisonResult)compareMinutes:(NSDate *)anotherDate;
- (NSComparisonResult)compareTimes:(NSDate *)anotherDate;

@end
