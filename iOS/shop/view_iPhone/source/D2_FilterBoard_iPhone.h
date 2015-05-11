//
//   ______    ______    ______    
//  /\  __ \  /\  ___\  /\  ___\
//  \ \  __<  \ \  __\_ \ \  __\_ 
//   \ \_____\ \ \_____\ \ \_____\
//    \/_____/  \/_____/  \/_____/ 
//
//  Powered by BeeFramework
//
//
//  D2_FilterBoard_iPhone.h
//  shop
//
//  Created by QFish on 9/11/13.
//  Copyright (c) 2013 geek-zoo studio. All rights reserved.
//

#import "Bee.h"

#import "controller.h"
#import "model.h"
#import "ecmobile.h"

#import "BaseBoard_iPhone.h"

#import "UIViewController+ErrorTips.h"

#import "CommonTagList.h"


#pragma mark -

@interface FilterCellData : NSObject

AS_INT( SECTION_BRAND )
AS_INT( SECTION_CATEGORY )
AS_INT( SECTION_PRICE_RANGE )

@property (nonatomic, assign) BOOL        expaned;
@property (nonatomic, assign) NSUInteger  section;
@property (nonatomic, retain) FILTER *    filter;
@property (nonatomic, retain) NSArray *   array;
@property (nonatomic, retain) NSString *  title;

@end

#pragma mark -

/**
 * 商品列表-筛选board
 */
@interface D2_FilterBoard_iPhone : BaseBoard_iPhone

AS_OUTLET( BeeUIScrollView, list )

AS_MODEL( BrandModel,		brandModel )
AS_MODEL( CategoryModel,	categoryModel )
AS_MODEL( PriceRangeModel,	priceRangeModel )

@property (nonatomic, retain) FILTER * filter;
@property (nonatomic, assign) BOOL shouldShowCategory;

@end
