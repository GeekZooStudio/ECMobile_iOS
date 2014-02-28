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
 * 个人中心-待发货订单-订单列表中cell
 */
@interface E2_PendingShippedCell_iPhone : BeeUICell

AS_OUTLET( BeeUIScrollView, list )

@property (nonatomic, retain) ORDER * order;

+ (CGFloat)heightByCount:(NSInteger)count;

@end
