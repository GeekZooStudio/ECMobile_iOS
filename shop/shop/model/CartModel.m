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

#import "CartModel.h"
#import "UserModel.h"

#pragma mark -

@implementation CartModel

DEF_SINGLETON( CartModel )

DEF_NOTIFICATION( UPDATED )

@synthesize goods = _goods;
@synthesize total = _total;

- (void)load
{
	self.goods = [NSMutableArray array];

	[self observeNotification:UserModel.LOGIN];
	[self observeNotification:UserModel.LOGOUT];
	[self observeNotification:UserModel.KICKOUT];
	[self loadCache];
}

- (void)unload
{
	[self saveCache];
	[self unobserveAllNotifications];
	
	self.goods = nil;
	self.total = nil;
}

#pragma mark -

- (void)loadCache
{
	[self.goods removeAllObjects];
	[self.goods addObjectsFromArray:[CART_GOODS readFromUserDefaults:@"CartModel.goods"]];

	self.total = [TOTAL readFromUserDefaults:@"CartModel.total"];
}

- (void)saveCache
{
	[CART_GOODS userDefaultsWrite:[self.goods objectToString] forKey:@"CartModel.goods"];
	[TOTAL userDefaultsWrite:[self.total objectToString] forKey:@"CartModel.total"];
}

- (void)clearCache
{
	[CART_GOODS userDefaultsRemove:@"CartModel.goods"];
	[TOTAL userDefaultsRemove:@"CartModel.total"];
	
	[self.goods removeAllObjects];
	self.total = nil;

	self.loaded = NO;
}

#pragma mark -

- (void)reload
{
	if ( NO == [UserModel online] )
		return;

	self.CANCEL_MSG( API.cart_list );
	self.MSG( API.cart_list );
}

#pragma mark -

- (void)create:(GOODS *)goods number:(NSNumber *)number spec:(NSArray *)spec
{
	if ( NO == [UserModel online] )
		return;

	self.CANCEL_MSG( API.cart_create );
	self
	.MSG( API.cart_create )
	.INPUT( @"goods_id", goods.id )
	.INPUT( @"number", number )
	.INPUT( @"spec", spec );
}

- (void)remove:(CART_GOODS *)goods
{
	if ( NO == [UserModel online] )
		return;

	self.CANCEL_MSG( API.cart_delete );
	self
	.MSG( API.cart_delete )
	.INPUT( @"rec_id", goods.rec_id );
}

- (void)update:(CART_GOODS *)goods new_number:(NSNumber *)new_number
{
	if ( NO == [UserModel online] )
		return;

	self.CANCEL_MSG( API.cart_update );
	self
	.MSG( API.cart_update )
	.INPUT( @"rec_id", goods.rec_id )
	.INPUT( @"new_number", new_number );
}

#pragma mark -

ON_NOTIFICATION3( UserModel, LOGIN, notification )
{
//	[self reload];
}

ON_NOTIFICATION3( UserModel, LOGOUT, notification )
{
	[self cancelMessages];
	[self clearCache];
}

ON_NOTIFICATION3( UserModel, KICKOUT, notification )
{
	[self cancelMessages];
	[self clearCache];
}

#pragma mark -

ON_MESSAGE3( API, cart_list, msg )
{
	if ( msg.succeed )
	{
		STATUS * status = msg.GET_OUTPUT( @"status" );
		if ( NO == status.succeed.boolValue )
		{
			msg.failed = YES;
			return;
		}
		
		[self.goods removeAllObjects];
		[self.goods addObjectsFromArray:msg.GET_OUTPUT(@"data_goods_list")];
		
		self.total = msg.GET_OUTPUT( @"data_total" );
		
		self.loaded = YES;

		[self saveCache];
		[self postNotification:self.UPDATED];
	}
}

ON_MESSAGE3( API, cart_create, msg )
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
		[self postNotification:self.UPDATED];

		[self reload];
	}
}

ON_MESSAGE3( API, cart_delete, msg )
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
		
		for ( CART_GOODS * good in self.goods )
		{
			if ( [good.rec_id isEqualToNumber:rec_id] )
			{
				[self.goods removeObject:good];
				break;
			}
		}

		self.total = msg.GET_OUTPUT( @"total" );
		
		[self saveCache];
		[self postNotification:self.UPDATED];
		
		[self reload];
	}
}

ON_MESSAGE3( API, cart_update, msg )
{
	if ( msg.succeed )
	{
		STATUS * status = msg.GET_OUTPUT( @"status" );
		if ( NO == status.succeed.boolValue )
		{
			msg.failed = YES;
			return;
		}

		NSNumber * new_number = msg.GET_INPUT( @"new_number" );
		NSNumber * rec_id = msg.GET_INPUT( @"rec_id" );
		
		for ( CART_GOODS * good in self.goods )
		{
			if ( [good.rec_id isEqualToNumber:rec_id] )
			{
				good.goods_number = [NSString stringWithFormat:@"%@", new_number];
				break;
			}
		}

		self.total = msg.GET_OUTPUT( @"total" );

		[self saveCache];
		[self postNotification:self.UPDATED];
		
		[self reload];
	}
}

@end
