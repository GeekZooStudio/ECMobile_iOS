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

#import "BannerModel.h"

#pragma mark -

@implementation BannerModel

DEF_SINGLETON( BannerModel )

@synthesize banners = _banners;
@synthesize goods = _goods;

- (void)load
{
	self.banners = [NSMutableArray array];
	self.goods = [NSMutableArray array];

	[self loadCache];
}

- (void)unload
{
	[self saveCache];

	self.banners = nil;
	self.goods = nil;
}

#pragma mark -

- (void)loadCache
{
	[self.banners removeAllObjects];
	[self.banners addObjectsFromArray:[BANNER readFromUserDefaults:@"BannerModel.banners"]];
	
	[self.goods removeAllObjects];
	[self.goods addObjectsFromArray:[SIMPLE_GOODS readFromUserDefaults:@"BannerModel.goods"]];
}

- (void)saveCache
{
	[BANNER userDefaultsWrite:[self.banners objectToString] forKey:@"BannerModel.banners"];
	[SIMPLE_GOODS userDefaultsWrite:[self.goods objectToString] forKey:@"BannerModel.goods"];
}

- (void)clearCache
{
	[SIMPLE_GOODS removeFromUserDefaults:@"BannerModel.goods"];
	[BANNER removeFromUserDefaults:@"BannerModel.goods"];

	[self.banners removeAllObjects];
	[self.goods removeAllObjects];
	
	self.loaded = NO;
}

#pragma mark -

- (void)reload
{
	self.CANCEL_MSG( API.home_data );
	self.MSG( API.home_data );
}

#pragma mark -

ON_MESSAGE3( API, home_data, msg )
{
	if ( msg.succeed )
	{
		STATUS * status = msg.GET_OUTPUT( @"status" );
		if ( NO == status.succeed.boolValue )
		{
			msg.failed = YES;
			return;
		}

		[self.banners removeAllObjects];
		[self.banners addObjectsFromArray:msg.GET_OUTPUT( @"data_player" )];
		
		[self.goods removeAllObjects];
		[self.goods addObjectsFromArray:msg.GET_OUTPUT( @"data_promote_goods" )];

		self.loaded = YES;

		[self saveCache];
	}
}

@end
