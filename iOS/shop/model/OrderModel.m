/*
 *                                                                          
 *       _/_/_/                      _/        _/_/_/_/_/                     
 *    _/          _/_/      _/_/    _/  _/          _/      _/_/      _/_/    
 *   _/  _/_/  _/_/_/_/  _/_/_/_/  _/_/          _/      _/    _/  _/    _/   
 *  _/    _/  _/        _/        _/  _/      _/        _/    _/  _/    _/    
 *   _/_/_/    _/_/_/    _/_/_/  _/    _/  _/_/_/_/_/    _/_/      _/_/       
 *                                                                          
 *
 *  Copyright 2013-2014, Geek Zoo Studio
 *  http://www.ecmobile.cn/license.html
 *
 *  HQ China:
 *    2319 Est.Tower Van Palace 
 *    No.2 Guandongdian South Street 
 *    Beijing , China
 *
 *  U.S. Office:
 *    One Park Place, Elmira College, NY, 14901, USA
 *
 *  QQ Group:   329673575
 *  BBS:        bbs.ecmobile.cn
 *  Fax:        +86-10-6561-5510
 *  Mail:       info@geek-zoo.com
 */

#import "OrderModel.h"

#pragma mark -

@implementation OrderModel

@synthesize type = _type;
@synthesize orders = _orders;
@synthesize html = _html;

- (void)load
{
	[super load];
}

- (void)unload
{
	[self saveCache];
	
	[super unload];
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

- (void)prevPageFromServer
{
	PAGINATION * page = [[[PAGINATION alloc] init] autorelease];
	page.page = __INT( 1 );
	page.count = __INT( 10 );
	
	self.CANCEL_MSG( API.order_list );
	self
	.MSG( API.order_list )
	.INPUT( @"type", self.type )
	.INPUT( @"pagination", page );
}

- (void)nextPageFromServer
{
	if ( NO == self.more )
		return;

	PAGINATION * page = [[[PAGINATION alloc] init] autorelease];
	page.page = __INT( (self.orders.count / 10) + 1 );
	page.count = __INT( 10 );
	
	self.CANCEL_MSG( API.order_list );
	self
	.MSG( API.order_list )
	.INPUT( @"type", self.type )
	.INPUT( @"pagination", page );
}

#pragma mark -

- (void)affirmReceived:(ORDER *)order
{
	self.CANCEL_MSG( API.order_affirmReceived );
	self.MSG( API.order_affirmReceived ).INPUT( @"order_id", order.order_id );
}

- (void)cancel:(ORDER *)order
{
	self.CANCEL_MSG( API.order_cancel );
	self.MSG( API.order_cancel ).INPUT( @"order_id", order.order_id );	
}

- (void)pay:(ORDER *)order
{
	self.CANCEL_MSG( API.order_pay );
	self.MSG( API.order_pay ).INPUT( @"order_id", order.order_id );	
}

#pragma mark -

- (void)handleMessage:(BeeMessage *)msg
{
	if ( [msg is:API.order_list] )
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
	else if ( [msg is:API.order_affirmReceived] )
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
	else if ( [msg is:API.order_cancel] )
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
	else if ( [msg is:API.order_pay] )
	{
		if ( msg.succeed )
		{
			STATUS * status = msg.GET_OUTPUT( @"status" );
			if ( NO == status.succeed.boolValue )
			{
				msg.failed = YES;
				return;
			}

			self.html = msg.GET_OUTPUT( @"data" );
		}
	}
}

@end

#pragma mark -

@implementation OrderAwaitPayModel

DEF_SINGLETON( OrderAwaitPayModel )

- (void)load
{
	self.type = ORDER_LIST_AWAIT_PAY;
}

@end

#pragma mark -

@implementation OrderAwaitShipModel

DEF_SINGLETON( OrderAwaitShipModel )

- (void)load
{
	self.type = ORDER_LIST_AWAIT_SHIP;
}

@end

#pragma mark -

@implementation OrderShippedModel

DEF_SINGLETON( OrderShippedModel )

- (void)load
{
	self.type = ORDER_LIST_SHIPPED;
}

@end

#pragma mark -

@implementation OrderFinishedModel

DEF_SINGLETON( OrderFinishedModel )

- (void)load
{
	self.type = ORDER_LIST_FINISHED;
}

@end
