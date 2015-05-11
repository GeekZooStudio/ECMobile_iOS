//
//	 ______    ______    ______    
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_ 
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/ 
//
//	Powered by BeeFramework
//
//
//  B1_ProductListSearchBackgroundCell_iPhone.m
//  shop
//
//  Created by Chenyun on 14-5-27.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "B1_ProductListSearchBackgroundCell_iPhone.h"

#pragma mark -

@implementation B1_ProductListSearchBackgroundCell_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

- (void)load
{
	self.backgroundColor = [UIColor blackColor];
	self.alpha = 0.8;
	self.hidden = YES;
}

- (void)unload
{
}

- (void)dataDidChanged
{
}

- (void)layoutDidFinish
{
}

@end
