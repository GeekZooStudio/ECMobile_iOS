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

@interface OrderCellInfo_iPhone : BeeUICell
@property (nonatomic, retain) NSString * formated_integral_money;
@property (nonatomic, retain) NSString * formated_shipping_fee;
@property (nonatomic, retain) NSString * formated_bonus;
@end

@interface OrderCellHeader_iPhone : BeeUICell
@end

@interface OrderCellFooter_iPhone : BeeUICell
@end

@interface OrderCellBody_iPhone : BeeUICell
@end

@interface OrderCell_iPhone : BeeUICell
{
    BeeUIScrollView * _scroll;
    NSInteger         _dataCounts;
}

+ (CGFloat)heightByCount:(NSInteger)count;

@end

@interface OrdersBoard_iPhone : BaseBoard_iPhone
@end