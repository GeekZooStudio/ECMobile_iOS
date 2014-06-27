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
	
#import "F2_EditAddressBoard_iPhone.h"
#import "F3_RegionPickBoard_iPhone.h"
#import "AppBoard_iPhone.h"
#import "F2_EditAddressCell_iPhone.h"

#pragma mark -

@implementation F2_EditAddressBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( BeeUIScrollView,	list )

DEF_MODEL( AddressListModel,	addressListModel )
DEF_MODEL( RegionModel,			regionModel );

DEF_SIGNAL( DELETE_CONFIRM )

- (void)load
{
    self.addressListModel = [AddressListModel modelWithObserver:self];
	self.regionModel = [RegionModel modelWithObserver:self];
}

- (void)unload
{
	SAFE_RELEASE_MODEL( self.addressListModel );
	SAFE_RELEASE_MODEL( self.regionModel );
}

#pragma mark -

ON_CREATE_VIEWS(signal)
{
    self.navigationBarTitle = __TEXT(@"modify_address");
    
    [self showNavigationBarAnimated:NO];
    [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav_back.png"]];
    [self showBarButton:BeeUINavigationBar.RIGHT title:__TEXT(@"save") image:[UIImage imageNamed:@"nav_right.png"]];
    
    @weakify(self);
    
    self.list.lineCount = 1;
    self.list.animationDuration = 0.25f;
    
    self.list.whenReloading = ^
    {
        @normalize(self);
        
        self.list.total = 1;
        
        BeeUIScrollItem * item = self.list.items[0];
        item.clazz = [F2_EditAddressCell_iPhone class];
        item.data = self.address;
        item.size = self.list.size; 
        item.rule = BeeUIScrollLayoutRule_Tile;
    };
    
    [self observeNotification:BeeUIKeyboard.HIDDEN];
    [self observeNotification:BeeUIKeyboard.SHOWN];
    [self observeNotification:BeeUIKeyboard.HEIGHT_CHANGED];
}

ON_DELETE_VIEWS(signal)
{
    [self unobserveNotification:BeeUIKeyboard.HIDDEN];
    [self unobserveNotification:BeeUIKeyboard.HEIGHT_CHANGED];
    [self unobserveNotification:BeeUIKeyboard.SHOWN];
    
    self.list = nil;
}

ON_WILL_APPEAR(signal)
{

    [self.list reloadData];
    [bee.ui.appBoard hideTabbar];
}

ON_LEFT_BUTTON_TOUCHED(signal)
{
    [self.stack popBoardAnimated:YES];
}

ON_RIGHT_BUTTON_TOUCHED(signal)
{
    if ( [self checked] )
    {
        [self.view endEditing:YES];
        
        [self.addressListModel update:self.address];
    }
}

#pragma mark - BeeUITextField

ON_SIGNAL3( BeeUITextField, RETURN, signal )
{
    F2_EditAddressCell_iPhone * item = (F2_EditAddressCell_iPhone *)signal.sourceCell;
    BeeUITextField * input = (BeeUITextField *)signal.source;
    
    if( $(item).FIND(@"#name").focusing )
    {
        $(item).FIND(@"#tel").FOCUS();
        return;
    }
    else if( $(item).FIND(@"#tel").focusing )
    {
        $(item).FIND(@"#email").FOCUS();
        return;
    }
    else if ( $(item).FIND(@"#email").focusing )
    {
        $(item).FIND(@"#zipcode").FOCUS();
        return;
    }
    else if ( $(item).FIND(@"#zipcode").focusing )
    {
        $(item).FIND(@"#address").FOCUS();
        return;
    }
    else if ( UIReturnKeyDone == input.returnKeyType )
    {
        [self.view endEditing:YES];
    }
}

#pragma mark - F2_EditAddressCell_iPhone

/**
 * 收货地址管理-修改收货地址-所在区域，点击事件触发时执行的操作
 */
ON_SIGNAL3( F2_EditAddressCell_iPhone, location, signal )
{
	self.regionModel.parent_id = @(0);
	[self.regionModel reload];
}

/**
 * 收货地址管理-修改收货地址-设为默认，点击事件触发时执行的操作
 */
ON_SIGNAL3( F2_EditAddressCell_iPhone, setdefault, signal )
{
    if ( [self checked] )
    {
		[self.view endEditing:YES];

		[self.addressListModel setDefault:self.address];
    }
}

/**
 * 收货地址管理-修改收货地址-删除地址，点击事件触发时执行的操作
 */
ON_SIGNAL3( F2_EditAddressCell_iPhone, delete, signal )
{
    if ( [self.address.default_address boolValue] )
    {
        [self presentFailureTips:__TEXT(@"can_not_delete")];
        return;
    }
    else
    {
        BeeUIAlertView * alert = [BeeUIAlertView spawn];
        alert.title = @"是否删除地址?";
        [alert addButtonTitle:@"确定" signal:self.DELETE_CONFIRM];
        [alert addCancelTitle:@"取消"];
        [alert showInViewController:self];
    }
}

/**
 * 收货地址管理-修改收货地址-删除地址，确认删除地址事件触发时执行的操作
 */
ON_SIGNAL3( F2_EditAddressBoard_iPhone, DELETE_CONFIRM, signal )
{
    [self.addressListModel remove:self.address];
}

#pragma mark -

ON_NOTIFICATION3( BeeUIKeyboard, SHOWN, notification )
{
    CGFloat keyboardHeight = [BeeUIKeyboard sharedInstance].height;

    [self.list setBaseInsets:UIEdgeInsetsMake( 0, 0, keyboardHeight, 0)];
}

ON_NOTIFICATION3( BeeUIKeyboard, HEIGHT_CHANGED, notification )
{
    CGFloat keyboardHeight = [BeeUIKeyboard sharedInstance].height;
    
    [self.list setBaseInsets:UIEdgeInsetsMake( 0, 0, keyboardHeight, 0)];
}

ON_NOTIFICATION3( BeeUIKeyboard, HIDDEN, notification )
{
    [self.list setBaseInsets:UIEdgeInsetsZero];
}

#pragma mark - 

- (void)setLocationText:(NSString *)text
{
    UIView * onlyChild = ((BeeUIScrollItem *)self.list.items[0]).view;
    $(onlyChild).FIND(@"#location-label").TEXT(text);
}

- (BOOL)checked
{
    UIView * item = ((BeeUIScrollItem *)self.list.items[0]).view;
    if ( nil == item )
		return NO;

    NSString * name = $(item).FIND(@"name").text;
    NSString * tel = $(item).FIND(@"tel").text;
    NSString * email = $(item).FIND(@"email").text;
    NSString * zipcode = $(item).FIND(@"zipcode").text;
    NSString * tempAddress = $(item).FIND(@"address").text;

	// 输入不正确显示光标
    if ( !( name && name.length ) )
    {
		$(item).FIND(@"#name").FOCUS();
        [self presentFailureTips:__TEXT(@"warn_no_recipient")];
        return NO;
    }
    
    if ( tel.length < 6 )
    {
		$(item).FIND(@"#tel").FOCUS();
        [self presentFailureTips:__TEXT(@"warn_no_mobile")];
        return NO;
    }
    
    if ( !( email && email.length && email.isEmail ) )
    {
		$(item).FIND(@"#email").FOCUS();
        [self presentFailureTips:__TEXT(@"warn_no_email")];
        return NO;
    }
    
	if ( !(zipcode && zipcode.length ) )
	{
		$(item).FIND(@"#zipcode").FOCUS();
		[self presentFailureTips:__TEXT(@"warn_no_zipcode")];
		return NO;
	}
	
    if ( !( tempAddress && tempAddress.length ) )
    {
		$(item).FIND(@"#address").FOCUS();
        [self presentFailureTips:__TEXT(@"warn_no_address")];
        return NO;
    }
    
    if ( !self.address.isRegionValid )
    {
        [self presentFailureTips:__TEXT(@"warn_no_region")];
        return NO;
    }
    
    self.address.tel = tel;
    self.address.email = email;
    self.address.zipcode = zipcode;
    self.address.consignee = name;
    self.address.address = tempAddress;
    self.address.city = self.address.city ? : @(0);
    self.address.country = self.address.country ? : @(0);
    self.address.province = self.address.province ? : @(0);
    self.address.district = self.address.district ? : @(0);
    
    return YES;
}

#pragma mark - 

ON_MESSAGE3( API, region, msg )
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
		STATUS * status = msg.GET_OUTPUT( @"status" );
		
		if ( status.succeed.boolValue )
		{
			@weakify(self);
				
			F3_RegionPickBoard_iPhone * board = [[[F3_RegionPickBoard_iPhone alloc] init] autorelease];
			board.rootBoard = self;
			board.regions = self.regionModel.regions;
			
			board.whenRegionChanged = ^(ADDRESS * address)
			{
				@normalize(self);
				
				[self.address setRegionValueWithAddress:address];
				[self setLocationText:[address region]];
			};
			
			[self.stack pushBoard:board animated:YES];
		}
		else
		{
			[self showErrorTips:msg];
		}
	}
	else if ( msg.failed )
	{
		[self showErrorTips:msg];
	}
}

ON_MESSAGE3( API, address_add, msg )
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
		STATUS * status = msg.GET_OUTPUT( @"status" );
		
		if ( status.succeed.boolValue )
		{
			[self.stack popBoardAnimated:YES];
		}
		else
		{
			[self showErrorTips:msg];
		}
	}
	else if ( msg.failed )
	{
		[self showErrorTips:msg];
	}
}

ON_MESSAGE3( API, address_delete, msg )
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
		STATUS * status = msg.GET_OUTPUT( @"status" );
		
		if ( status.succeed.boolValue )
		{
			[self.stack popBoardAnimated:YES];
		}
		else
		{
			[self showErrorTips:msg];
		}
	}
	else if ( msg.failed )
	{
		[self showErrorTips:msg];
	}
}

ON_MESSAGE3( API, address_update, msg )
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
		STATUS * status = msg.GET_OUTPUT( @"status" );
		
		if ( status.succeed.boolValue )
		{
            [self.view.window presentSuccessTips:__TEXT(@"address_updated")];

            [self.stack popBoardAnimated:YES];
		}
		else
		{
			[self showErrorTips:msg];
		}
	}
	else if ( msg.failed )
	{
		[self showErrorTips:msg];
	}
}

ON_MESSAGE3( API, address_setDefault, msg )
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
		STATUS * status = msg.GET_OUTPUT( @"status" );
		
		if ( status.succeed.boolValue )
		{
            [self.view.window presentSuccessTips:__TEXT(@"address_selected")];
			
            [self.stack popBoardAnimated:YES];
		}
		else
		{
			[self showErrorTips:msg];
		}
	}
	else if ( msg.failed )
	{
		[self showErrorTips:msg];
	}
}

@end
