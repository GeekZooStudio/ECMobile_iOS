/*
 *                                                                          
 *       _/_/_/                      _/        _/_/_/_/_/                     
 *    _/          _/_/      _/_/    _/  _/          _/      _/_/      _/_/    
 *   _/  _/_/  _/_/_/_/  _/_/_/_/  _/_/          _/      _/    _/  _/    _/   
 *  _/    _/  _/        _/        _/  _/      _/        _/    _/  _/    _/    
 *   _/_/_/    _/_/_/    _/_/_/  _/    _/  _/_/_/_/_/    _/_/      _/_/       
 *                                                                          
 *
 *  Copyright 2013-2014, Geek Zoo Studio
 *  http://www.ecmobile.cn/license.html
 *
 *  HQ China:
 *    2319 Est.Tower Van Palace 
 *    No.2 Guandongdian South Street 
 *    Beijing , China
 *
 *  U.S. Office:
 *    One Park Place, Elmira College, NY, 14901, USA
 *
 *  QQ Group:   329673575
 *  BBS:        bbs.ecmobile.cn
 *  Fax:        +86-10-6561-5510
 *  Mail:       info@geek-zoo.com
 */

#import "Bee.h"
#import "ecmobile.h"
#import "BaseModel.h"

#pragma mark -

@interface FlowModel : BaseModel

AS_SINGLETON( FlowModel )

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

- (void)clearFields;

@end
