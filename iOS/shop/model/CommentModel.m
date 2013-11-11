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

#import "CommentModel.h"

#pragma mark -

@implementation CommentModel

@synthesize goods_id = _goods_id;
@synthesize comments = _comments;

- (void)load
{
	[super load];
}

- (void)unload
{
	self.goods_id = nil;
	self.comments = nil;

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
	self.comments = nil;
	self.loaded = NO;
}

#pragma mark -

- (void)prevPageFromServer
{
	PAGINATION * page = [[[PAGINATION alloc] init] autorelease];
	page.page = __INT( 1 );
	page.count = __INT( 10 );
	
	self.CANCEL_MSG( API.comments );
	self
	.MSG( API.comments )
	.INPUT( @"goods_id", self.goods_id )
	.INPUT( @"pagination", page );
}

- (void)nextPageFromServer
{
	if ( NO == self.more )
		return;

	PAGINATION * page = [[[PAGINATION alloc] init] autorelease];
	page.page = __INT( (self.comments.count / 10) + 1 );
	page.count = __INT( 10 );
	
	self.CANCEL_MSG( API.comments );
	self
	.MSG( API.comments )
	.INPUT( @"goods_id", self.goods_id )
	.INPUT( @"pagination", page );
}

#pragma mark -

- (void)handleMessage:(BeeMessage *)msg
{
	if ( [msg is:API.comments] )
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
				self.comments = [NSMutableArray arrayWithArray:msg.GET_OUTPUT( @"data" )];
				self.loaded = YES;
			}
			else
			{
				NSArray * array = msg.GET_OUTPUT(@"data");
				if ( array && array.count )
				{
					[self.comments addObjectsFromArray:array];
					self.loaded = YES;
				}
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

@end
