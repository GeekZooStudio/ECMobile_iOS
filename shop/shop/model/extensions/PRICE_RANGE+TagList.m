//
//  NSObject+TagList.m
//  shop
//
//  Created by QFish on 9/12/13.
//  Copyright (c) 2013 geek-zoo studio. All rights reserved.
//

#import "PRICE_RANGE+TagList.h"

@implementation PRICE_RANGE(TagList)

- (NSString *)tagTitle
{
    if ( nil == self.price_min || nil == self.price_max )
    {
        return @"全部";
    }
    else
    {
        return [NSString stringWithFormat:@"%@ - %@", self.price_min, self.price_max];
    }
}

- (NSString *)tagRecipt
{
    return [self.price_min description];
}

@end
