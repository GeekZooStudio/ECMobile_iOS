//
//  NSObject+ScrollViewExt.h
//  shop
//
//  Created by QFish on 2/13/14.
//  Copyright (c) 2014 geek-zoo studio. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, UIScrollViewIndex) {
    UIScrollViewIndexDefault = 0,
    UIScrollViewIndexFirst,
    UIScrollViewIndexLast,
    UIScrollViewIndexSingle
};

@interface NSObject (ScrollViewExt)

@property (nonatomic, assign) BOOL       scrollSelected;
@property (nonatomic, assign) BOOL       scrollEditing;
@property (nonatomic, assign) NSUInteger scrollIndex;
@property (nonatomic, assign) NSUInteger scrollSection;

@end