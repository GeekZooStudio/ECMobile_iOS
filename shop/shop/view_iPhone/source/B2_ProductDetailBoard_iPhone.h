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
#import "B2_ProductDetailTabCell_iPhone.h"

#import "controller.h"
#import "model.h"

#import "UIViewController+ErrorTips.h"

#pragma mark -

@interface B2_ProductDetailBoard_iPhone : BaseBoard_iPhone

AS_INT( ACTION_ADD )
AS_INT( ACTION_BUY )
AS_INT( ACTION_SPEC )

AS_OUTLET( BeeUIScrollView, list )
AS_OUTLET( B2_ProductDetailTabCell_iPhone, tabbar )

/**
 * 商品详情-分享-新浪微博，点击时触发该事件
 */
AS_SIGNAL( SHARE_TO_SINA )

/**
 * 商品详情-分享-腾讯微博，点击时触发该事件
 */
AS_SIGNAL( SHARE_TO_TENCENT )

/**
 * 商品详情-分享-微信朋友圈，点击时触发该事件
 */
AS_SIGNAL( SHARE_TO_WEIXIN_FRIEND )

/**
 * 商品详情-分享-微信，点击时触发该事件
 */
AS_SIGNAL( SHARE_TO_WEIXIN_TIMELINE )

AS_MODEL( CartModel,		cartModel )
AS_MODEL( GoodsInfoModel,	goodsModel )
AS_MODEL( CollectionModel,	collectionModel )

@property (nonatomic, assign) NSUInteger		action; // called path for showing specView
@property (nonatomic, retain) NSMutableArray *  specs;
@property (nonatomic, assign) NSNumber *        count;
@property (nonatomic, assign) NSNumber *        specfied;

@end
