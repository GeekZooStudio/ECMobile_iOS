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
#import "C1_CheckoutHeader_iPhone.h"
#import "C1_CheckOutBoard_iPhone.h"

@class C1_CheckoutHeader_iPhone;
@class C1_CheckoutOrderCell_iPhone;

#pragma mark -

/**
 * 购物车-结算cell
 */
@interface C1_CheckOutCell_iPhone : BeeUICell

AS_OUTLET( BeeUILabel, balance_pay_subtitle )
AS_OUTLET( BeeUILabel, balance_shipping_subtitle )
AS_OUTLET( BeeUILabel, balance_bill_subtitle )
AS_OUTLET( BeeUILabel, balance_redpocket_subtitle )
AS_OUTLET( BeeUILabel, balance_redpocket_title )
AS_OUTLET( BeeUILabel, balance_exp_subtitle )
AS_OUTLET( BeeUILabel, balance_exp_title )
AS_OUTLET( BeeUIButton, balance_redpocket )
AS_OUTLET( BeeUIButton, balance_exp )
AS_OUTLET( C1_CheckoutHeader_iPhone, consignee_cell )
AS_OUTLET( C1_CheckoutOrderCell_iPhone, order_cell )

@end
