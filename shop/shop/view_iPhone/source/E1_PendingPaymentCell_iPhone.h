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

#import "Bee.h"

#pragma mark -

/**
 * 个人中心-待付款订单-订单列表中cell
 */
@interface E1_PendingPaymentCell_iPhone : BeeUICell

AS_OUTLET( BeeUIScrollView, list )

/**
 * 个人中心-待付款订单-订单列表，订单取消时触发该事件
 */
AS_SIGNAL( ORDER_CANCEL )

/**
 * 个人中心-待付款订单-订单列表，订单付款时触发该事件
 */
AS_SIGNAL( ORDER_PAY )

@property (nonatomic, retain) ORDER * order;

+ (CGFloat)heightByCount:(NSInteger)count;

@end
