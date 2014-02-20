//
//  NSDate+SleepTime.h
//  SleepyTimeUpdate
//
//  Created by Alexander Figueroa on 11/25/2013.
//  Copyright (c) 2013 Alexander Figueroa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (SleepTime)

/**
 @brief Indicates whether the candidateTime is a time that is possible today and tomorrow or if it is only available tomorrow. This is done by comparing it to the current time.
 @param candidateTime The NSDate object whose time will be checked to determine if the date is valid for today and tomorrow or tomorrow only.
 @returns YES if the date can be valid today and tomorrow. NO if the date is only possible tomorrow and not today.
 */
+ (BOOL)spansMultipleDaysForTime:(NSDate *)candidateTime;

/**
 @brief Formats the receiver object in the format specified by the formatter object.
 @param formatter The NSDateFormatter that dictates how the receiver should be represented as a string.
 @returns A NSString that represents the receiver formatted to the format specified by the formatter object.
 */
- (NSString *)stringUsingFormatter:(NSDateFormatter *)formatter;

/**
 @brief Forms the receiver time in a brief style (ex. 11:11 PM). Ignores the date.
 @returns A NSString that represents the receiver formatted with timeStyle set to NSDateFormatterShortStyle and dateStyle set to NSDateFormatterNoStyle
 */
- (NSString *)shortTime;

/**
 @brief Forms the receiver time in a brief style (ex. 11:11 pm). Ignores the date.
 @returns A NSString that represents the receiver that is @b lower cased and formatted with timeStyle set to NSDateFormatterShortStyle and dateStyle set to NSDateFormatterNoStyle
 */
- (NSString *)shortTimeLowerCase;

/**
 @brief Forms the receiver date in a brief style (ex. 01/02/03). Ignores the time.
 @returns A NSString that represents the receiver formatted with timeStyle set to NSDateFormatterNoStyle and dateStyle set to NSDateFormatterShortStyle
 */
- (NSString *)shortDate;

/**
 @brief Grabs the hour component from the receiver
 @returns A NSInteger representing the hour (0-23)
 */
- (NSInteger)hourComponent;

/**
 @brief Sets a copy of receiver's seconds to zero (0)
 @returns A copy of the receiver that has it seconds equal to 0.
 */
- (NSDate *)zeroedSeconds;

/**
 @brief Sets a copy of the receiver to have it's date properties set to the current date (today).
 @returns A copy of the receiver that is set in the current date.
 */
- (NSDate *)currentDateTransform;

/**
 @brief Compares the hours of the receiver against anotherDate.
 @returns @b NSOrderedDescending, if the hour of the receiver is greater than anotherDate. @b NSOrderedAscending, if the hour of receiver is less than anotherDate. @b NSOrderedSame, if the hours are equal.
 */
- (NSComparisonResult)compareHours:(NSDate *)anotherDate;

/**
 @brief Compares the minutes of the receiver against anotherDate.
 @returns @b NSOrderedDescending, if the minute of the receiver is greater than anotherDate. @b NSOrderedAscending, if the minute of receiver is less than anotherDate. @b NSOrderedSame, if the minutes are equal.
 */
- (NSComparisonResult)compareMinutes:(NSDate *)anotherDate;

/**
 @brief Compares the overall times of the receiver against anotherDate.
 @returns @b NSOrderedDescending, if the time of the receiver is greater than anotherDate. @b NSOrderedAscending, if the time of receiver is less than anotherDate. @b NSOrderedSame, if the times are equal.
 */
- (NSComparisonResult)compareTimes:(NSDate *)anotherDate;

@end
