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
	[super load];
}

- (void)unload
{
	[self saveCache];
	
	self.goods = nil;
	self.total = nil;
	
	[super unload];
}

#pragma mark -

- (void)loadCache
{
	NSString * string = [self userDefaultsRead:@"CartModel.goods"];
	if ( string )
	{
		self.goods = [CART_GOODS unserializeObject:[string objectFromJSONString]];
	}
	
	NSString * string2 = [self userDefaultsRead:@"CartModel.total"];
	if ( string2 )
	{
		self.total = [TOTAL unserializeObject:[string2 objectFromJSONString]];
	}
}

- (void)saveCache
{
	NSString * string = [[self.goods serializeObject] JSONString];
	if ( string )
	{
		[self userDefaultsWrite:string forKey:@"CartModel.goods"];
	}

	NSString * string2 = [[self.total serializeObject] JSONString];
	if ( string2 )
	{
		[self userDefaultsWrite:string2 forKey:@"CartModel.total"];
	}
}

- (void)clearCache
{
	self.goods = nil;
	self.total = nil;
	
	self.loaded = NO;
}

#pragma mark -

- (void)fetchFromServer
{
	if ( [UserModel online] )
	{
		self.CANCEL_MSG( API.cart_list );
		self.MSG( API.cart_list );
	}
}

#pragma mark -

- (void)create:(GOODS *)goods number:(NSNumber *)number spec:(NSArray *)spec
{
	self.CANCEL_MSG( API.cart_create );
	self
	.MSG( API.cart_create )
	.INPUT( @"goods_id", goods.id )
	.INPUT( @"number", number )
	.INPUT( @"spec", spec );
}

- (void)remove:(CART_GOODS *)goods
{
	self.CANCEL_MSG( API.cart_delete );
	self
	.MSG( API.cart_delete )
	.INPUT( @"rec_id", goods.rec_id );
}

- (void)update:(CART_GOODS *)goods new_number:(NSNumber *)new_number
{
	self.CANCEL_MSG( API.cart_update );
	self
	.MSG( API.cart_update )
	.INPUT( @"rec_id", goods.rec_id )
	.INPUT( @"new_number", new_number );
}

#pragma mark -

- (void)handleMessage:(BeeMessage *)msg
{
	if ( [msg is:API.cart_list] )
	{
		if ( msg.succeed )
		{
			STATUS * status = msg.GET_OUTPUT( @"status" );
			if ( NO == status.succeed.boolValue )
			{
				msg.failed = YES;
				return;
			}
            
			self.goods = [NSMutableArray arrayWithArray:msg.GET_OUTPUT(@"data_goods_list")];
			self.total = msg.GET_OUTPUT( @"data_total" );
			self.loaded = YES;
			
			[self saveCache];
			
			[self postNotification:self.UPDATED];
		}
	}
	else if ( [msg is:API.cart_create] )
	{
		if ( msg.succeed )
		{
			STATUS * status = msg.GET_OUTPUT( @"status" );
			if ( NO == status.succeed.boolValue )
			{
				msg.failed = YES;
				return;
			}

//			[self fetchFromServer];
			[self saveCache];
			
			[self postNotification:self.UPDATED];
		}
	}
	else if ( [msg is:API.cart_delete] )
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
		}
	}
	else if ( [msg is:API.cart_update] )
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
		}
	}
}

@end
