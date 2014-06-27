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
#import "FormCell.h"
#import "BaseBoard_iPhone.h"

#pragma mark -

/**
 * 购物车-结算-支付方式
 */
@interface C2_PaymentBoard_iPhone : BaseBoard_iPhone

AS_OUTLET( BeeUIScrollView, list );

@property (nonatomic, retain) NSNumber * pay_id;
@property (nonatomic, assign) FlowModel * flowModel;

@end