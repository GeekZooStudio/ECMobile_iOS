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

#import "SearchModel.h"

#pragma mark -

@implementation SearchModel

DEF_SINGLETON( SearchModel )

@synthesize filter = _filter;
@synthesize goods = _goods;

- (void)load
{
	[super load];
	
	self.filter = [[[FILTER alloc] init] autorelease];
}

- (void)unload
{
	[self saveCache];
	
	self.filter = nil;
	self.goods = nil;
	
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
	self.filter = nil;
	self.goods = nil;
	self.loaded = NO;
}

#pragma mark -

- (void)prevPageFromServer
{
	PAGINATION * page = [[[PAGINATION alloc] init] autorelease];
	page.page = __INT( 1 );
	page.count = __INT( 10 );
	
	self.CANCEL_MSG( API.search );
	self
	.MSG( API.search )
	.INPUT( @"filter", self.filter )
	.INPUT( @"pagination", page );
}

- (void)nextPageFromServer
{
	if ( NO == self.more )
		return;
	
	PAGINATION * page = [[[PAGINATION alloc] init] autorelease];
	page.page = __INT( (self.goods.count / 10) + 1 );
	page.count = __INT( 10 );
	
	self.CANCEL_MSG( API.search );
	self
	.MSG( API.search )
	.INPUT( @"filter", self.filter )
	.INPUT( @"pagination", page );
}

#pragma mark -

- (void)handleMessage:(BeeMessage *)msg
{
	if ( [msg is:API.search] )
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
}

#pragma mark -

- (void)setValueWithFilter:(FILTER *)filter
{
    self.filter.brand_id = filter.brand_id;
    self.filter.category_id = filter.category_id;
    self.filter.price_range = filter.price_range;
}

@end

#pragma mark -

@implementation SearchByCheapestModel

- (void)load
{
	[super load];
	
	self.filter.sort_by = SEARCH_ORDER_BY_CHEAPEST;
}

@end

#pragma mark -

@implementation SearchByExpensiveModel

- (void)load
{
	[super load];
	
	self.filter.sort_by = SEARCH_ORDER_BY_EXPENSIVE;
}

@end

#pragma mark -

@implementation SearchByHotModel

- (void)load
{
	[super load];
	
	self.filter.sort_by = SEARCH_ORDER_BY_HOT;
}

@end