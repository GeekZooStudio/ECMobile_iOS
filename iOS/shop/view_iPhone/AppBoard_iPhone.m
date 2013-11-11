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

#import "AppBoard_iPhone.h"
#import "IndexBoard_iPhone.h"
#import "SearchBoard_iPhone.h"
#import "CartBoard_iPhone.h"
#import "ProfileBoard_iPhone.h"

//#import "SettingBoard_iPhone.h"
#import "GoodsListBoard_iPhone.h"
#import "SlideBoard_iPhone.h"
#import "GoodsDetailBoard_iPhone.h"
#import "GoodsCommentBoard_iPhone.h"
#import "CartBoard_iPhone.h"
#import "SigninBoard_iPhone.h"
#import "SignupBoard_iPhone.h"
#import "OrdersBoard_iPhone.h"
#import "AddAddressBoard_iPhone.h"
#import "AddressListBoard_iPhone.h"
#import "CheckoutBoard_iPhone.h"

#pragma mark -

#undef	TAB_HEIGHT
#define TAB_HEIGHT	44.0f

#pragma mark -

@interface AppBoard_iPhone()
{
    AppTab_iPhone * _tabbar;
    CGFloat         _tabbarOriginY;
	
	BeeUIButton *	_expiredView;
	BeeUIButton *	_shopClosedView;
}
@end

#pragma mark -

@implementation AppBoard_iPhone

DEF_SINGLETON( AppBoard_iPhone )

@synthesize tabbar = _tabbar;

DEF_SIGNAL( TAB_HOME )
DEF_SIGNAL( TAB_SEARCH )
DEF_SIGNAL( TAB_CART )
DEF_SIGNAL( TAB_USER )

#pragma mark -

- (void)load
{
	[UserModel sharedInstance];
	[CartModel sharedInstance];
}

- (void)unload
{
    [super unload];
}

#pragma mark -

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
		[[UIApplication sharedApplication] setStatusBarHidden:NO];

        [BeeUITipsCenter setDefaultContainerView:self.view];
        [BeeUITipsCenter setDefaultBubble:[UIImage imageNamed:@"alertBox.png"]];
		[BeeUITipsCenter setDefaultMessageIcon:[UIImage imageNamed:@"icon.png"]];
		[BeeUITipsCenter setDefaultSuccessIcon:[UIImage imageNamed:@"icon.png"]];
		[BeeUITipsCenter setDefaultFailureIcon:[UIImage imageNamed:@"icon.png"]];
		
		[BeeUINavigationBar setTitleColor:[UIColor whiteColor]];
		[BeeUINavigationBar setBackgroundColor:[UIColor blackColor]];
		
		if ( IOS7_OR_LATER )
		{
			[BeeUINavigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg_iphone5.png"]];
		}
		else
		{
			[BeeUINavigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg.png"]];
		}

        self.view.backgroundColor = [UIColor whiteColor];

		[[BeeUIRouter sharedInstance] map:self.TAB_HOME toClass:[IndexBoard_iPhone class]];
		[[BeeUIRouter sharedInstance] map:self.TAB_SEARCH toClass:[SearchBoard_iPhone class]];
		[[BeeUIRouter sharedInstance] map:self.TAB_CART toClass:[CartBoard_iPhone class]];
		[[BeeUIRouter sharedInstance] map:self.TAB_USER toClass:[ProfileBoard_iPhone class]];
        [self.view addSubview:[BeeUIRouter sharedInstance].view];
		
		_tabbar = [[AppTab_iPhone alloc] init];
		[_tabbar selectHome];
		[self.view addSubview:_tabbar];

        [[BeeUIRouter sharedInstance] open:self.TAB_HOME animated:YES];

		[self observeNotification:BeeUIRouter.STACK_DID_CHANGED];
		[self observeNotification:UserModel.LOGIN];
		[self observeNotification:UserModel.KICKOUT];
		[self observeNotification:CartModel.UPDATED];
		
		[self observeNotification:ConfigModel.SHOP_OPENED];
		[self observeNotification:ConfigModel.SHOP_CLOSED];
//		[self observeNotification:BeeNetworkReachability.WIFI_REACHABLE];
//		[self observeNotification:BeeNetworkReachability.WLAN_REACHABLE];
//		[self observeNotification:BeeNetworkReachability.UNREACHABLE];

        _tabbarOriginY = self.viewBound.size.height - TAB_HEIGHT + 1;
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
		[self unobserveAllNotifications];

		SAFE_RELEASE_SUBVIEW( _expiredView );
		SAFE_RELEASE_SUBVIEW( _shopClosedView );
		
        SAFE_RELEASE_SUBVIEW( _tabbar );
	}
	else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{
        _tabbar.frame = CGRectMake( 0, _tabbarOriginY, self.viewBound.size.width, TAB_HEIGHT );
        
        if ( IOS7_OR_LATER )
        {
            [BeeUIRouter sharedInstance].view.frame = self.view.frame;
        }
        else
        {
            [BeeUIRouter sharedInstance].view.frame = self.viewBound;
        }
	}
    else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
    {
    }
    else if ( [signal is:BeeUIBoard.FREE_DATAS] )
    {
    }
    else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
    {		
		[[ConfigModel sharedInstance] update];
    }
    else if ( [signal is:BeeUIBoard.DID_APPEAR] )
    {
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
    else if ( [signal is:BeeUIBoard.ORIENTATION_WILL_CHANGE] )
    {
		
    }
    else if ( [signal is:BeeUIBoard.ORIENTATION_DID_CHANGED] )
    {
    }
}

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

ON_SIGNAL2( mask, signal )
{
	NSURL * url = [NSURL URLWithString:@"http://www.ecmobile.me"];
	[[UIApplication sharedApplication] openURL:url];
}

ON_NOTIFICATION3( ConfigModel, SHOP_CLOSED, notification )
{
	if ( nil == _shopClosedView )
	{
		[self transitionFlip];

		_shopClosedView = [[BeeUIButton alloc] init];
		_shopClosedView.frame = [UIScreen mainScreen].bounds;
		
		if ( [BeeSystemInfo isPhoneRetina4] )
		{
			_shopClosedView.image = [UIImage imageNamed:@"closed-568h.jpg"];
		}
		else
		{
			_shopClosedView.image = [UIImage imageNamed:@"closed.jpg"];
		}

		[self.view addSubview:_shopClosedView];
	}
}

ON_NOTIFICATION3( ConfigModel, SHOP_OPENED, notification )
{
	if ( _shopClosedView )
	{
		[self transitionFlip];

		[_shopClosedView removeFromSuperview];
		[_shopClosedView release];
		_shopClosedView = nil;
	}
}

- (void)handleUISignal_tabbar_home_button:(BeeUISignal *)signal
{
	[super handleUISignal:signal];

    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
		[self.tabbar selectHome];
		
		[[BeeUIRouter sharedInstance] open:self.TAB_HOME animated:YES];
    }
}

- (void)handleUISignal_tabbar_search_button:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
	
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
		[self.tabbar selectSearch];
		
		[[BeeUIRouter sharedInstance] open:self.TAB_SEARCH animated:YES];
    }
}

- (void)handleUISignal_tabbar_cart_button:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
	
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
		[self.tabbar selectCart];
		
		[[BeeUIRouter sharedInstance] open:self.TAB_CART animated:YES];
    }
}

- (void)handleUISignal_tabbar_user_button:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
	
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
		[self.tabbar selectUser];
		
		[[BeeUIRouter sharedInstance] open:self.TAB_USER animated:YES];
    }
}

#pragma mark -

- (void)handleNotification:(NSNotification *)notification
{
    [super handleNotification:notification];
	
	if ( [notification is:UserModel.KICKOUT] )
	{
		[self showLogin];
	}
	else if ( [notification is:UserModel.LOGIN] )
	{
		[[CartModel sharedInstance] fetchFromServer];
	}
	else if ( [notification is:CartModel.UPDATED] )
	{
		NSUInteger count = 0;
		
		for ( CART_GOODS * goods in [CartModel sharedInstance].goods )
		{
			count += goods.goods_number.intValue;
		}

		_tabbar.data = __INT( count );
	}
}

#pragma mark -

- (void)showLogin
{
	if ( self.modalStack )
    {
		return;
    }
    
	[self presentModalStack:[BeeUIStack stackWithFirstBoard:[SigninBoard_iPhone sharedInstance]] animated:YES];
}

- (void)hideLogin
{
	if ( nil == self.modalStack )
		return;
	
	[self dismissModalStackAnimated:YES];
}

#pragma mark -

- (void)setTabbarHidden:(BOOL)hidden
{
    CGRect tabbarFrame = self.tabbar.frame;
    _tabbarOriginY = !hidden ? self.view.height - TAB_HEIGHT + 1 : self.view.height;
    tabbarFrame.origin.y = _tabbarOriginY;
    
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
    [UIView setAnimationDelay:0.2];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.tabbar.frame = tabbarFrame;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(stop)];
    [UIView commitAnimations];
}

- (void)stop
{
//    self.tabbar.hidden = hidden;
}

@end
