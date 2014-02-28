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

#import "GoodsPageModel.h"

#pragma mark -

@implementation GoodsPageModel

@synthesize goods_id = _goods_id;
@synthesize html = _html;

- (void)load
{
}

- (void)unload
{
	self.goods_id = nil;
    self.html = nil;
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
	self.goods_id = nil;
	self.html = nil;

	self.loaded = NO;
}

#pragma mark -

- (void)reload
{
	self.CANCEL_MSG( API.goods_desc );
	self.MSG( API.goods_desc ).INPUT( @"goods_id", self.goods_id );
}

#pragma mark -

ON_MESSAGE3( API, goods_desc, msg )
{
	if ( msg.succeed )
	{
		STATUS * status = msg.GET_OUTPUT( @"status" );
		if ( NO == status.succeed.boolValue )
		{
			msg.failed = YES;
			return;
		}

		self.html = msg.GET_OUTPUT(@"data");
		self.loaded = YES;
    }
}

@end
