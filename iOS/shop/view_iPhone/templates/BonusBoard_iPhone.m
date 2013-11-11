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

#import "BonusBoard_iPhone.h"
#import "CheckoutBoard_iPhone.h"
#import "AppBoard_iPhone.h"

#pragma mark -

@interface BonusBoard_iPhone()
{
    FormElement * _input;
}
@end

@implementation BonusBoard_iPhone


- (void)load
{
    [super load];
    
    self.datas = [[[NSMutableArray alloc] init] autorelease];
    
    _input = [FormElement input];
    _input.keyboardType = UIKeyboardTypeNumberPad;
    
    [self.datas addObject:@[ _input ]];
    
    self.validateModel = [[[ValidateModel alloc] init] autorelease];
    [self.validateModel addObserver:self];
}

- (void)unload
{
    self.datas = nil;
    
    [self.validateModel removeObserver:self];
    self.validateModel = nil;
}

#pragma mark -

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        self.titleString = __TEXT(@"redpaper");
        [self showNavigationBarAnimated:NO];
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
	}
    else if ( [signal is:BeeUIBoard.DID_APPEAR] )
    {
        _input.placeholder = [NSString stringWithFormat:__TEXT(@"remain_redpacks"), self.allow_use_bonus.integerValue];
        [_input.view becomeFirstResponder];
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
//    if ( _input.text.integerValue <= self.allow_use_bonus.integerValue )
    {
        CheckoutBoard_iPhone * board = (CheckoutBoard_iPhone *)self.previousBoard;
        board.flowModel.done_bonus = _input.text;
        
        self.validateModel.bonus = board.flowModel.done_bonus;
        [self.validateModel validateBonus];
    }
}

@end
