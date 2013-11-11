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
	
#import "GoodsEntryBoard_iPhone.h"
#import "ErrorMsg.h"

#pragma mark -

@implementation GoodsEntryBoard_iPhone

- (void)load
{
	[super load];
	
	self.model = [[[GoodsModel alloc] init] autorelease];
	[self.model addObserver:self];
}

- (void)unload
{
	[self.model removeObserver:self];
	self.model = nil;
	
	[super unload];
}

#pragma mark -

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        [self showNavigationBarAnimated:YES];
        
        self.titleString = __TEXT(@"gooddetail_product");
        self.isToolbarHiden = YES;
        self.webView.scalesPageToFit = YES;
        
        [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav-back.png"]];
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
        [self.model desc];
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
    if ( [msg is:API.goods_desc] )
    {
//        if ( msg.sending )
//        {
//            [self presentLoadingTips:__TEXT(@"tips_loading")];
//        }
//        else
//        {
//            [self dismissTips];
//        }
        
        if ( msg.succeed )
        {
            self.htmlString = self.model.goods_desc;
            [self refresh];
        }
        else if ( msg.failed )
        {
//            [self presentFailureTips:@"加载失败,请稍后再试"];
			[ErrorMsg presentErrorMsg:msg inBoard:self];
        }
            
    }
}

@end
