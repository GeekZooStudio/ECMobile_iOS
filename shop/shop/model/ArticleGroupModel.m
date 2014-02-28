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

#import "ArticleGroupModel.h"

#pragma mark -

@implementation ArticleGroupModel

DEF_SINGLETON( ArticleGroupModel )

@synthesize articleGroups = _articleGroups;

- (void)load
{
	self.articleGroups = [NSMutableArray array];

	[self loadCache];
}

- (void)unload
{
	[self saveCache];
	
	self.articleGroups = nil;
}

#pragma mark -

- (void)loadCache
{
	[self.articleGroups removeAllObjects];
	[self.articleGroups addObjectsFromArray:[ARTICLE_GROUP readFromUserDefaults:@"ArticleGroupModel.articleGroups"]];
}

- (void)saveCache
{
	[ARTICLE_GROUP userDefaultsWrite:[self.articleGroups objectToString] forKey:@"ArticleGroupModel.articleGroups"];
}

- (void)clearCache
{
	[ARTICLE_GROUP userDefaultsRemove:@"ArticleGroupModel.articleGroups"];

	[self.articleGroups removeAllObjects];

	self.loaded = NO;
}

#pragma mark -

- (void)reload
{
	self.CANCEL_MSG( API.shopHelp );
	self.MSG( API.shopHelp );
}

#pragma mark -

ON_MESSAGE3( API, shopHelp, msg )
{
	if ( msg.succeed )
	{
		STATUS * status = msg.GET_OUTPUT( @"status" );
		if ( NO == status.succeed.boolValue )
		{
			msg.failed = YES;
			return;
		}

		[self.articleGroups removeAllObjects];
		[self.articleGroups addObjectsFromArray:msg.GET_OUTPUT(@"data")];

		self.loaded = YES;
		
		[self saveCache];
	}
}

@end
