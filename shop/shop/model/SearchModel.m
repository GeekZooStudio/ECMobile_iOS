//
//                       __
//                      /\ \   _
//    ____    ____   ___\ \ \_/ \           _____    ___     ___
//   / _  \  / __ \ / __ \ \    <     __   /\__  \  / __ \  / __ \
//  /\ \_\ \/\  __//\  __/\ \ \\ \   /\_\  \/_/  / /\ \_\ \/\ \_\ \
//  \ \____ \ \____\ \____\\ \_\\_\  \/_/   /\____\\ \____/\ \____/
//   \/____\ \/____/\/____/ \/_//_/         \/____/ \/___/  \/___/
//     /\____/
//     \/___/
//
//	Powered by BeeFramework
//

#import "SearchModel.h"

#pragma mark -

@implementation SearchModel

@synthesize filter = _filter;
@synthesize goods = _goods;

- (void)load
{
	self.filter = [FILTER object];

	[self loadCache];
}

- (void)unload
{
	[self saveCache];
	
	self.filter = nil;
	self.goods = nil;
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
	self.filter = nil;
	self.goods = nil;
	self.loaded = NO;
}

#pragma mark -

- (void)firstPage
{
	[self gotoPage:0];
}

- (void)lastPage
{
}

- (void)prevPage
{
}

- (void)nextPage
{
	if ( NO == self.more )
		return;

	[self gotoPage:(self.goods.count / 10)];
}

- (void)gotoPage:(NSUInteger)index
{
	PAGINATION * page = [[[PAGINATION alloc] init] autorelease];
	page.page	= __INT( 1 + index );
	page.count	= __INT( 10 );

	self.CANCEL_MSG( API.search );
	self.MSG( API.search )
	.INPUT( @"filter", self.filter )
	.INPUT( @"pagination", page );
}

#pragma mark -

ON_MESSAGE3( API, search, msg )
{
	if ( msg.succeed )
	{
		STATUS * status = msg.GET_OUTPUT( @"status" );
		if ( NO == status.succeed.boolValue )
		{
			msg.failed = YES;
			return;
		}

		PAGINATION * page = msg.GET_INPUT( @"pagination" );
		if ( page && [page.page isEqualToNumber:@1] )
		{
			self.goods = [NSMutableArray arrayWithArray:msg.GET_OUTPUT( @"data" )];
			self.loaded = YES;
		}
		else
		{
			NSArray * array = msg.GET_OUTPUT(@"data");
			if ( array && array.count )
			{
				[self.goods addObjectsFromArray:array];
			}
			self.loaded = YES;
		}
		
		PAGINATED * paged = msg.GET_OUTPUT( @"paginated" );
		if ( paged )
		{
			self.more = paged.more.boolValue;
		}
		else
		{
			self.more = NO;
		}

		[self saveCache];
	}
}

- (void)modifiFilter:(FILTER *)filter
{
    self.filter.brand_id = filter.brand_id;
    self.filter.category_id = filter.category_id;
    self.filter.price_range = filter.price_range;
}

@end
