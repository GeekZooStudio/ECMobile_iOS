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
#import "ecmobile.h"

#pragma mark -

@interface AdvancedSearchCell_iPhone : BeeUICell
@property (nonatomic, assign) BOOL        expaned;
@property (nonatomic, assign) NSString *  indexKey;
@property (nonatomic, assign) NSString *  cellTitle;
@end

#pragma mark -

@interface AdvancedSearchBoard_iPhone : BeeUIBoard
@property (nonatomic, retain) FILTER *              filter;
@property (nonatomic, retain) BrandModel *          brandModel;
@property (nonatomic, retain) CategoryModel *       categoryModel;
@property (nonatomic, retain) PriceRangeModel *     rangeModel;
@end
