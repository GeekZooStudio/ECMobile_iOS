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

#import "CommentModel.h"

#pragma mark -

@implementation CommentModel

@synthesize goods_id = _goods_id;
@synthesize comments = _comments;

- (void)load
{
	self.comments = [NSMutableArray array];
}

- (void)unload
{
	self.goods_id = nil;
	self.comments = nil;
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
	[self.comments removeAllObjects];
	self.loaded = NO;
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

	[self gotoPage:(self.comments.count / 10)];
}

- (void)prevPage
{
}

- (void)gotoPage:(NSUInteger)index
{
	PAGINATION * page = [PAGINATION object];
	page.page	= __INT(1 + index);
	page.count	= __INT(10);
	
	self.CANCEL_MSG( API.comments );
	self
	.MSG( API.comments )
	.INPUT( @"goods_id", self.goods_id )
	.INPUT( @"pagination", page );
}

#pragma mark -

ON_MESSAGE3( API, comments, msg )
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
		
		self.total = 0;
		self.index = page.page.intValue;

		[self saveCache];
	}
}

@end
