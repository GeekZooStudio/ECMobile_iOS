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
	
#import "AddAddressBoard_iPhone.h"
#import "WebViewBoard_iPhone.h"
#import "RegionPickBoard_iPhone.h"
#import "AppBoard_iPhone.h"

#pragma mark -

@interface AddAddressBoard_iPhone()
{
	BeeUIScrollView * _scroll;
}
@end

#pragma mark -

@implementation AddAddressBoard_iPhone

#pragma mark -

- (void)load
{
    [super load];
    
    self.shouldShowMessage = NO;
    
    
    self.addressModel = [[[AddressModel alloc] init] autorelease];
    [self.addressModel addObserver:self];
    
    [[RegionModel sharedInstance] addObserver:self];
}

- (void)unload
{
    [self.addressModel removeObserver:self];
    self.addressModel = nil;
    
    [[RegionModel sharedInstance] removeObserver:self];
}

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
		[self setTitleString:__TEXT(@"address_add")];
        [self showNavigationBarAnimated:NO];
        
        [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav-back.png"]];

		_scroll = [[BeeUIScrollView alloc] init];
        _scroll.FROM_RESOURCE(@"AddAddressCell_iPhone.xml");
		[self.view addSubview:_scroll];
        
        [[RegionModel sharedInstance] clearRegion];
        [[RegionModel sharedInstance] clearTempRegion];
        
        [self observeNotification:BeeUIKeyboard.HIDDEN];
        [self observeNotification:BeeUIKeyboard.HEIGHT_CHANGED];
        [self observeNotification:BeeUIKeyboard.SHOWN];
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
        [self unobserveNotification:BeeUIKeyboard.HIDDEN];
        [self unobserveNotification:BeeUIKeyboard.HEIGHT_CHANGED];
        [self unobserveNotification:BeeUIKeyboard.SHOWN];
        
		SAFE_RELEASE_SUBVIEW( _scroll );
	}
	else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{
		_scroll.frame = self.viewBound;
        _scroll.RELAYOUT();
	}
    else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
    {
		$(_scroll).FIND(@"email").DATA( [UserModel sharedInstance].user.email );
    }
    else if ( [signal is:BeeUIBoard.FREE_DATAS] )
    {
    }
    else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
    {
        NSString * region = [RegionModel sharedInstance].region;
        
        if ( [region notEmpty] )
        {
            $(_scroll).FIND(@"#location-label").TEXT( region );   
        }
        
        [RegionModel sharedInstance].level = 0;
		
		[[AppBoard_iPhone sharedInstance] setTabbarHidden:YES];
    }
    else if ( [signal is:BeeUIBoard.DID_APPEAR] )
    {
        if ( self.shouldShowMessage )
        {
            [self presentMessageTips:__TEXT(@"non_address")];
        }
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
        [self.stack popBoardAnimated:YES];
    }
    else if ( [signal is:BeeUINavigationBar.RIGHT_TOUCHED] )
    {
        [self.stack popBoardAnimated:YES];
    }
}

ON_SIGNAL2( BeeUITextField, signal )
{
	[super handleUISignal:signal];
   
    if ( [signal is:BeeUITextField.RETURN] )
    {
        NSArray * inputs = $(_scroll).FIND(@".input").views;
        
        BeeUITextField * input = (BeeUITextField *)signal.source;
        
        NSInteger index = [inputs indexOfObject:input];
        
        if ( UIReturnKeyNext == input.returnKeyType )
        {
            BeeUITextField * next = [inputs objectAtIndex:(index + 1)];
            [next becomeFirstResponder];
        }
        else if ( UIReturnKeyDone == input.returnKeyType )
        {            
            [self.view endEditing:YES];
        }
    }
}

ON_SIGNAL3( AddAddressCell_iPhone, location, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
        [RegionModel sharedInstance].parent_id = @(0);
        [[RegionModel sharedInstance] fetchFromServer];
    }
}

ON_SIGNAL3( AddAddressCell_iPhone, add, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
        [self doSave];
    }
}

- (void)handleNotification_BeeUIKeyboard_SHOWN:(NSNotification *)notification
{
    [super handleNotification:notification];
    
    CGFloat keyboardHeight = [BeeUIKeyboard sharedInstance].height;
    
    CGFloat offsetHeight = [BeeSystemInfo isPhoneRetina4] ? 140 : 60;
    
    [UIView animateWithDuration:0.35f animations:^{
        [_scroll setBaseInsets:UIEdgeInsetsMake(0, 0, keyboardHeight - offsetHeight, 0)];
    }];
}

- (void)handleNotification_BeeUIKeyboard_HEIGHT_CHANGED:(NSNotification *)notification
{
    [super handleNotification:notification];
    
    CGFloat keyboardHeight = [BeeUIKeyboard sharedInstance].height;
    
    CGFloat offsetHeight = [BeeSystemInfo isPhoneRetina4] ? 140 : 60;
    
    [UIView animateWithDuration:0.35f animations:^{
        [_scroll setBaseInsets:UIEdgeInsetsMake(0, 0, keyboardHeight - offsetHeight, 0)];
    }];
}

- (void)handleNotification_BeeUIKeyboard_HIDDEN:(NSNotification *)notification
{
    [super handleNotification:notification];
    
    [UIView animateWithDuration:0.35f animations:^{
        [_scroll setBaseInsets:UIEdgeInsetsZero];
    }];
}

- (void)doSave
{
    NSString * name = $(_scroll).FIND(@"name").text;
    NSString * tel = $(_scroll).FIND(@"tel").text;
    NSString * email = $(_scroll).FIND(@"email").text;
    NSString * zipcode = $(_scroll).FIND(@"zipcode").text;
    NSString * tempAddress = $(_scroll).FIND(@"address").text;
    
    if ( !( name && name.length ) )
    {
        [self presentFailureTips:__TEXT(@"warn_no_recipient")];
//        $(_scroll).FIND(@"name").FOCUS();
        return;
    }
    
    if ( !( tel && tel.length ) )
    {
        [self presentFailureTips:__TEXT(@"warn_no_mobile")];
//        $(_scroll).FIND(@"tel").FOCUS();
        return;
    }
    
    if ( !( email && email.length && email.isEmail ) )
    {
        [self presentFailureTips:__TEXT(@"warn_no_email")];
//        $(_scroll).FIND(@"email").FOCUS();
        return;
    }
    
    if ( !( tempAddress && tempAddress.length ) )
    {
        [self presentFailureTips:__TEXT(@"warn_no_address")];
//        $(_scroll).FIND(@"address").FOCUS();
        return;
    }
    
    if ( ![RegionModel sharedInstance].isValid )
    {
        [self presentFailureTips:__TEXT(@"warn_no_region")];
        return;
    }
    
    ADDRESS * address = [[[ADDRESS alloc] init] autorelease];
    address.tel = tel;
    address.email = email;
    address.zipcode = zipcode;
    address.consignee = name;
    address.address = tempAddress;
    address.city = [RegionModel sharedInstance].address.city;
    address.country = [RegionModel sharedInstance].address.country;
    address.province = [RegionModel sharedInstance].address.province;
    address.district = [RegionModel sharedInstance].address.district;
    
    [self.addressModel add:address];
}

- (void)handleMessage:(BeeMessage *)msg
{
    if ( msg.sending )
    {
        [self presentLoadingTips:__TEXT(@"tips_loading")];
    }
    else
    {
        [self dismissTips];
    }
    
    if ( [msg is:API.region] )
    {
		if ( msg.succeed )
        {
            if ( ((STATUS *)msg.GET_OUTPUT(@"status")).succeed.boolValue )
            {
                RegionPickBoard_iPhone * board = [[[RegionPickBoard_iPhone alloc] init] autorelease];
                board.rootBoard = self;
                board.regions = [RegionModel sharedInstance].regions;
                [self.stack pushBoard:board animated:YES];
            }
        }
        else if ( msg.failed )
        {
            [self dismissTips];
            [ErrorMsg presentErrorMsg:msg inBoard:self];
            return;
        }
    }
    
    if ( [msg is:API.address_add] )
    {
        if ( msg.succeed )
        {
            if ( ((STATUS *)msg.GET_OUTPUT(@"status")).succeed.boolValue )
            {
                [self.stack popBoardAnimated:YES];
            }
        }
        else if ( msg.failed )
        {
            [self dismissTips];
            [ErrorMsg presentErrorMsg:msg inBoard:self];
            return;
        }
    }
    
}

@end
