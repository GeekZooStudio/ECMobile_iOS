/*
 *                                                                          
 *       _/_/_/                      _/        _/_/_/_/_/                     
 *    _/          _/_/      _/_/    _/  _/          _/      _/_/      _/_/    
 *   _/  _/_/  _/_/_/_/  _/_/_/_/  _/_/          _/      _/    _/  _/    _/   
 *  _/    _/  _/        _/        _/  _/      _/        _/    _/  _/    _/    
 *   _/_/_/    _/_/_/    _/_/_/  _/    _/  _/_/_/_/_/    _/_/      _/_/       
 *                                                                          
 *
 *  Copyright 2013-2014, Geek Zoo Studio
 *  http://www.ecmobile.cn/license.html
 *
 *  HQ China:
 *    2319 Est.Tower Van Palace 
 *    No.2 Guandongdian South Street 
 *    Beijing , China
 *
 *  U.S. Office:
 *    One Park Place, Elmira College, NY, 14901, USA
 *
 *  QQ Group:   329673575
 *  BBS:        bbs.ecmobile.cn
 *  Fax:        +86-10-6561-5510
 *  Mail:       info@geek-zoo.com
 */
	
#import "HelpEntryBoard_iPhone.h"
#import "AppBoard_iPhone.h"
#import "ErrorMsg.h"

#pragma mark -

@implementation HelpEntryBoard_iPhone

#pragma mark -

- (void)load
{
    self.articleModel = [[[ArticleModel alloc] init] autorelease];
    [self.articleModel addObserver:self];
    self.isToolbarHiden = YES;
}

- (void)unload
{
    [self.articleModel removeObserver:self];
    self.articleModel = nil;
}

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
	}
	else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{
	}
    else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
    {
    }
    else if ( [signal is:BeeUIBoard.FREE_DATAS] )
    {
    }
    else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
    {
		[[AppBoard_iPhone sharedInstance] setTabbarHidden:YES];
		
		self.titleString = self.articleModel.article_title;
		[self.articleModel fetchFromServer];
    }
    else if ( [signal is:BeeUIBoard.DID_APPEAR] )
    {
    }
    else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
    {
    }
    else if ( [signal is:BeeUIBoard.DID_DISAPPEAR] )
    {
    }
}

- (void)handleMessage:(BeeMessage *)msg
{
	if ( [msg is:API.article] )
	{
//		if ( msg.sending )
//		{
//			[self presentLoadingTips:__TEXT(@"tips_loading")];
//		}
//		else
//		{
//			[self dismissTips];
//		}
		if ( msg.succeed )
		{
			if ( self.articleModel.html && self.articleModel.html.length )
			{
				self.htmlString = self.articleModel.html;
				[self refresh];
			}
			else
			{
				[self presentFailureTips:__TEXT(@"no_data")];
			}
		}
		else if ( msg.failed )
		{
			[ErrorMsg presentErrorMsg:msg inBoard:self];
		}
	}
}

@end
