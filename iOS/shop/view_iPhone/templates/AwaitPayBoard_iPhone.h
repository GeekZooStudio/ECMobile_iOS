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

@interface AwaitPayCellFooter_iPhone : BeeUICell
@end

@interface AwaitPayCell_iPhone : BeeUICell
{
    BeeUIScrollView * _scroll;
}

AS_SIGNAL( ORDER_CANCEL )
AS_SIGNAL( ORDER_PAY )

@property (nonatomic, retain) ORDER * order;

+ (CGFloat)heightByCount:(NSInteger)count;

@end

@interface AwaitPayBoard_iPhone : BaseBoard_iPhone
@property (nonatomic, retain) OrderAwaitPayModel * awaitPayModel;
@end