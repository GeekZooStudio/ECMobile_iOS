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
//  Powered by BeeFramework
//
	
#import "G3_HelpEntryBoard_iPhone.h"
#import "AppBoard_iPhone.h"

#pragma mark -

@implementation G3_HelpEntryBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_MODEL( ArticlePageModel, articlePageModel )

- (void)load
{
	self.articlePageModel = [ArticlePageModel modelWithObserver:self];
    self.isToolbarHiden = YES;
}

- (void)unload
{
	SAFE_RELEASE_MODEL( self.articlePageModel );
}

#pragma mark -

ON_CREATE_VIEWS( signal )
{
    self.navigationBarShown = YES;
    self.navigationBarLeft  = [UIImage imageNamed:@"nav_back.png"];
}

ON_DELETE_VIEWS( signal )
{
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
    [bee.ui.appBoard hideTabbar];
    
    self.navigationBarTitle = self.articlePageModel.article_title;
    [self.articlePageModel reload];
}

ON_DID_APPEAR( signal )
{
}

ON_WILL_DISAPPEAR( signal )
{
}

ON_DID_DISAPPEAR( signal )
{
}

ON_LEFT_BUTTON_TOUCHED(signal)
{
//    [self.stack popBoardAnimated:YES];
}

#pragma mark -

ON_MESSAGE3( API, article, msg )
{
	if ( msg.succeed )
	{
		if ( self.articlePageModel.html && self.articlePageModel.html.length )
		{
			self.htmlString = self.articlePageModel.html;

//			[self refresh];
		}
		else
		{
			[self presentFailureTips:__TEXT(@"no_data")];
		}
	}
	else if ( msg.failed )
	{
		[self showErrorTips:msg];
	}
}

@end
