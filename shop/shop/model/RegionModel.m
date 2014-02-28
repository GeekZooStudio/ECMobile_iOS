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

#import "RegionModel.h"

#pragma mark -

@implementation RegionModel

DEF_SINGLETON( RegionModel )

- (void)load
{
	[self loadCache];
}

- (void)unload
{
	[self saveCache];
	
	self.regions = nil;
}

#pragma mark -

- (void)loadCache
{
	self.regions = [REGION readFromUserDefaults:@"RegionModel.regions"];
}

- (void)saveCache
{
	[REGION userDefaultsWrite:[self.regions objectToString] forKey:@"RegionModel.regions"];
}

- (void)clearCache
{
	[REGION userDefaultsRemove:@"RegionModel.regions"];
	
	self.regions = nil;
	self.parent_id = nil;
	
	self.loaded = NO;
}

#pragma mark -

- (void)reload
{
	self.CANCEL_MSG( API.region );
	self.MSG( API.region ).INPUT( @"parent_id", self.parent_id );
}

#pragma mark -

ON_MESSAGE3( API, region, msg )
{
	if ( msg.succeed )
	{
		STATUS * status = msg.GET_OUTPUT( @"status" );
		if ( NO == status.succeed.boolValue )
		{
			msg.failed = YES;
			return;
		}

		self.regions = msg.GET_OUTPUT( @"data" );
		self.loaded = YES;
		
		[self saveCache];
	}
}

@end
