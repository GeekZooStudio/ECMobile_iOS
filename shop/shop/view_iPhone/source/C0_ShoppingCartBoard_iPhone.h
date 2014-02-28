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

@class C0_ShoppingCartCell_iPhone;

@interface C0_ShoppingCartBoard_iPhone : BaseBoard_iPhone

/**
 * 购物车-商品列表-移除商品，取消移除时触发该事件
 */
AS_SIGNAL( REMOVE_CONFIRM )

/**
 * 购物车-商品列表-移除商品，确定移除时触发该事件
 */
AS_SIGNAL( REMOVE_CANCEL )

AS_OUTLET( BeeUIScrollView, list )
AS_OUTLET( BeeUIImageView, header )

AS_MODEL( CartModel,		cartModel )
AS_MODEL( AddressListModel,	addressListModel )

@property (nonatomic, retain) NSMutableArray *				editingState;
@property (nonatomic, assign) C0_ShoppingCartCell_iPhone *	currentCell;

@end
