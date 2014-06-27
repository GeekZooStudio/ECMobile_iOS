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

@class C0_ShoppingCartGoodCell_iPhone;
@class C0_ShoppingCartEditCell_iPhone;

#pragma mark -

/**
 * 购物车-商品列表中cell（可编辑）
 */
@interface C0_ShoppingCartCell_iPhone : BeeUICell

/**
 * 购物车-商品列表-完成，完成编辑时触发该事件
 */
AS_SIGNAL( CART_EDIT_DONE )

/**
 * 购物车-商品列表-编辑，开始编辑时触发该事件
 */
AS_SIGNAL( CART_EDIT_BEGAN )

/**
 * 购物车-商品列表-移除商品，点击时触发该事件
 */
AS_SIGNAL( CART_REMOVE )

@property (nonatomic, assign) BOOL                  editing;
@property (nonatomic, readonly) NSNumber *          count;
@property (nonatomic, retain) BeeUIImageView *      background;
@property (nonatomic, retain) BeeUICell *           container;
@property (nonatomic, retain) C0_ShoppingCartGoodCell_iPhone * cartCell;
@property (nonatomic, retain) C0_ShoppingCartEditCell_iPhone * editCell;

@end
