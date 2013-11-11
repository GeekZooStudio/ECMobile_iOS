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

@interface GoodsDetailTab_iPhone : BeeUICell
@end

@interface GoodsDetailSlide_iPhone : BeeUICell
AS_SIGNAL( TOUCHED )
@end

@interface GoodsDetailCell_iPhone : BeeUICell
@end

@interface GoodsDetailBoard_iPhone : BaseBoard_iPhone
{
    BeeUIScrollView *		_scroll;
    GoodsDetailTab_iPhone *	_tabbar;
}

AS_INT( ACTION_ADD )
AS_INT( ACTION_BUY )
AS_INT( ACTION_SPEC )

@property (nonatomic, assign) NSUInteger		action; // called path for showing specView
@property (nonatomic, retain) CartModel *		cartModel;
@property (nonatomic, retain) CollectionModel *	collectionModel;
@property (nonatomic, retain) GoodsModel *		goodsModel;
@property (nonatomic, retain) NSMutableArray *  specs;
@property (nonatomic, assign) NSNumber *        count;

@end
