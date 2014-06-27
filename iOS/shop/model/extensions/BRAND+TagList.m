//
//  NSObject+TagList.m
//  shop
//
//  Created by QFish on 9/12/13.
//  Copyright (c) 2013 geek-zoo studio. All rights reserved.
//

#import "BRAND+TagList.h"

#pragma mark -

@implementation BRAND (TagList)

- (NSString *)tagTitle
{
    return self.brand_name;
}

- (NSString *)tagRecipt
{
    return [self.brand_id description];
}

@end
