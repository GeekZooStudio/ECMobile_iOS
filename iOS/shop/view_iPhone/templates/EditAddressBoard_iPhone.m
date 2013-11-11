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
	
#import "EditAddressBoard_iPhone.h"
#import "RegionPickBoard_iPhone.h"
#import "AppBoard_iPhone.h"

#pragma mark -

@implementation EditAddressCell_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

@end

#pragma mark -

@interface EditAddressBoard_iPhone()
{
    BeeUIScrollView * _scroll;
}
@end

@implementation EditAddressBoard_iPhone

#pragma mark -

- (void)load
{
    [super load];
        
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
	[super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        self.titleString = __TEXT(@"modify_address");
        
        [self showNavigationBarAnimated:NO];
        [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav-back.png"]];
        [self showBarButton:BeeUINavigationBar.RIGHT title:@"保存" image:[UIImage imageNamed:@"nav-right.png"]];
        
		_scroll = [[BeeUIScrollView alloc] init];
        _scroll.FROM_RESOURCE(@"EditAddressCell_iPhone.xml");
		[self.view addSubview:_scroll];
        
        [[RegionModel sharedInstance] clearTempRegion];
        [[RegionModel sharedInstance] clearRegion];
        
        [self observeNotification:BeeUIKeyboard.HIDDEN];
        [self observeNotification:BeeUIKeyboard.SHOWN];
        [self observeNotification:BeeUIKeyboard.HEIGHT_CHANGED];
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
    else if ( [signal is:BeeUIBoard.DID_APPEAR] )
    {
        if ( ![RegionModel sharedInstance].region.length )
        {
            [[RegionModel sharedInstance] setRegionFromAddress:self.address];
        }
        
        if ( [[RegionModel sharedInstance].region notEmpty] )
        {
            $(_scroll).FIND(@"#location-label").TEXT( [RegionModel sharedInstance].region );
        }
        
        $(_scroll).FIND(@"name").TEXT( self.address.consignee );
        $(_scroll).FIND(@"tel").TEXT( self.address.tel );
        $(_scroll).FIND(@"email").TEXT( self.address.email );
        $(_scroll).FIND(@"zipcode").TEXT( self.address.zipcode );
        $(_scroll).FIND(@"address").TEXT( self.address.address );
        
        [[RegionModel sharedInstance] clearTempRegion];
    }
    else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
    {
        [RegionModel sharedInstance].level = 0;
		[[AppBoard_iPhone sharedInstance] setTabbarHidden:YES];
    }
    else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
    {
    }
    else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
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
        if ( [self checked] )
        {
            [self.addressModel update:self.address];
        }
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

ON_SIGNAL3( EditAddressCell_iPhone, location, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
        [RegionModel sharedInstance].parent_id = @(0);
        [[RegionModel sharedInstance] fetchFromServer];
    }
}

ON_SIGNAL3( EditAddressCell_iPhone, setdefault, signal )
{
    if ( [self checked] )
    {
        [self.addressModel setDefault:self.address];
    }
}

ON_SIGNAL3( EditAddressCell_iPhone, delete, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
        [self.addressModel remove:self.address];
    }
}

- (void)handleNotification_BeeUIKeyboard_SHOWN:(NSNotification *)notification
{
    [super handleNotification:notification];
    
    CGFloat keyboardHeight = [BeeUIKeyboard sharedInstance].height;
    
    CGFloat offsetHeight = [BeeSystemInfo isPhoneRetina4] ? 170 : 60;
    
    [UIView animateWithDuration:0.35f animations:^{
        [_scroll setBaseInsets:UIEdgeInsetsMake(0, 0, keyboardHeight - offsetHeight, 0)];
    }];
}

- (void)handleNotification_BeeUIKeyboard_HEIGHT_CHANGED:(NSNotification *)notification
{
    [super handleNotification:notification];
    
    CGFloat keyboardHeight = [BeeUIKeyboard sharedInstance].height;
    
    CGFloat offsetHeight = [BeeSystemInfo isPhoneRetina4] ? 170 : 60;
    
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

- (BOOL)checked
{
    NSString * name = $(_scroll).FIND(@"name").text;
    NSString * tel = $(_scroll).FIND(@"tel").text;
    NSString * email = $(_scroll).FIND(@"email").text;
    NSString * zipcode = $(_scroll).FIND(@"zipcode").text;
    NSString * tempAddress = $(_scroll).FIND(@"address").text;
    
    if ( !( name && name.length ) )
    {
        [self presentFailureTips:__TEXT(@"warn_no_recipient")];
        return NO;
    }
    
    if ( !( tel && tel.length ) )
    {
        [self presentFailureTips:__TEXT(@"warn_no_mobile")];
//        $(_scroll).FIND(@"tel").FOCUS();
        return NO;
    }
    
    if ( !( email && email.length && email.isEmail ) )
    {
        [self presentFailureTips:__TEXT(@"warn_no_email")];
//        $(_scroll).FIND(@"email").FOCUS();
        return NO;
    }
    
    if ( !( tempAddress && tempAddress.length ) )
    {
        [self presentFailureTips:__TEXT(@"warn_no_address")];
//        $(_scroll).FIND(@"address").FOCUS();
        return NO;
    }
    
    if ( ![RegionModel sharedInstance].isValid )
    {
        [self presentFailureTips:__TEXT(@"warn_no_region")];
        return NO;
    }
    
    self.address.tel = tel;
    self.address.email = email;
    self.address.zipcode = zipcode;
    self.address.consignee = name;
    self.address.address = tempAddress;
    self.address.city = [RegionModel sharedInstance].address.city ? : @(0);
    self.address.country = [RegionModel sharedInstance].address.country ? : @(0);
    self.address.province = [RegionModel sharedInstance].address.province ? : @(0);
    self.address.district = [RegionModel sharedInstance].address.district ? : @(0);
    
    [self.view endEditing:YES];
    
    return YES;
}

- (void)handleMessage:(BeeMessage *)msg
{
    if ( msg.sending )
    {
        [self presentLoadingTips:__TEXT(@"tips_loading")];
    }
    else if ( msg.failed )
    {
        [self dismissTips];
        [ErrorMsg presentErrorMsg:msg inBoard:self];
        return;
    }
    else
    {
        [self dismissTips];
    }
    
    if ( [msg is:API.region] )
    {
        if ( msg.succeed )
        {
            RegionPickBoard_iPhone * board = [[[RegionPickBoard_iPhone alloc] init] autorelease];
            board.rootBoard = self;
            board.regions = [RegionModel sharedInstance].regions;
            [self.stack pushBoard:board animated:YES];
        }
    }
    else if ( [msg is:API.address_add] )
    {
        if ( msg.succeed )
        {
            [self.stack popBoardAnimated:YES];
        }
    }
    else if ( [msg is:API.address_delete] )
    {
        if ( msg.succeed )
        {
            [self.stack popBoardAnimated:YES];
        }
    }    
    else if ( [msg is:API.address_update] )
    {
        if ( msg.succeed )
        {
            [self presentSuccessTips:__TEXT(@"address_updated")];
            [self.stack popBoardAnimated:YES];
        }
    }
    else if ( [msg is:API.address_setDefault] )
    {
        if ( msg.succeed )
        {
            [self presentSuccessTips:__TEXT(@"address_selected")];
            [self.stack popBoardAnimated:YES];
        }
    }
}

@end
