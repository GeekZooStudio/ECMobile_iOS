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

/**
 * 购物车-结算-配送方式
 */
@interface C3_DistributionBoard_iPhone : BaseBoard_iPhone

AS_OUTLET( BeeUIScrollView, list );

@property (nonatomic, retain) NSNumber * shipping_id;

@property (nonatomic, assign) FlowModel * flowModel;

@end