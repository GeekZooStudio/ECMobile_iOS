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

#import "E0_ProfileBoard_iPhone.h"
#import "E1_PendingPaymentBoard_iPhone.h"
#import "E1_PendingPaymentCellFooter_iPhone.h"
#import "E1_PendingPaymentCell_iPhone.h"
#import "E2_PendingShippedBoard_iPhone.h"

#import "AppBoard_iPhone.h"
#import "H1_PayBoard_iPhone.h"

#import "OrderCell_iPhone.h"

#import "CommonNoResultCell.h"
#import "CommonPullLoader.h"
#import "CommonFootLoader.h"

#pragma mark -

@implementation E1_PendingPaymentBoard_iPhone

SUPPORT_RESOURCE_LOADING( YES );
SUPPORT_AUTOMATIC_LAYOUT( YES );

DEF_OUTLET( BeeUIScrollView, list )

DEF_MODEL( OrderModel, orderModel )
DEF_MODEL( WXPayModel, wxpayModel )

DEF_SIGNAL( ORDER_CANCELED )
DEF_SIGNAL( PAY_SDK )
DEF_SIGNAL( PAY_WAP )
DEF_SIGNAL( INSTALLATION_APP )

- (void)load
{
    self.orderModel = [OrderModel modelWithObserver:self];
	self.orderModel.type = ORDER_LIST_AWAIT_PAY;
    self.wxpayModel = [WXPayModel modelWithObserver:self];
}

- (void)unload
{
	SAFE_RELEASE_MODEL( self.orderModel );
    SAFE_RELEASE_MODEL( self.wxpayModel );
}

#pragma mark -

ON_CREATE_VIEWS( signal )
{
    self.navigationBarTitle = __TEXT(@"await_pay");
    
    [self showNavigationBarAnimated:NO];
    [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav_back.png"]];

    @weakify(self);

    self.list.headerClass = [CommonPullLoader class];
    self.list.headerShown = YES;

    self.list.footerClass = [CommonFootLoader class];
//    self.list.footerShown = YES;

    self.list.lineCount = 1;
    self.list.animationDuration = 0.25f;

    self.list.whenReloading = ^
    {
        @normalize(self);

        self.list.total = self.orderModel.orders.count;
        
        if ( self.orderModel.loaded && 0 == self.orderModel.orders.count )
        {
            self.list.total = 1;
            
            BeeUIScrollItem * item = self.list.items[0];
            item.clazz = [CommonNoResultCell class];
            item.size = self.list.size;
            item.rule = BeeUIScrollLayoutRule_Tile;
        }
        else
        {
            for ( int i = 0; i < self.orderModel.orders.count; i++ )
            {
                BeeUIScrollItem * item = self.list.items[i];
                item.clazz = [E1_PendingPaymentCell_iPhone class];
                item.size = CGSizeAuto;
                item.data = [self.orderModel.orders safeObjectAtIndex:i];
                item.rule = BeeUIScrollLayoutRule_Tile;
            }
        }
    };
    self.list.whenHeaderRefresh = ^
    {
        @normalize(self);
        
        [self.orderModel firstPage];
    };
    self.list.whenFooterRefresh = ^
    {
        @normalize(self);
        
        [self.orderModel nextPage];
    };
    self.list.whenReachBottom = ^
    {
        @normalize(self);
        
        [self.orderModel nextPage];
    };
}

ON_DELETE_VIEWS( signal )
{
    [self unobserveAllNotifications];
    
    self.list = nil;
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
	[bee.ui.appBoard hideTabbar];

	if ( [UserModel online] )
	{
		[self.orderModel firstPage];
	}
	else
	{
		[bee.ui.appBoard showLogin];
	}

	[self.list reloadData];
}

ON_DID_APPEAR( signal )
{
}

ON_WILL_DISAPPEAR( signal )
{
}

ON_DID_DISAPPEAR( signal )
{
}

#pragma mark -

ON_LEFT_BUTTON_TOUCHED( signal )
{
    [self.stack popBoardAnimated:YES];
}

ON_RIGHT_BUTTON_TOUCHED( signal )
{
}

#pragma mark - E1_PendingPaymentCell_iPhone

/**
 * 个人中心-待付款订单-订单列表，订单取消事件触发时执行的操作
 */
ON_SIGNAL3( E1_PendingPaymentCell_iPhone, ORDER_CANCEL, signal )
{
	E1_PendingPaymentCell_iPhone * cell = (E1_PendingPaymentCell_iPhone *)signal.source;

	ORDER * order = cell.order;

	BeeUIAlertView * alert = [BeeUIAlertView spawn];
	alert.title = @"是否取消订单?";
	[alert addButtonTitle:@"确定" signal:self.ORDER_CANCELED object:order];
	[alert addCancelTitle:@"取消"];
	[alert showInViewController:self];
}

- (void)didPaySuccess
{
	[self.stack popToRootViewControllerAnimated:NO];
	[bee.ui.tabbar selectUser];
	[bee.ui.router open:AppBoard_iPhone.TAB_USER animated:NO];
	[bee.ui.profile.stack pushBoard:[E2_PendingShippedBoard_iPhone board] animated:NO];

	[self.view.window presentSuccessTips:__TEXT( @"pay_succeed" )];
}

/**
 * 个人中心-待付款订单-订单列表，订单付款事件触发时执行的操作
 */
ON_SIGNAL3( E1_PendingPaymentCell_iPhone, ORDER_PAY, signal )
{
	ORDER * order = (ORDER *)signal.sourceCell.data;

	if ( order && order.order_info )
	{
		if ( NSOrderedSame == [order.order_info.pay_code compare:@"alipay" options:NSCaseInsensitiveSearch] )
		{
			// 选择WAP或SDK支付
			BeeUIActionSheet * paySelect = [BeeUIActionSheet spawn];
			[paySelect addButtonTitle:@"支付宝支付" signal:self.PAY_SDK object:order];
			[paySelect addButtonTitle:@"支付宝wap支付" signal:self.PAY_WAP object:order];
			[paySelect addCancelTitle:__TEXT(@"button_cancel")];
			[paySelect showInViewController:self];
		}
		else if ( NSOrderedSame == [order.order_info.pay_code compare:@"cod" options:NSCaseInsensitiveSearch] )
		{
			[[BeeUIApplication sharedInstance] presentMessageTips:__TEXT(@"pay_noneed")];
		}
		else if ( NSOrderedSame == [order.order_info.pay_code compare:@"upop" options:NSCaseInsensitiveSearch] )
		{
			[self.orderModel pay:order];
		}
		else if ( NSOrderedSame == [order.order_info.pay_code compare:@"tenpay" options:NSCaseInsensitiveSearch] )
		{
			H1_PayBoard_iPhone * board	= [H1_PayBoard_iPhone board];
			board.backBoard				= self.previousBoard;
			board.orderID				= order.order_id;
			board.order_info			= order.order_info;
			[self.stack pushBoard:board animated:YES];
		}
		else if ( NSOrderedSame == [order.order_info.pay_code compare:@"paypal" options:NSCaseInsensitiveSearch] )
		{
			H1_PayBoard_iPhone * board	= [H1_PayBoard_iPhone board];
			board.backBoard				= self.previousBoard;
			board.orderID				= order.order_id;
			board.order_info			= order.order_info;
			[self.stack pushBoard:board animated:YES];
        }
        else if ( NSOrderedSame == [order.order_info.pay_code compare:@"wxpay" options:NSCaseInsensitiveSearch] )
        {
            self.wxpayModel.order_id = order.order_id;
            [self.wxpayModel pay];
        }
    }
}

ON_SIGNAL3( WXPayModel, RELOADING, signal )
{
    [self presentMessageTips:@"加载支付信息"];
}

ON_SIGNAL3( WXPayModel, RELOADED, signal )
{
}

ON_SIGNAL3( WXPayModel, FAILED, signal )
{
    [self presentMessageTips:@"微信支付失败"];
}

ON_SIGNAL3( C1_CheckOutBoard_iPhone, ACTION_BACK, signal )
{
    [self.stack popBoardAnimated:YES];
}

#pragma mark -

/**
 * 个人中心-待付款订单，订单被取消事件执行的操作
 */
ON_SIGNAL3( E1_PendingPaymentBoard_iPhone, ORDER_CANCELED, signal )
{
	ORDER * order = (ORDER *)signal.object;
	if ( order )
	{
		[self.orderModel cancel:order];
	}
}

/**
 * 购物车-结算-提交订单-确认提交, 选择使用SDK进行支付
 */
ON_SIGNAL3( E1_PendingPaymentBoard_iPhone, PAY_SDK, signal )
{
}

/**
 * 购物车-结算-提交订单-确认提交, 选择使用WAP进行支付
 */
ON_SIGNAL3( E1_PendingPaymentBoard_iPhone, PAY_WAP, signal )
{
}

/**
 * 个人中心-待付款订单-付款-支付宝支付, 支付宝安装
 */
ON_SIGNAL3(E1_PendingPaymentBoard_iPhone, INSTALLATION_APP, signal)
{
	NSString * installActionURL = [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/zhi-fu-bao-qian-bao-yu-e-bao/id333206289?mt=8"];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:installActionURL]];
}

#pragma mark -

ON_MESSAGE3( API, order_list, msg )
{
	if ( msg.sending )
	{
		if ( NO == self.orderModel.loaded )
		{
//			[self presentLoadingTips:__TEXT(@"tips_loading")];
		}

		if ( self.orderModel.orders.count )
		{
			[self.list setFooterLoading:YES];
		}
		else
		{
			[self.list setFooterLoading:NO];
		}
	}
	else
	{
		[self dismissTips];

		[self.list setHeaderLoading:NO];
		[self.list setFooterLoading:NO];
	}

	if ( msg.succeed )
	{
		STATUS * status = msg.GET_OUTPUT(@"status");

		if ( status && status.succeed.boolValue )
		{
			self.list.footerShown = YES;
			[self.list setFooterMore:self.orderModel.more];
			[self.list reloadData];
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

ON_MESSAGE3( API, order_cancel, msg )
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
		STATUS * status = msg.GET_OUTPUT(@"status");

		if ( status && status.succeed.boolValue )
		{
			[self presentSuccessTips:__TEXT(@"successful_operation")];

			[self.list setFooterMore:self.orderModel.more];

			[self.list reloadData];
			
			[self.orderModel firstPage];
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

ON_MESSAGE3( API, order_pay, msg )
{
}

@end
