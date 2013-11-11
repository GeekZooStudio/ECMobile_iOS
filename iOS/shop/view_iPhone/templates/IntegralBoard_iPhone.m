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

#import "IntegralBoard_iPhone.h"
#import "CheckoutBoard_iPhone.h"
#import "AppBoard_iPhone.h"

#pragma mark -

@implementation IntegralBoard_iPhone

SUPPORT_RESOURCE_LOADING( YES )

- (void)load
{
    [super load];
  
    self.validateModel = [[[ValidateModel alloc] init] autorelease];
    [self.validateModel addObserver:self];
}

- (void)unload
{    
    [self.validateModel removeObserver:self];
    self.validateModel = nil;
}

#pragma mark -

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        self.titleString = __TEXT(@"balance_exp");
        [self showNavigationBarAnimated:NO];

        [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav-back.png"]];
        [self showBarButton:BeeUINavigationBar.RIGHT title:__TEXT(@"save") image:[UIImage imageNamed:@"nav-right.png"]];
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
	}
	else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{
        self.view.RELAYOUT();
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
	}
    else if ( [signal is:BeeUIBoard.DID_APPEAR] )
    {
        NSInteger integral = MIN( self.order_max_integral.integerValue, self.your_integral.integerValue );
        
        NSString * string =  [NSString stringWithFormat:@"%@ %d", __TEXT(@"avail_exp"), integral];

        $(@"#info").TEXT(string);
        $(@"#input").FOCUS();
    }
}

ON_SIGNAL2( BeeUINavigationBar, signal )
{
	[super handleUISignal:signal];

	if ( [signal is:BeeUINavigationBar.LEFT_TOUCHED] )
	{
        [self.stack popBoardAnimated:YES];
	}
	else if ( [signal is:BeeUINavigationBar.RIGHT_TOUCHED] )
	{
        [self checkin];
	}
}

ON_SIGNAL2( BeeUITextField, signal )
{
	[super handleUISignal:signal];
    
    if ( [signal is:BeeUITextField.RETURN] )
    {
        [self.view endEditing:YES];
    }
}

- (void)checkin
{
    NSInteger usedIntegral = $(@"#input").text.integerValue;
    
    if ( usedIntegral <= self.order_max_integral.integerValue )
    {
        CheckoutBoard_iPhone * board = (CheckoutBoard_iPhone *)self.previousBoard;
        board.flowModel.done_integral = @(usedIntegral);
        self.validateModel.integral = board.flowModel.done_integral;
        [self.validateModel validateIntegral];
    }
    else
    {
        [self presentFailureTips:__TEXT(@"warn_wrong_exp")];
    }
}

- (void)handleMessage:(BeeMessage *)msg
{
    if ( [msg is:API.validate_integral] )
    {
        if ( msg.sending )
        {
            [self presentLoadingTips:__TEXT(@"tips_verifying")];
        }
        else
        {
            [self dismissTips];
        }
        
        if ( msg.succeed )
        {
            CheckoutBoard_iPhone * board = (CheckoutBoard_iPhone *)self.previousBoard;
            board.flowModel.done_integral = @($(@"#input").text.integerValue);
            board.flowModel.data_integral = self.validateModel.data_integral;
            board.flowModel.data_integral_formated = self.validateModel.data_integral_formated;
            [self.stack popBoardAnimated:YES];
        }
        else if ( msg.failed )
        {
//            [self presentFailureTips:@"验证失败"];
			[ErrorMsg presentErrorMsg:msg inBoard:self];
        }
    }
}


@end
