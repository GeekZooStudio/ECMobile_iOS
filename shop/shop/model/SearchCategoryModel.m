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

#import "SearchCategoryModel.h"

#pragma mark -

@implementation SearchCategoryModel

DEF_SINGLETON( SearchCategoryModel )

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
	self.categories = [NSMutableArray arrayWithArray:[TOP_CATEGORY readFromUserDefaults:@"SearchCategoryModel.topCategories"]];
}

- (void)saveCache
{
	[TOP_CATEGORY userDefaultsWrite:[self.categories objectToString] forKey:@"SearchCategoryModel.topCategories"];
}

- (void)clearCache
{
	[TOP_CATEGORY userDefaultsRemove:@"SearchCategoryModel.topCategories"];
	
	self.categories = nil;
	self.loaded = NO;
}

#pragma mark -

- (void)reload
{
	self.CANCEL_MSG( API.category );
	self.MSG( API.category );
}

#pragma mark -

ON_MESSAGE3( API, category, msg )
{
	if ( msg.succeed )
	{
		STATUS * status = msg.GET_OUTPUT( @"status" );
		if ( NO == status.succeed.boolValue )
		{
			msg.failed = YES;
			return;
		}

		self.categories = [NSMutableArray arrayWithArray:msg.GET_OUTPUT( @"data" )];
		self.loaded = YES;

		[self saveCache];
	}
}

@end
