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

#import "GoodsInfoModel.h"

#pragma mark -

@implementation GoodsInfoModel

@synthesize goods_id = _goods_id;
@synthesize goods = _goods;

- (void)load
{
}

- (void)unload
{
	self.goods_id = nil;
    self.goods = nil;
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
	self.goods = nil;

	self.loaded = NO;
}

#pragma mark -

- (void)reload
{
	self.CANCEL_MSG( API.goods );
	self.MSG( API.goods ).INPUT( @"goods_id", self.goods_id );
}

#pragma mark -

ON_MESSAGE3( API, goods, msg )
{
	if ( msg.succeed )
	{
		STATUS * status = msg.GET_OUTPUT( @"status" );
		if ( NO == status.succeed.boolValue )
		{
			msg.failed = YES;
			return;
		}
        
		self.goods = msg.GET_OUTPUT(@"data");
		self.loaded = YES;
    }
}

@end
