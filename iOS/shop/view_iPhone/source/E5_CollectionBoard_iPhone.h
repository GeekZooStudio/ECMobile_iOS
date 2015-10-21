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

#pragma mark -

/**
 * 个人中心-我的收藏-商品列表board
 */
@interface E5_CollectionBoard_iPhone : BaseBoard_iPhone

@property (nonatomic, assign) BOOL isEditing;

AS_SIGNAL( UNFAVOURITE )

AS_OUTLET( BeeUIScrollView, list )

AS_MODEL( CollectionModel, collectionModel )

@end