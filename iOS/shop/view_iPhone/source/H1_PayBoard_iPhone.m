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
	
#import "H1_PayBoard_iPhone.h"
#import "E0_ProfileBoard_iPhone.h"
#import "E1_PendingPaymentBoard_iPhone.h"
#import "E2_PendingShippedBoard_iPhone.h"

#pragma mark -

@implementation H1_PayBoard_iPhone

- (void)load
{
	self.orderModel = [[[OrderModel alloc] init] autorelease];
	[self.orderModel addObserver:self];
}

- (void)unload
{
	[self.orderModel removeObserver:self];
	self.orderModel = nil;
}

#pragma mark -

ON_CREATE_VIEWS( signal )
{
	self.navigationBarTitle		= __TEXT(@"pay");
	self.navigationBarLeft  = [UIImage imageNamed:@"nav_back.png"];
}

ON_WILL_APPEAR( signal )
{
	[bee.ui.appBoard hideTabbar];

	if ( self.orderID )
	{
		ORDER * order	 = [[[ORDER alloc] init] autorelease];
		order.order_id	 = self.orderID;
		order.order_info = self.order_info;

		[self.orderModel pay:order];
	}
}

ON_DID_APPEAR( signal )
{
    if ( self.firstEnter )
    {
        [self refresh];
        
        self.firstEnter = NO;
    }
}

ON_WILL_DISAPPEAR( signal )
{
}

ON_DID_DISAPPEAR( signal )
{
    
}

ON_LEFT_BUTTON_TOUCHED(signal)
{
    
}

#pragma mark -

ON_MESSAGE3( API, order_pay, msg )
{
	if ( msg.succeed )
	{
		if ( msg.GET_OUTPUT( @"pay_wap" ) == nil )
		{
			self.htmlString = msg.GET_OUTPUT( @"pay_online" );
		}
		else
		{
			self.urlString = msg.GET_OUTPUT( @"pay_wap" );
		}

		[self refresh];
	}
	else if ( msg.failed )
	{
		[self showErrorTips:msg];
	}
}

ON_SIGNAL3( BeeUIWebView, DID_START, signal )
{
	// 根据callBackURL判断支付状态
	if ( [self.webView.loadingURL hasPrefix:self.wapCallBackURL] )
	{
		NSArray * callBackArray = [self.webView.loadingURL componentsSeparatedByString:@"err="];
		NSString * status 		= [callBackArray[1] substringToIndex:1];

		if ( [status intValue] == 0 )
		{
			// 支付成功
			[self didPaySuccess];
		}
		else if ( [status intValue] == 1 )
		{
			// 支付失败
			[self didPayFail];
		}
		else if ( [status intValue] == 2 )
		{
			// 中断支付
			[self didPayFail];
		}
	}
}

- (void)didPaySuccess
{
	[self.stack popToRootViewControllerAnimated:NO];
	[bee.ui.tabbar selectUser];
	[bee.ui.router open:AppBoard_iPhone.TAB_USER animated:NO];
	[bee.ui.profile.stack pushBoard:[E2_PendingShippedBoard_iPhone board] animated:NO];

	[self.view.window presentSuccessTips:__TEXT( @"pay_succeed" )];
}

- (void)didPayFail
{
	[self.stack popToRootViewControllerAnimated:NO];
	[bee.ui.tabbar selectUser];
	[bee.ui.router open:AppBoard_iPhone.TAB_USER animated:NO];
	[bee.ui.profile.stack pushBoard:[E1_PendingPaymentBoard_iPhone board] animated:NO];

	[self.view.window presentSuccessTips:__TEXT( @"pay_failed" )];
}
@end
