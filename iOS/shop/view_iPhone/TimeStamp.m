//
//  TimeStamp.m
//  shop
//
//  Created by QFish on 6/3/14.
//  Copyright (c) 2014 geek-zoo studio. All rights reserved.
//

#import "TimeStamp.h"



static NSMutableDictionary * stampMap;

@implementation TimeStamp

- (NSTimeInterval)duration
{
    return _end - _begin;
}

@end

@implementation TimeStamper

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        stampMap = [[NSMutableDictionary alloc] init];
    });
}

+ (void)beginForKey:(NSString *)key
{
    TimeStamp * t = stampMap[key];

    if ( !t )
    {
        t = [[TimeStamp alloc] init];
        stampMap[key] = t;
    }
    
    t.begin = [[NSDate date] timeIntervalSince1970]*1000;
}

+ (void)endForKey:(NSString *)key
{
    TimeStamp * t = stampMap[key];
    t.end = [[NSDate date] timeIntervalSince1970]*1000;
    
    [self logForKey:key];
}

+ (void)endForKey:(NSString *)key desc:(NSString *)desc
{
    TimeStamp * t = stampMap[key];
    t.end = [[NSDate date] timeIntervalSince1970]*1000;
    
    [self logForKey:key desc:desc];
}

+ (NSTimeInterval)durationForKey:(NSString *)key
{
    TimeStamp * t = stampMap[key];
    return t.duration;
}

+ (void)logForKey:(NSString *)key
{
    NSLog(@"%@ costs %.f ms", key, [self durationForKey:key]);
}

+ (void)logForKey:(NSString *)key desc:(NSString *)desc
{
    NSLog(@"[%@] %@ costs %.f ms", desc, key, [self durationForKey:key]);
}

+ (NSArray *)allDurations
{
    return [stampMap allValues];
}

@end
