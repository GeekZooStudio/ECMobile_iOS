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
//	Powered by BeeFramework
//

#import "AppBoard_iPhone.h"
#import "B0_IndexBoard_iPhone.h"
#import "D0_SearchBoard_iPhone.h"
#import "C0_ShoppingCartBoard_iPhone.h"
#import "E0_ProfileBoard_iPhone.h"
#import "B1_ProductListBoard_iPhone.h"
#import "B3_ProductPhotoBoard_iPhone.h"
#import "B2_ProductDetailBoard_iPhone.h"
#import "B5_ProductCommentBoard_iPhone.h"
#import "C0_ShoppingCartBoard_iPhone.h"
#import "A0_SigninBoard_iPhone.h"
#import "A1_SignupBoard_iPhone.h"
#import "OrderCell_iPhone.h"
#import "F1_NewAddressBoard_iPhone.h"
#import "F0_AddressListBoard_iPhone.h"
#import "C1_CheckOutBoard_iPhone.h"
#import "H0_BrowserBoard_iPhone.h"

#import "UIViewController+ErrorTips.h"

#import "bee.services.alipay.h"
#import "bee.services.share.weixin.h"
#import "bee.services.share.sinaweibo.h"
#import "bee.services.share.tencentweibo.h"

#pragma mark -

#undef	TAB_HEIGHT
#define TAB_HEIGHT	44.0f

#pragma mark -

DEF_UI( AppBoard_iPhone, appBoard )

#pragma mark -

@implementation AppBoard_iPhone
{
    CGFloat _tabbarOriginY;
}

DEF_SINGLETON( AppBoard_iPhone )

DEF_SIGNAL( TAB_HOME )
DEF_SIGNAL( TAB_SEARCH )
DEF_SIGNAL( TAB_CART )
DEF_SIGNAL( TAB_USER )

DEF_SIGNAL( NOTIFY_FORWARD )
DEF_SIGNAL( NOTIFY_IGNORE )

DEF_MODEL( ConfigModel,	configModel )
DEF_MODEL( UserModel,	userModel )

#pragma mark -

- (void)load
{
	self.configModel = [ConfigModel modelWithObserver:self];
	self.userModel = [UserModel modelWithObserver:self];
}

- (void)unload
{
	SAFE_RELEASE_MODEL( self.configModel );
	SAFE_RELEASE_MODEL( self.userModel );
}

#pragma mark -

ON_SIGNAL2( BeeUIBoard, signal )
{
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        self.view.backgroundColor = [UIColor whiteColor];

		bee.ui.router[self.TAB_HOME]	= [B0_IndexBoard_iPhone class];
		bee.ui.router[self.TAB_SEARCH]	= [D0_SearchBoard_iPhone class];
		bee.ui.router[self.TAB_CART]	= [C0_ShoppingCartBoard_iPhone class];
		bee.ui.router[self.TAB_USER]	= [E0_ProfileBoard_iPhone sharedInstance];
		
		[self.view addSubview:bee.ui.router.view];
		[self.view addSubview:bee.ui.tabbar];

		[bee.ui.router open:self.TAB_HOME animated:YES];

		[self observeNotification:BeeUIRouter.STACK_DID_CHANGED];
		[self observeNotification:UserModel.LOGIN];
		[self observeNotification:UserModel.LOGOUT];
		[self observeNotification:UserModel.KICKOUT];
//		[self observeNotification:BeeNetworkReachability.WIFI_REACHABLE];
//		[self observeNotification:BeeNetworkReachability.WLAN_REACHABLE];
//		[self observeNotification:BeeNetworkReachability.UNREACHABLE];

        _tabbarOriginY = self.viewBound.size.height - TAB_HEIGHT + 1;
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
		[self unobserveAllNotifications];
	}
	else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{
		bee.ui.tabbar.frame = CGRectMake( 0, _tabbarOriginY, self.viewBound.size.width, TAB_HEIGHT );
		bee.ui.router.view.frame = CGRectMake( 0, 0, self.viewBound.size.width, self.viewBound.size.height );
	}
    else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
    {
    }
    else if ( [signal is:BeeUIBoard.FREE_DATAS] )
    {
    }
    else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
    {
    }
    else if ( [signal is:BeeUIBoard.DID_APPEAR] )
    {
		[self.configModel reload];
    }
    else if ( [signal is:BeeUIBoard.DID_APPEAR] )
    {
        [E0_ProfileBoard_iPhone sharedInstance];
    }
    else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
    {
    }
    else if ( [signal is:BeeUIBoard.DID_DISAPPEAR] )
    {
    }
    else if ( [signal is:BeeUIBoard.ORIENTATION_WILL_CHANGE] )
    {
		
    }
    else if ( [signal is:BeeUIBoard.ORIENTATION_DID_CHANGED] )
    {
    }
}

#pragma mark -

ON_SIGNAL3( AppBoard_iPhone, EXPIRE_TOUCHED, signal )
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.ecmobile.me"]];
}

#pragma mark -

ON_NOTIFICATION3( BeeNetworkReachability, WIFI_REACHABLE, notification )
{
	[self presentMessageTips:__TEXT(@"network_wifi")];
}

ON_NOTIFICATION3( BeeNetworkReachability, WLAN_REACHABLE, notification )
{
	[self presentMessageTips:__TEXT(@"network_wlan")];
}

ON_NOTIFICATION3( BeeNetworkReachability, UNREACHABLE, notification )
{
	[self presentMessageTips:__TEXT(@"network_unreachable")];
}

#pragma mark -

ON_SIGNAL3( AppTabbar_iPhone, home_button, signal )
{
	[bee.ui.tabbar selectHome];
	[bee.ui.router open:AppBoard_iPhone.TAB_HOME animated:NO];
}

ON_SIGNAL3( AppTabbar_iPhone, search_button, signal )
{
	[bee.ui.tabbar selectSearch];
	[bee.ui.router open:AppBoard_iPhone.TAB_SEARCH animated:NO];
}

ON_SIGNAL3( AppTabbar_iPhone, cart_button, signal )
{
	[bee.ui.tabbar selectCart];
	[bee.ui.router open:AppBoard_iPhone.TAB_CART animated:NO];
}

ON_SIGNAL3( AppTabbar_iPhone, user_button, signal )
{
	[bee.ui.tabbar selectUser];
	[bee.ui.router open:AppBoard_iPhone.TAB_USER animated:NO];
}

#pragma mark -

ON_NOTIFICATION3( UserModel, KICKOUT, n )
{
	[self showLogin];
	// 登录用户过期后，执行当前页面viewWillApper
	[bee.ui.router.currentBoard viewWillAppear:YES];
}

ON_NOTIFICATION3( UserModel, LOGOUT, n )
{
}

ON_NOTIFICATION3( UserModel, LOGIN, n )
{
}

#pragma mark -

- (void)showLogin
{
	if ( self.modalStack )
    {
		return;
    }

	[self presentModalStack:[BeeUIStack stackWithFirstBoard:[A0_SigninBoard_iPhone board]] animated:YES];
}

- (void)hideLogin
{
	if ( nil == self.modalStack )
	{
		return;
	}
	
	[self dismissModalStackAnimated:YES];
}

#pragma mark -

- (void)showTabbar
{
	_tabbarOriginY = self.view.height - TAB_HEIGHT + 1;
	
    CGRect tabbarFrame = bee.ui.tabbar.frame;
    tabbarFrame.origin.y = _tabbarOriginY;
	
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
    [UIView setAnimationDelay:0.2];
    [UIView setAnimationBeginsFromCurrentState:YES];
	
    bee.ui.tabbar.frame = tabbarFrame;
	
    [UIView commitAnimations];
}

- (void)hideTabbar
{
	_tabbarOriginY = self.view.height;

    CGRect tabbarFrame = bee.ui.tabbar.frame;
    tabbarFrame.origin.y = _tabbarOriginY;

    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
    [UIView setAnimationDelay:0.2];
    [UIView setAnimationBeginsFromCurrentState:YES];

    bee.ui.tabbar.frame = tabbarFrame;
	
    [UIView commitAnimations];
}

#pragma mark -

@end
