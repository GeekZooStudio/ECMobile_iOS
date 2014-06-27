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
#import "ecmobile.h"

#pragma mark -

@interface FlowModel : BeeOnceViewModel

@property (nonatomic, retain) NSNumber *    order_id;

@property (nonatomic, retain) NSNumber *	allow_use_bonus;
@property (nonatomic, retain) NSArray  *	bonus;
@property (nonatomic, retain) NSNumber *	allow_use_integral;
@property (nonatomic, retain) ADDRESS *		consignee;
@property (nonatomic, retain) NSArray *		goods_list;
@property (nonatomic, retain) NSArray *		inv_content_list;
@property (nonatomic, retain) NSArray *		inv_type_list;
@property (nonatomic, retain) NSNumber *	order_max_integral;
@property (nonatomic, retain) NSArray *		payment_list;
@property (nonatomic, retain) NSArray *		shipping_list;
@property (nonatomic, retain) NSNumber *	your_integral;

@property (nonatomic, retain) PAYMENT *		done_payment;
@property (nonatomic, retain) SHIPPING *	done_shipping;
@property (nonatomic, retain) NSString *	done_bonus;
@property (nonatomic, retain) NSNumber *	done_integral;
@property (nonatomic, retain) NSString *	done_inv_content;
@property (nonatomic, retain) NSString *	done_inv_payee;
@property (nonatomic, retain) NSNumber *	done_inv_type;
@property (nonatomic, retain) BONUS *       data_bonus;
@property (nonatomic, retain) NSString *    data_integral_formated;
@property (nonatomic, retain) NSNumber *	data_integral;
@property (nonatomic, retain) ORDER_INFO *	order_info;

- (void)checkOrder;
- (void)done;
- (void)reset;

@end
