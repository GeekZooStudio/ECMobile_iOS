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
	
#import "F1_NewAddressBoard_iPhone.h"
#import "H0_BrowserBoard_iPhone.h"
#import "F3_RegionPickBoard_iPhone.h"
#import "AppBoard_iPhone.h"
#import "F1_NewAddressCell_iPhone.h"

#pragma mark -

@implementation F1_NewAddressBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( BeeUIScrollView, list )

DEF_MODEL( AddressListModel,	addressListModel )
DEF_MODEL( RegionModel,			regionModel )

- (void)load
{
    self.shouldShowMessage = NO;
    
	self.addressListModel = [AddressListModel modelWithObserver:self];
    self.regionModel = [RegionModel modelWithObserver:self];
    
    self.address = [[[ADDRESS alloc] init] autorelease];
    self.address.email = [UserModel sharedInstance].user.email;
}

- (void)unload
{
    self.address = nil;
    
	SAFE_RELEASE_MODEL( self.addressListModel )
	SAFE_RELEASE_MODEL( self.regionModel )
}

ON_CREATE_VIEWS( signal )
{
//    [self setTitleString:__TEXT(@"address_add")];
//    [self showNavigationBarAnimated:NO];
    self.navigationBarShown = YES;
    self.navigationBarTitle = __TEXT(@"address_add");
    
    [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav_back.png"]];
    
    @weakify(self);
    
    self.list.lineCount = 1;
    self.list.animationDuration = 0.25f;
    
    self.list.whenReloading = ^
    {
        @normalize(self);
        
        self.list.total = 1;
        
        BeeUIScrollItem * item = self.list.items[0];
        item.clazz = [F1_NewAddressCell_iPhone class];
        item.size = self.list.size;
        item.data = self.address;
        item.rule = BeeUIScrollLayoutRule_Tile;
    };
    
    [self observeNotification:BeeUIKeyboard.HIDDEN];
    [self observeNotification:BeeUIKeyboard.HEIGHT_CHANGED];
    [self observeNotification:BeeUIKeyboard.SHOWN];
}

ON_DELETE_VIEWS( signal )
{
    [self unobserveNotification:BeeUIKeyboard.HIDDEN];
    [self unobserveNotification:BeeUIKeyboard.HEIGHT_CHANGED];
    [self unobserveNotification:BeeUIKeyboard.SHOWN];
    
    self.list = nil;
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
    [bee.ui.appBoard hideTabbar];
}

ON_DID_APPEAR( signal )
{
    if ( self.shouldShowMessage )
    {
        [self presentMessageTips:__TEXT(@"non_address")];
    }
    
	UIView * item = nil;

	if ( self.list.items.count )
	{
		item = ((BeeUIScrollItem *)self.list.items[0]).view;
	}

    [self.list reloadData];
    
    if ( nil == item )
		return;
    
    $(item).FIND(@"#location-label").TEXT( self.address.region );
    
    $(item).FIND(@"email").DATA( [UserModel sharedInstance].user.email );
}

ON_WILL_DISAPPEAR( signal )
{
}

ON_DID_DISAPPEAR( signal )
{
}

ON_LOAD_DATAS( signal )
{
}

#pragma mark -

ON_LEFT_BUTTON_TOUCHED( signal )
{
    [self.stack popBoardAnimated:YES];
}

#pragma mark - BeeUITextField

ON_SIGNAL3( BeeUITextField, RETURN, signal )
{
    F1_NewAddressCell_iPhone * item = (F1_NewAddressCell_iPhone *)signal.sourceCell;
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

#pragma mark - F1_NewAddressCell_iPhone

ON_SIGNAL3( F1_NewAddressCell_iPhone, location, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
		self.regionModel.parent_id = @(0);
		[self.regionModel reload];
    }
}

ON_SIGNAL3( F1_NewAddressCell_iPhone, add, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
        [self doSave];
    }
}

#pragma mark - BeeUIKeyboard

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

- (void)doSave
{
    UIView * item = ((BeeUIScrollItem *)self.list.items[0]).view;
    if ( nil == item )
		return;

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
        return;
    }
    
    if ( tel.length < 6 )
    {
		$(item).FIND(@"#tel").FOCUS();
        [self presentFailureTips:__TEXT(@"warn_no_mobile")];
        return;
    }
    
    if ( !( email && email.length && email.isEmail ) )
    {
		$(item).FIND(@"#email").FOCUS();
        [self presentFailureTips:__TEXT(@"warn_no_email")];
        return;
    }
    
	if ( !(zipcode && zipcode.length ) )
	{
		$(item).FIND(@"#zipcode").FOCUS();
		[self presentFailureTips:__TEXT(@"warn_no_zipcode")];
		return;
	}
	
    if ( !( tempAddress && tempAddress.length ) )
    {
		$(item).FIND(@"#address").FOCUS();
        [self presentFailureTips:__TEXT(@"warn_no_address")];
        return;
    }
    
    if ( !self.address.isRegionValid )
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
    address.city = self.address.city;
    address.country = self.address.country;
    address.province = self.address.province;
    address.district = self.address.district;

    [self.addressListModel add:address];
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

@end
