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
		
#import "Bee.h"
#import "BaseBoard_iPhone.h"

#import "controller.h"
#import "model.h"

#import "UIViewController+ErrorTips.h"

#pragma mark -

/**
 * 个人中心-待付款订单board
 */
@interface E1_PendingPaymentBoard_iPhone : BaseBoard_iPhone

AS_OUTLET( BeeUIScrollView, list )

AS_MODEL( OrderModel, orderModel )

AS_MODEL( WXPayModel, wxpayModel )

/**
 * 个人中心-待付款订单，订单被取消时触发该事件
 */
AS_SIGNAL( ORDER_CANCELED )

// 选择WAP或SDK支付
/**
 * 个人中心-待付款订单-付款, 选择使用SDK进行支付
 */
AS_SIGNAL( PAY_SDK )

/**
 * 个人中心-待付款订单-付款, 选择使用WAP进行支付
 */
AS_SIGNAL( PAY_WAP )

/**
 * 个人中心-待付款订单-付款-支付宝支付, 进行支付宝安装
 */
AS_SIGNAL( INSTALLATION_APP )





@end