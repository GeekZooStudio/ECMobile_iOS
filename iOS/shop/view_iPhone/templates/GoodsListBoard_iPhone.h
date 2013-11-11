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
#import "BaseBoard_iPhone.h"

#import "model.h"

@interface GoodsListCart_iPhone : BeeUICell
@end

@interface GoodsListFilter_iPhone : BeeUICell
- (void)selectTab1;
- (void)selectTab2;
- (void)selectTab3;
@end

@interface GoodsListGridCell_iPhone : BeeUICell
AS_SIGNAL( TAPPED )
@end

@interface GoodsListLargeCell_Phone : BeeUICell
AS_SIGNAL( TAPPED )
@end

@interface GoodsListSearchBar_iPhone : BeeUICell
@end

@interface GoodsListBoard_iPhone : BaseBoard_iPhone

AS_INT( TAB_HOT )
AS_INT( TAB_CHEAPEST )
AS_INT( TAB_EXPENSIVE )

@property (nonatomic, assign) NSInteger					tabIndex;
@property (nonatomic, assign) NSInteger					currentMode;
@property (nonatomic, retain) NSString *				category;

@property (nonatomic, retain) SearchByHotModel *		model1;
@property (nonatomic, retain) SearchByCheapestModel *	model2;
@property (nonatomic, retain) SearchByExpensiveModel *	model3;

@end