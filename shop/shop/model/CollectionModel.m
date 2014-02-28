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

#import "CollectionModel.h"

#pragma mark -

@implementation CollectionModel

@synthesize rec_id = _rec_id;
@synthesize goods = _goods;

- (void)load
{
	self.goods = [NSMutableArray array];
	self.more = YES;

	[self loadCache];
}

- (void)unload
{
	[self saveCache];
	
	self.goods = nil;
	self.rec_id = nil;
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
	self.goods = nil;
	self.rec_id = nil;
	
	self.index = 0;
	self.total = 0;

	self.loaded = NO;
	self.more = YES;
}

#pragma mark -

- (void)firstPage
{
	[self gotoPage:(0)];
}

- (void)lastPage
{
}

- (void)nextPage
{
	if ( NO == self.more )
		return;

	[self gotoPage:(self.goods.count / 10)];
}

- (void)prevPage
{
}

- (void)gotoPage:(NSUInteger)index
{
	if ( NO == [UserModel online] )
		return;

	PAGINATION * page = [PAGINATION object];
	page.page	= __INT(1 + index);
	page.count	= __INT(10);
	
	self.CANCEL_MSG( API.user_collect_list );
	self.MSG( API.user_collect_list ).INPUT( @"pagination", page );
}

#pragma mark -

- (void)collect:(GOODS *)goods
{
	if ( NO == [UserModel online] )
		return;

	self.CANCEL_MSG( API.user_collect_create );
	self.MSG( API.user_collect_create ).INPUT( @"goods_id", goods.id );
}

- (void)uncollect:(COLLECT_GOODS *)goods
{
	if ( NO == [UserModel online] )
		return;

	self.CANCEL_MSG( API.user_collect_delete );
	self.MSG( API.user_collect_delete ).INPUT( @"rec_id", goods.rec_id );
}

#pragma mark -

ON_MESSAGE3( API, user_collect_list, msg )
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
			self.goods = [NSMutableArray arrayWithArray:msg.GET_OUTPUT(@"data")];
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

		self.total = 0;
		self.index = page.page.intValue;

		[self saveCache];
	}
}

ON_MESSAGE3( API, user_collect_create, msg )
{
	if ( msg.succeed )
	{
		STATUS * status = msg.GET_OUTPUT( @"status" );
		if ( NO == status.succeed.boolValue )
		{
			msg.failed = YES;
			return;
		}

		[self saveCache];
		[self firstPage];
	}
}

ON_MESSAGE3( API, user_collect_delete, msg )
{
	if ( msg.succeed )
	{
		STATUS * status = msg.GET_OUTPUT( @"status" );
		if ( NO == status.succeed.boolValue )
		{
			msg.failed = YES;
			return;
		}

		NSNumber * rec_id = msg.GET_INPUT( @"rec_id" );
		
		for ( COLLECT_GOODS * good in self.goods )
		{
			if ( [good.rec_id isEqualToNumber:rec_id] )
			{
				[self.goods removeObject:good];
				break;
			}
		}

		[self saveCache];
	}
}

@end
