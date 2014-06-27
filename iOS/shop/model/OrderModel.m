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

#import "OrderModel.h"

#pragma mark -

@implementation OrderModel

@synthesize type = _type;
@synthesize orders = _orders;
@synthesize html = _html;

- (void)load
{
}

- (void)unload
{
	[self saveCache];
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
	self.orders = nil;
	self.html = nil;
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

	[self gotoPage:(self.orders.count / 10)];
}

- (void)gotoPage:(NSUInteger)index
{
	if ( NO == [UserModel online] )
		return;

	PAGINATION * page = [PAGINATION object];
	page.page	= __INT( 1 + index );
	page.count	= __INT( 10 );

	self.CANCEL_MSG( API.order_list );
	self.MSG( API.order_list )
	.INPUT( @"type", self.type )
	.INPUT( @"pagination", page );
}

#pragma mark -

- (void)affirmReceived:(ORDER *)order
{
	if ( NO == [UserModel online] )
		return;

	self.CANCEL_MSG( API.order_affirmReceived );
	self.MSG( API.order_affirmReceived ).INPUT( @"order_id", order.order_id );
}

- (void)cancel:(ORDER *)order
{
	if ( NO == [UserModel online] )
		return;

	self.CANCEL_MSG( API.order_cancel );
	self.MSG( API.order_cancel ).INPUT( @"order_id", order.order_id );	
}

- (void)pay:(ORDER *)order
{
	if ( NO == [UserModel online] )
		return;

	self.CANCEL_MSG( API.order_pay );

	self.MSG( API.order_pay )
		.INPUT( @"order_id", order.order_id )
		.INPUT( @"order", order );
}

#pragma mark -

ON_MESSAGE3( API, order_list, msg )
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
			self.orders = msg.GET_OUTPUT( @"data" );
		}
		else
		{
			NSArray * array = msg.GET_OUTPUT(@"data");
			if ( array && array.count )
			{
				[self.orders addObjectsFromArray:array];
			}
		}
		
		self.loaded = YES;
		
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

ON_MESSAGE3( API, order_affirmReceived, msg )
{
	if ( msg.succeed )
	{
		STATUS * status = msg.GET_OUTPUT( @"status" );
		if ( NO == status.succeed.boolValue )
		{
			msg.failed = YES;
			return;
		}
		
		NSNumber * order_id = msg.GET_INPUT( @"order_id" );
		
		for ( ORDER * order in self.orders )
		{
			if ( [order.order_id isEqualToNumber:order_id] )
			{
				// TODO;
				break;
			}
		}
		
		[self saveCache];
	}
}

ON_MESSAGE3( API, order_cancel, msg )
{
	if ( msg.succeed )
	{
		STATUS * status = msg.GET_OUTPUT( @"status" );
		if ( NO == status.succeed.boolValue )
		{
			msg.failed = YES;
			return;
		}
		
		NSNumber * order_id = msg.GET_INPUT( @"order_id" );
		
		for ( ORDER * order in self.orders )
		{
			if ( [order.order_id isEqualToNumber:order_id] )
			{
				// TODO:
				//					[self.orders removeObject:order];
				break;
			}
		}
		
		[self saveCache];
	}
}

ON_MESSAGE3( API, order_pay, msg )
{
	if ( msg.succeed )
	{
		STATUS * status = msg.GET_OUTPUT( @"status" );
		if ( NO == status.succeed.boolValue )
		{
			msg.failed = YES;
			return;
		}
	}
}

@end
