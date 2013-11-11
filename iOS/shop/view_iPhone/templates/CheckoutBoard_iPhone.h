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
#import "model.h"
#import "BaseBoard_iPhone.h"
#import "OrdersBoard_iPhone.h"
#import "FormView.h"

@interface CheckoutHeader_iPhone : BeeUICell
@end

@interface CheckoutOrderCellInfo_iPhone : BeeUICell
@property (nonatomic, retain) SHIPPING * shipping;
@property (nonatomic, retain) NSString * intergal;
@property (nonatomic, retain) NSString * bonus;
@end

@interface CheckoutOrderCellHeader_iPhone : BeeUICell
@end

@interface CheckoutOrderCellFooter_iPhone : BeeUICell
@end

@interface CheckoutOrderCellBody_iPhone : BeeUICell
@end

@interface CheckoutOrderCell_iPhone : BeeUICell
{
    BeeUIScrollView * _scroll;
    NSInteger         _dataCounts;
}

@property (nonatomic, retain) FlowModel * flowModel;

@end

@interface CheckoutBoard_iPhone : FormViewBoard

AS_SIGNAL( ACTION_PAY )
AS_SIGNAL( ACTION_BACK )

@property (nonatomic, retain) FormElement * address;
@property (nonatomic, retain) FormElement * payment;
@property (nonatomic, retain) FormElement * shipping;
@property (nonatomic, retain) FormElement * invoice;
@property (nonatomic, retain) FormElement * orders;
@property (nonatomic, retain) FormElement * bonus;
@property (nonatomic, retain) FormElement * integral;
@property (nonatomic, retain) FormElement * details;

@property (nonatomic, retain) BeeUIPickerView * bonusPicker;
@property (nonatomic, retain) FlowModel * flowModel;

@end