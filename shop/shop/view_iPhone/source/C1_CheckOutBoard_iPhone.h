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

AS_MODEL( FlowModel, flowModel )

AS_OUTLET( BeeUIScrollView , list )

@property (nonatomic, retain) BeeUIPickerView * bonusPicker;

@end
