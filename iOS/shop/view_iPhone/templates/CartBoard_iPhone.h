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

@interface CartCheckoutCell_iPhone : BeeUICell
@end

@interface CartEditCell_iPhone : BeeUICell
@property (nonatomic, readonly) NSNumber *      count;
@property (nonatomic, retain) BeeUIButton *     pluss;
@property (nonatomic, retain) BeeUIButton *     minus;
@property (nonatomic, retain) BeeUIButton *     remove;
@property (nonatomic, retain) BeeUITextField *  input;
@end

@interface CartGoodCell_iPhone : BeeUICell
@end

@interface CartBoardCell_iPhone : BeeUICell

AS_SIGNAL( CART_EDIT_DONE )
AS_SIGNAL( CART_EDIT_BEGAN )
AS_SIGNAL( CART_REMOVE_DONE )

@property (nonatomic, assign) BOOL                  editing;
@property (nonatomic, readonly) NSNumber *          count;
@property (nonatomic, retain) BeeUIImageView *      background;
@property (nonatomic, retain) BeeUICell *           container;
@property (nonatomic, retain) CartGoodCell_iPhone * cartCell;
@property (nonatomic, retain) CartEditCell_iPhone * editCell;
@end

@interface CartBoard_iPhone : BaseBoard_iPhone
AS_SIGNAL( REMOVE_CONFIRM )
AS_SIGNAL( REMOVE_CANCEL )
@property (nonatomic, retain) NSMutableArray * editingState;
@property (nonatomic, retain) CartModel * cartModel;
@property (nonatomic, retain) AddressModel * addressModel;
@property (nonatomic, retain) CartBoardCell_iPhone * currentCell;
@end