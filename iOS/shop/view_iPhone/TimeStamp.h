//
//  TimeStamp.h
//  shop
//
//  Created by QFish on 6/3/14.
//  Copyright (c) 2014 geek-zoo studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeStamp : NSObject
@property (nonatomic, assign) NSTimeInterval begin;
@property (nonatomic, assign) NSTimeInterval end;
- (NSTimeInterval)duration;
@end

@interface TimeStamper : NSObject
+ (void)beginForKey:(NSString *)key;
+ (void)endForKey:(NSString *)key;
+ (void)endForKey:(NSString *)key desc:(NSString *)desc;
+ (NSTimeInterval)durationForKey:(NSString *)key;
+ (void)logForKey:(NSString *)key;
+ (void)logForKey:(NSString *)key desc:(NSString *)desc;
+ (NSArray *)allDurations;
@end
