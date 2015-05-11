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
 * 个人中心-我的收藏-商品列表中cell
 */
@interface E5_CollectionCell_iPhone : BeeUICell

/**
 * 个人中心-我的收藏-商品，点击时触发该事件
 */
AS_SIGNAL( TAPPED )

/**
 * 个人中心-我的收藏-商品，收藏被取消时执行该事件
 */
AS_SIGNAL( REMOVE )
@property (nonatomic, assign) BOOL isEditing;

@end
