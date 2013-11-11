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
	
#import "PayBoard_iPhone.h"
#import "AppBoard_iPhone.h"

#pragma mark -

@implementation PayBoard_iPhone

- (void)load
{
    [super load];
    
    self.isFromCheckoutBoard = NO;
    
    self.orderModel = [[[OrderModel alloc] init] autorelease];
    [self.orderModel addObserver:self];
}

- (void)unload
{
    [self.orderModel removeObserver:self];
    self.orderModel = nil;
    [super unload];
}

#pragma mark -

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        self.titleString = __TEXT(@"pay");
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
        
        if ( self.orderID )
        {
            ORDER * order = [[[ORDER alloc] init] autorelease];
            order.order_id = self.orderID;
            [self.orderModel pay:order];
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

ON_SIGNAL2( BeeUINavigationBar, signal )
{
	[super handleUISignal:signal];
    
	if ( [signal is:BeeUINavigationBar.LEFT_TOUCHED] )
	{
        if ( self.isFromCheckoutBoard )
        {
            if ( self.previousBoard.previousBoard.previousBoard )
            {
                [self.stack popToBoard:self.previousBoard.previousBoard.previousBoard animated:YES];
            }
            else
            {
                [self.stack popBoardAnimated:YES];
            }
        }
        else
        {
            [self.stack popBoardAnimated:YES];
        }
	}
}

- (void)handleMessage:(BeeMessage *)msg
{
//    if ( msg.sending )
//    {
//        [self presentLoadingTips:__TEXT(@"tips_loading")];
//    }
//    else
//    {
//        [self dismissTips];
//    }
    
    if ( [msg is:API.order_pay] )
    {
        if ( msg.succeed )
        {
            self.htmlString = self.orderModel.html;
            [self refresh];
        }
        else if ( msg.failed )
        {
			[ErrorMsg presentErrorMsg:msg inBoard:self];
        }
    }
}

@end
