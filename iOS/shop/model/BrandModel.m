//
//  BrandModel.m
//  shop
//
//  Created by QFish on 9/11/13.
//  Copyright (c) 2013 geek-zoo studio. All rights reserved.
//

#import "BrandModel.h"

@implementation BrandModel

@synthesize category_id = _category_id;
@synthesize brands = _brands;

- (void)load
{
	self.brands = [NSMutableArray array];
}

- (void)unload
{
	self.brands = nil;
	self.category_id = nil;
}

#pragma mark -

- (void)loadCache
{
}

- (void)saveCache
{
}

- (void)clearCache
{
	[self.brands removeAllObjects];
	self.loaded = NO;
}

#pragma mark -

- (void)reload
{
	self.CANCEL_MSG( API.brand );
	self.MSG( API.brand ).INPUT( @"category_id", self.category_id );
}

#pragma mark -

ON_MESSAGE3( API, brand, msg )
{
	if ( msg.succeed )
	{
		STATUS * status = msg.GET_OUTPUT( @"status" );
		if ( NO == status.succeed.boolValue )
		{
			msg.failed = YES;
			return;
		}

		[self.brands removeAllObjects];
		[self.brands addObjectsFromArray:msg.GET_OUTPUT( @"data" )];

		self.loaded = YES;

		[self saveCache];
	}
}

@end
