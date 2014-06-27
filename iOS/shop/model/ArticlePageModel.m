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

#import "ArticlePageModel.h"

#pragma mark -

@implementation ArticlePageModel

@synthesize article_id = _article_id;
@synthesize article_title = _article_title;
@synthesize html = _html;

- (void)load
{
}

- (void)unload
{
	self.html = nil;
	self.article_id = nil;
	self.article_title = nil;
}

#pragma mark -

- (void)reload
{
	self.CANCEL_MSG( API.article );
	self.MSG( API.article ).INPUT( @"article_id", self.article_id );
}

#pragma mark -

ON_MESSAGE3( API, article, msg )
{
	if ( msg.succeed )
	{
		STATUS * status = msg.GET_OUTPUT( @"status" );
		if ( NO == status.succeed.boolValue )
		{
			msg.failed = YES;
			return;
		}

		self.html = msg.GET_OUTPUT( @"data" );
		self.loaded = YES;
		
		[self saveCache];
	}
}

@end
