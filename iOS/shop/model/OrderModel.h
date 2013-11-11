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

@interface OrderModel : MultiPageModel

@property (nonatomic, retain) NSString *		type;
@property (nonatomic, retain) NSMutableArray *	orders;
@property (nonatomic, retain) NSString *		html;

- (void)affirmReceived:(ORDER *)order;
- (void)cancel:(ORDER *)order;
- (void)pay:(ORDER *)order;

@end

#pragma mark -

@interface OrderAwaitPayModel : OrderModel
AS_SINGLETON( OrderAwaitPayModel )
@end

#pragma mark -

@interface OrderAwaitShipModel : OrderModel
AS_SINGLETON( OrderAwaitShipModel )
@end

#pragma mark -

@interface OrderShippedModel : OrderModel
AS_SINGLETON( OrderShippedModel )
@end

#pragma mark -

@interface OrderFinishedModel : OrderModel
AS_SINGLETON( OrderFinishedModel )
@end
