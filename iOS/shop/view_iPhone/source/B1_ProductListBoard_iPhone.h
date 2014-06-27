//
//                       __
//                      /\ \   _
//    ____    ____   ___\ \ \_/ \           _____    ___     ___
//   / _  \  / __ \ / __ \ \    <     __   /\__  \  / __ \  / __ \
//  /\ \_\ \/\  __//\  __/\ \ \\ \   /\_\  \/_/  / /\ \_\ \/\ \_\ \
//  \ \____ \ \____\ \____\\ \_\\_\  \/_/   /\____\\ \____/\ \____/
//   \/____\ \/____/\/____/ \/_//_/         \/____/ \/___/  \/___/
//     /\____/
//     \/___/
//
//  Powered by BeeFramework
//
	
#import "Bee.h"
#import "BaseBoard_iPhone.h"

#import "controller.h"
#import "model.h"

#import "UIViewController+ErrorTips.h"

#pragma mark -

@class B1_ProductListFilterCell_iPhone;
@class B1_ProductListCartCell_iPhone;

#pragma mark -

@interface B1_ProductListBoard_iPhone : BaseBoard_iPhone

AS_INT( MODE_GRID )
AS_INT( MODE_LARGE )

AS_INT( TAB_HOT )
AS_INT( TAB_CHEAPEST )
AS_INT( TAB_EXPENSIVE )

AS_OUTLET( B1_ProductListFilterCell_iPhone, filter )
AS_OUTLET( BeeUIScrollView, list )
AS_OUTLET( B1_ProductListCartCell_iPhone, listcart )

@property (nonatomic, assign) NSInteger					tabIndex;
@property (nonatomic, assign) NSInteger					currentMode;
@property (nonatomic, retain) NSString *				category;

@property (nonatomic, retain) SearchModel *		searchByHotModel;
@property (nonatomic, retain) SearchModel *		searchByCheapestModel;
@property (nonatomic, retain) SearchModel *		searchByExpensiveModel;

@end
