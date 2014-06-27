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

#import "CategoryModel.h"

#pragma mark -

@implementation CategoryModel

DEF_SINGLETON( CategoryModel )

@synthesize categories = _categories;

- (void)load
{
	self.categories = [NSMutableArray array];

	[self loadCache];
}

- (void)unload
{
	[self saveCache];
	
	self.categories = nil;
}

#pragma mark -

- (void)loadCache
{
	[self.categories removeAllObjects];
	[self.categories addObjectsFromArray:[CATEGORY readFromUserDefaults:@"CategoryModel.categories"]];
}

- (void)saveCache
{
	[CATEGORY userDefaultsWrite:[self.categories objectToString] forKey:@"CategoryModel.categories"];
}

- (void)clearCache
{
	[CATEGORY userDefaultsRemove:@"CategoryModel.categories"];

	[self.categories removeAllObjects];

	self.loaded = NO;
}

#pragma mark -

- (void)reload
{
	self.CANCEL_MSG( API.home_category );
	self.MSG( API.home_category );
}

#pragma mark -

ON_MESSAGE3( API, home_category, msg )
{
	if ( msg.succeed )
	{
		STATUS * status = msg.GET_OUTPUT( @"status" );
		if ( NO == status.succeed.boolValue )
		{
			msg.failed = YES;
			return;
		}

		[self.categories removeAllObjects];
		[self.categories addObjectsFromArray:msg.GET_OUTPUT( @"data" )];

		self.loaded = YES;
		
		[self saveCache];
	}
}

@end
