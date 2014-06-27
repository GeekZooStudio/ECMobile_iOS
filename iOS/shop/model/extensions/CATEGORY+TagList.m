//
//  NSObject+TagList.m
//  shop
//
//  Created by QFish on 9/12/13.
//  Copyright (c) 2013 geek-zoo studio. All rights reserved.
//

#import "CATEGORY+TagList.h"

@implementation CATEGORY(TagList)

- (NSString *)tagTitle
{
    return self.name;
}

- (NSString *)tagRecipt
{
    return [self.id description];
}

@end
