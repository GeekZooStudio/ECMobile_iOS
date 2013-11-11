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
	
#import "ShareBoard_iPhone.h"
#import "GoodsDetailBoard_iPhone.h"
#import "AppBoard_iPhone.h"
#import "ErrorMsg.h"

#pragma mark -

@implementation ShareBoard_iPhone

DEF_SIGNAL( SHARE_TO_SINA )
DEF_SIGNAL( SHARE_TO_TENCENT )
DEF_SIGNAL( SHARE_TO_WEIXIN_FRIEND )
DEF_SIGNAL( SHARE_TO_WEIXIN_TIMELINE )

DEF_INT( PLATFORM_SINA,     0 );
DEF_INT( PLATFORM_TENCENT,  1 );

- (void)load
{
    [super load];
    
    [[ConfigModel sharedInstance] addObserver:self];
}

- (void)unload
{
    [[ConfigModel sharedInstance] removeObserver:self];
    
    [super unload];
}

#pragma mark -

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
        
        [[ConfigModel sharedInstance] update];
        
        if ( self.platform == self.PLATFORM_SINA )
        {
            self.titleString = __TEXT(@"share_sina");
        }
        else if ( self.platform == self.PLATFORM_TENCENT )
        {
            self.titleString = __TEXT(@"share_tencent");
        }
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

- (NSString *)shareUrl:(NSUInteger)platform
{
    NSString * url = nil;
    
    GoodsDetailBoard_iPhone * board = (GoodsDetailBoard_iPhone *)self.previousBoard;
    
    if ( platform == self.PLATFORM_SINA )
    {
		NSString * baseURL = [ConfigModel sharedInstance].config.goods_url;

		NSString * goodsUrl = [NSString stringWithFormat:@"%@%@", baseURL, board.goodsModel.goods.id];
		NSString * goodsTitle = __TEXT(@"share_blog");
		NSString * goodsSource = @"geek-zoo.com";

		goodsUrl = [goodsUrl URLEncoding];
		goodsTitle = [goodsTitle URLEncoding];
		goodsSource = [goodsSource URLEncoding];
		
		url = [NSString stringWithFormat:@"http://v.t.sina.com.cn/share/share.php?title=%@&url=%@&source=%@", goodsTitle, goodsUrl, goodsSource];
    }
    else if ( platform == self.PLATFORM_TENCENT )
    {
		url = @"http://www.ecmobile.me";
    }

	INFO( @"url = %@", url );
    return url;
}

- (void)handleMessage:(BeeMessage *)msg
{
    if ( [msg is:API.config] )
    {
        if ( msg.sending )
        {
            [self presentLoadingTips:__TEXT(@"tips_loading")];
        }
		else
		{
			[self dismissTips];
		}
		
		if ( msg.succeed )
        {
            self.urlString = [self shareUrl:self.platform];
            [self refresh];
        }
        else if ( msg.failed )
        {
			[ErrorMsg presentErrorMsg:msg inBoard:self];
        }
    }
}

@end
