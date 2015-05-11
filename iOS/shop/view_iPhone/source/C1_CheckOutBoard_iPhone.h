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
#import "OrderCell_iPhone.h"

#import "C1_CheckoutHeader_iPhone.h"

#import "controller.h"
#import "model.h"

#import "UIViewController+ErrorTips.h"

@interface C1_CheckOutBoard_iPhone : BaseBoard_iPhone

/**
 * 购物车-结算-提交订单，确定提交时触发该事件
 */
AS_SIGNAL( ACTION_PAY )

/**
 * 购物车-结算-提交订单，取消提交时触发该事件
 */
AS_SIGNAL( ACTION_BACK )

// 选择WAP或SDK支付
/**
 * 购物车-结算-提交订单-确认提交, 选择使用SDK进行支付
 */
AS_SIGNAL( PAY_SDK )

/**
 * 购物车-结算-提交订单-确认提交, 选择使用WAP进行支付
 */
AS_SIGNAL( PAY_WAP )

/**
 * 购物车-结算-提交订单-确认提交, 取消支付
 */
AS_SIGNAL( CANCEL )

/**
 * 购物车-结算-提交订单-确认提交-选择使用SDK进行支付,前往安装
 */
AS_SIGNAL( INSTALLATION_APP )

/**
 * 购物车-结算-提交订单-确认提交-选择使用SDK进行支付,忽略
 */
AS_SIGNAL( CANCEL_APP )

AS_MODEL( FlowModel, flowModel )

AS_MODEL( OrderModel, orderModel )

AS_MODEL( WXPayModel, wxpayModel )

AS_OUTLET( BeeUIScrollView , list )

@property (nonatomic, retain) BeeUIPickerView * bonusPicker;

@end
