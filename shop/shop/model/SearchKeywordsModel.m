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

#import "SearchKeywordsModel.h"

#pragma mark -

@implementation SearchKeywordsModel

DEF_SINGLETON( SearchKeywordsModel )

@synthesize keywords = _keywords;

- (void)load
{
	self.keywords = [NSMutableArray array];
	
	[self loadCache];
}

- (void)unload
{
	[self saveCache];

	self.keywords = nil;
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
	self.keywords = nil;
	self.loaded = NO;
}

#pragma mark -

- (void)reload
{
	self.CANCEL_MSG( API.searchKeywords );
	self.MSG( API.searchKeywords );
}

#pragma mark -

ON_MESSAGE3( api, searchKeywords, msg )
{
	if ( msg.succeed )
	{
		STATUS * status = msg.GET_OUTPUT( @"status" );
		if ( NO == status.succeed.boolValue )
		{
			msg.failed = YES;
			return;
		}

		self.keywords = [NSMutableArray arrayWithArray:msg.GET_OUTPUT(@"data")];
		self.loaded = YES;
		
		[self saveCache];
	}
}

@end
