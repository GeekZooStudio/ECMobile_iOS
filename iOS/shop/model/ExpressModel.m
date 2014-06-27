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

#import "ExpressModel.h"

#pragma mark -

static NSString * kKuaidi100Key = nil;

@implementation ExpressModel

+ (NSString *)kuaidi100Key
{
    return kKuaidi100Key;
}

+ (void)setKuaidi100Key:(NSString *)key
{
    kKuaidi100Key = [key copy];
}

- (void)load
{
	self.content = [NSMutableArray array];
}

- (void)unload
{
	self.content = nil;
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
	self.content = nil;
}

#pragma mark -

- (void)reload
{
	if ( NO == [UserModel online] )
		return;

    self.CANCEL_MSG( API.order_express );
	self.MSG( API.order_express )
	.INPUT( @"order_id", self.order.order_id )
	.INPUT( @"app_key", [[self class] kuaidi100Key] );
}

#pragma mark -

ON_MESSAGE3( API, order_express, msg )
{
	if ( msg.succeed )
	{
		STATUS * status = msg.GET_OUTPUT( @"status" );
		if ( NO == status.succeed.boolValue )
		{
			msg.failed = YES;
			return;
		}
		
		[self.content removeAllObjects];
		
		NSArray * array = msg.GET_OUTPUT( @"data_content" );
		if ( array )
		{
			[self.content removeAllObjects];
			[self.content addObjectsFromArray:array];
			[self.content sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
				NSDate * date1 = [((EXPRESS *)obj1).time asNSDate];
				NSDate * date2 = [((EXPRESS *)obj2).time asNSDate];
				return -[date1 compare:date2];
			}];
		}

		self.shipping_name = msg.GET_OUTPUT( @"data_shipping_name" );

		[self saveCache];
	}
}

@end
