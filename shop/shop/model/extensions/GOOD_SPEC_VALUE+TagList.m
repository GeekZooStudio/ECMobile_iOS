//
//  NSObject+TagList.m
//  shop
//
//  Created by QFish on 9/12/13.
//  Copyright (c) 2013 geek-zoo studio. All rights reserved.
//

#import "GOOD_SPEC_VALUE+TagList.h"

#pragma mark -

@implementation GOOD_SPEC_VALUE (TagList)

- (NSString *)tagTitle
{
    return [NSString stringWithFormat:@"%@( %@ )", self.value.label, self.value.format_price];
}

- (NSString *)tagRecipt
{
    return [self.value.id description];
}

@end
