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
 * 个人中心-历史订单-订单列表中cell
 */
@interface E4_HistoryCell_iPhone : BeeUICell

/**
 * 个人中心-历史订单-订单列表，点击查看物流时触发该事件
 */
AS_SIGNAL( ORDER_EXPRESS )

AS_OUTLET( BeeUIScrollView, list )

@property (nonatomic, retain) ORDER * order;

+ (CGFloat)heightByCount:(NSInteger)count;

@end
