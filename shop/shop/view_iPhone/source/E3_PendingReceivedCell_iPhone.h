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
 * 个人中心-待收货订单-订单列表中cell
 */
@interface E3_PendingReceivedCell_iPhone : BeeUICell

/**
 * 个人中心-待收货订单-订单列表，点击查看物流时触发该事件
 */
AS_SIGNAL( ORDER_SHIIPING )

/**
 * 个人中心-待收货订单-订单列表，点击确认收货时触发该事件
 */
AS_SIGNAL( ORDER_AFFIRM )

AS_OUTLET( BeeUIScrollView, list )

@property (nonatomic, retain) ORDER * order;

+ (CGFloat)heightByCount:(NSInteger)count;

@end
