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

#pragma mark -

@interface BannerPhotoCell_iPhone : BeeUICell
AS_SIGNAL( TOUCHED )
@end

#pragma mark -

@interface BannerCell_iPhone : BeeUICell
@property (nonatomic, retain) BeeUIScrollView *		scroll;
@property (nonatomic, retain) BeeUIPageControl *	pageControl;
@end

#pragma mark -

@interface IndexNotifiCell_iPhone : BeeUICell
AS_SIGNAL( TOUCHED )
@end

#pragma mark -

@interface RecommendCell_iPhone : BeeUICell
@end

#pragma mark -

@interface RecommendGoodsCell_iPhone : BeeUICell
AS_SIGNAL( TOUCHED )
@end

#pragma mark -

@interface CategoryCell_iPhone : BeeUICell
AS_SIGNAL( CATEGORY_TOUCHED )
AS_SIGNAL( GOODS1_TOUCHED )
AS_SIGNAL( GOODS2_TOUCHED )
@end

#pragma mark -

@interface IndexNotifiBarItem_iPhone : BeeUICell
@end

#pragma mark -

@interface IndexBoard_iPhone : BaseBoard_iPhone
@property (nonatomic, retain) BannerModel *		model1;
@property (nonatomic, retain) CategoryModel *	model2;
//@property (nonatomic, retain) HelpModel *		model3;
@end
