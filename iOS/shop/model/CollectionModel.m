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

#import "CollectionModel.h"

#pragma mark -

@implementation CollectionModel

DEF_SINGLETON( CollectionModel )

@synthesize rec_id = _rec_id;
@synthesize goods = _goods;

- (void)load
{
	[super load];
}

- (void)unload
{
	[self saveCache];
	
	self.goods = nil;
	self.rec_id = nil;

	[super unload];
}

#pragma mark -

- (void)loadCache
{
	NSString * string = [self userDefaultsRead:@"CollectionModel.goods"];
	if ( string )
	{
		self.goods = [COLLECT_GOODS unserializeObject:[string objectFromJSONString]];
	}
}

- (void)saveCache
{
	NSString * string = [[self.goods serializeObject] JSONString];
	if ( string )
	{
		[self userDefaultsWrite:string forKey:@"CollectionModel.goods"];
	}
}

- (void)clearCache
{
	self.goods = nil;
	self.rec_id = nil;

	self.loaded = NO;
}

#pragma mark -

- (void)prevPageFromServer
{
	PAGINATION * page = [[[PAGINATION alloc] init] autorelease];
	page.page = __INT( 1 );
	page.count = __INT( 10 );

	self.CANCEL_MSG( API.user_collect_list );
	self
	.MSG( API.user_collect_list )
	.INPUT( @"pagination", page );
}

- (void)nextPageFromServer
{
	if ( NO == self.more )
		return;

	PAGINATION * page = [[[PAGINATION alloc] init] autorelease];
	page.page = __INT( (self.goods.count / 10) + 1 );
	page.count = __INT( 10 );
	
	self.CANCEL_MSG( API.user_collect_list );
	self
	.MSG( API.user_collect_list )
	.INPUT( @"pagination", page );
}

#pragma mark -

- (void)collect:(GOODS *)goods
{
	self.CANCEL_MSG( API.user_collect_create );
	self.MSG( API.user_collect_create ).INPUT( @"goods_id", goods.id );
}

- (void)uncollect:(COLLECT_GOODS *)goods
{
	self.CANCEL_MSG( API.user_collect_delete );
	self.MSG( API.user_collect_delete ).INPUT( @"rec_id", goods.rec_id );
}

#pragma mark -

- (void)handleMessage:(BeeMessage *)msg
{
	if ( [msg is:API.user_collect_list] )
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
			
			[self saveCache];
		}
	}
	else if ( [msg is:API.user_collect_create] )
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
		}
	}
	else if ( [msg is:API.user_collect_delete] )
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
}

@end
