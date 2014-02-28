//
//  PriceRangeModel.m
//  shop
//
//  Created by QFish on 9/11/13.
//  Copyright (c) 2013 geek-zoo studio. All rights reserved.
//

#import "PriceRangeModel.h"

#pragma mark -

@implementation PriceRangeModel

@synthesize category_id = _category_id;
@synthesize price_ranges = _price_ranges;

- (void)load
{
}

- (void)unload
{
	[self saveCache];

	self.category_id = nil;
	self.price_ranges = nil;
}

#pragma mark -

- (void)loadCache
{
	self.price_ranges = [PRICE_RANGE readFromUserDefaults:@"PriceRangeModel.ranges"];
}

- (void)saveCache
{
	[PRICE_RANGE userDefaultsWrite:[self.price_ranges objectToString] forKey:@"PriceRangeModel.ranges"];
}

- (void)clearCache
{
	[PRICE_RANGE userDefaultsRemove:@"PriceRangeModel.ranges"];
	
	self.price_ranges = nil;
	self.category_id = nil;

	self.loaded = NO;
}

#pragma mark -

- (void)reload
{
	self.CANCEL_MSG( API.price_range );
	self.MSG( API.price_range )
    .INPUT( @"category_id", self.category_id );
}

#pragma mark -

ON_MESSAGE3( API, price_range, msg )
{
	if ( msg.succeed )
	{
		STATUS * status = msg.GET_OUTPUT( @"status" );
		if ( NO == status.succeed.boolValue )
		{
			msg.failed = YES;
			return;
		}
        
		self.price_ranges = msg.GET_OUTPUT( @"data" );
		self.loaded = YES;
		
		[self saveCache];
	}
}

@end
