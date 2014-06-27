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
//	Powered by BeeFramework
//

#import "D2_FilterBoard_iPhone.h"
#import "D2_FilterCell_iPhone.h"
#import "B1_ProductListBoard_iPhone.h"

#import "NSObject+TagList.h"

#pragma mark -

@implementation FilterCellData
DEF_INT( SECTION_BRAND, 1 )
DEF_INT( SECTION_CATEGORY, 2 )
DEF_INT( SECTION_PRICE_RANGE, 3 )
@end

#pragma mark -

@interface D2_FilterBoard_iPhone()
@property (nonatomic, retain) FILTER * tempFilter;
@property (nonatomic, assign) BOOL brandExpaned;
@property (nonatomic, assign) BOOL categoryExpaned;
@property (nonatomic, assign) BOOL priceRangeExpaned;
@end

@implementation D2_FilterBoard_iPhone

SUPPORT_RESOURCE_LOADING( YES );
SUPPORT_AUTOMATIC_LAYOUT( YES );

DEF_OUTLET( BeeUIScrollView, list )

DEF_MODEL( BrandModel,		brandModel )
DEF_MODEL( CategoryModel,	categoryModel )
DEF_MODEL( PriceRangeModel,	priceRangeModel )

- (void)load
{
//    _expanedState = [[NSMutableDictionary alloc] initWithCapacity:3];

	self.brandModel = [BrandModel modelWithObserver:self];
	self.categoryModel = [CategoryModel modelWithObserver:self];
	self.priceRangeModel = [PriceRangeModel modelWithObserver:self];
    
    self.shouldShowCategory = NO;
}

- (void)unload
{
	SAFE_RELEASE_MODEL( self.brandModel )
	SAFE_RELEASE_MODEL( self.categoryModel )
	SAFE_RELEASE_MODEL( self.priceRangeModel )
    
//    [_expanedState removeAllObjects];
//    [_expanedState release];
}

#pragma mark -

ON_CREATE_VIEWS( signal )
{
    self.brandExpaned = YES;
    self.categoryExpaned = YES;
    self.priceRangeExpaned = YES;
    
    [self showNavigationBarAnimated:NO];
    
    self.navigationBarTitle = __TEXT(@"filter");
    [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav_back.png"]];
    [self showBarButton:BeeUINavigationBar.RIGHT title:__TEXT(@"collect_done") image:[UIImage imageNamed:@"nav_right.png"]];
    
    self.tempFilter = [[[FILTER alloc] init] autorelease];
    
    self.tempFilter.brand_id = self.filter.brand_id;
    self.tempFilter.category_id = self.filter.category_id;
    self.tempFilter.price_range = self.filter.price_range;
    
    @weakify(self);

    self.list.lineCount = 1;
    self.list.reuseEnable = NO;
    self.list.animationDuration = 0.25f;
    
    self.list.whenReloading = ^
    {
        @normalize(self);
        
        self.list.total = self.brandModel.brands.count ? 1 : 0;
        self.list.total += self.categoryModel.categories.count ? 1 : 0;
        self.list.total += self.priceRangeModel.price_ranges.count ? 1 : 0;

        int offset = 0;
        
        if ( self.brandModel.brands.count )
        {
            BRAND * data = [[[BRAND alloc] init] autorelease];
            data.brand_id = @0;
            data.brand_name = @"全部";
            
            NSMutableArray * datas = [NSMutableArray arrayWithObject:data];
            [datas addObjectsFromArray:self.brandModel.brands];
            
            FilterCellData * filterData = [[[FilterCellData alloc] init] autorelease];
            filterData.array = datas;
            filterData.title = __TEXT(@"brand");
            filterData.filter = self.tempFilter;
            filterData.expaned = self.brandExpaned;
            filterData.section = FilterCellData.SECTION_BRAND;
            
            BeeUIScrollItem * brandItem = self.list.items[offset];
            brandItem.clazz = [D2_FilterCell_iPhone class];
            brandItem.data = filterData;
            brandItem.size = CGSizeAuto;
            brandItem.rule = BeeUIScrollLayoutRule_Tile;
            
            offset += 1;
        }
        
		// TODO：去除self.shouldShowCategory
		if ( self.categoryModel.categories.count )
        {
            CATEGORY * data = [[[CATEGORY alloc] init] autorelease];
            data.id = @0;
            data.name = @"全部";
            
            NSMutableArray * datas = [NSMutableArray arrayWithObject:data];
            [datas addObjectsFromArray:self.categoryModel.categories];
            
            FilterCellData * filterData = [[[FilterCellData alloc] init] autorelease];
            filterData.array = datas;
            filterData.title = __TEXT(@"category");
            filterData.filter = self.tempFilter;
            filterData.expaned = self.categoryExpaned;
            filterData.section = FilterCellData.SECTION_CATEGORY;
            
            BeeUIScrollItem * categoryItem = self.list.items[offset];
            categoryItem.clazz = [D2_FilterCell_iPhone class];
            categoryItem.data = filterData;
            categoryItem.size = CGSizeAuto;
            categoryItem.rule = BeeUIScrollLayoutRule_Tile;
            
            offset += 1;
        }
    
        if ( self.priceRangeModel.price_ranges.count )
        {
            PRICE_RANGE * data = [[[PRICE_RANGE alloc] init] autorelease];
            data.price_min = @0;
            data.price_max = nil;
            
            NSMutableArray * datas = [NSMutableArray arrayWithObject:data];
            [datas addObjectsFromArray:self.priceRangeModel.price_ranges];
            
            FilterCellData * filterData = [[[FilterCellData alloc] init] autorelease];
            filterData.array = datas;
            filterData.title = __TEXT(@"price_range");
            filterData.filter = self.tempFilter;
            filterData.expaned = self.priceRangeExpaned;
            filterData.section = FilterCellData.SECTION_PRICE_RANGE;
            
            BeeUIScrollItem * priceItem = self.list.items[offset];
            priceItem.clazz = [D2_FilterCell_iPhone class];
            priceItem.data = filterData;
            priceItem.size = CGSizeAuto;
            priceItem.rule = BeeUIScrollLayoutRule_Tile;
            
            offset += 1;
        }
    };
    
}

ON_DELETE_VIEWS( signal )
{
    self.tempFilter = nil;
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
    if ( self.filter.category_id == nil )
    {
        if ( NO == self.categoryModel.loaded )
        {
            [self.categoryModel reload];
        }
    }
    else
    {
        self.brandModel.category_id = self.filter.category_id;
        self.priceRangeModel.category_id = self.filter.category_id;
    }
    
    if ( NO == self.brandModel.loaded )
    {
        [self.brandModel reload];
    }
    
    if ( NO == self.priceRangeModel.loaded )
    {
        [self.priceRangeModel reload];
    }

	[self.list reloadData];
}

ON_DID_APPEAR( signal )
{

    [self.list reloadData];
}

ON_WILL_DISAPPEAR( signal )
{
}

ON_DID_DISAPPEAR( signal )
{
}

ON_LOAD_DATAS( signal )
{

}

#pragma mark -

ON_LEFT_BUTTON_TOUCHED( signal )
{
    [self.stack popBoardAnimated:YES];
}

ON_RIGHT_BUTTON_TOUCHED( signal )
{
    [self saveFilter:self.tempFilter];
    [self.stack popBoardAnimated:YES];
}

- (void)saveFilter:(FILTER *)filter
{
    B1_ProductListBoard_iPhone * board = (B1_ProductListBoard_iPhone *)self.previousBoard;
    
    [board.searchByHotModel modifiFilter:self.tempFilter];
    [board.searchByCheapestModel modifiFilter:self.tempFilter];
    [board.searchByExpensiveModel modifiFilter:self.tempFilter];
}

#pragma mark - D2_FilterCell_iPhone

/**
 * 商品列表-筛选-展开/折叠，点击事件触发时执行的操作
 */
ON_SIGNAL3( D2_FilterCell_iPhone, toggle, signal )
{
    FilterCellData * cellData = signal.sourceCell.data;
    
    if ( nil == cellData  )
    {
        return;
    }
    
    switch ( cellData.section )
    {
        case 1: // SECTION_BRAND
            self.brandExpaned = !self.brandExpaned;
            break;
        case 2: // SECTION_CATEGORY
            self.categoryExpaned = !self.categoryExpaned;
            break;
        case 3: // SECTION_PRICE_RANGE
            self.priceRangeExpaned = !self.priceRangeExpaned;
            break;
        default:
            break;
    }
    
    [self.list reloadData];
}

#pragma mark - CommonTagListCell

/**
 * 商品列表-筛选-筛选条件，点击事件触发时执行的操作
 */
ON_SIGNAL3( CommonTagListCell, button, signal )
{
    
    id data = signal.sourceCell.data;

    if ( [data isKindOfClass:[BRAND class]] )
    {
        self.tempFilter.brand_id = ((BRAND *)data).brand_id;
    }
    else if ( [data isKindOfClass:[CATEGORY class]] )
    {
        self.tempFilter.category_id = ((CATEGORY *)data).id;
        
        if ( nil == self.filter.category_id )
        {
            self.priceRangeModel.category_id = ((CATEGORY *)data).id;
            [self.priceRangeModel reload];
        }
    }
    else if ( [data isKindOfClass:[PRICE_RANGE class]] )
    {
        self.tempFilter.price_range = data;
    }
}

#pragma mark -

ON_MESSAGE3( API, home_category, msg )
{
    if ( msg.sending )
    {
        [self presentLoadingTips:__TEXT(@"tips_loading")];
    }
    else
    {
        [self dismissTips];
    }

	if ( msg.succeed )
	{
		[self.list asyncReloadData];
		[self.list reloadData];
	}
	else if ( msg.failed )
    {
        [self showErrorTips:msg];
    }
}

ON_MESSAGE3( API, brand, msg )
{
    if ( msg.sending )
    {
        [self presentLoadingTips:__TEXT(@"tips_loading")];
    }
    else
    {
        [self dismissTips];
    }
	
	if ( msg.succeed )
	{
		[self.list asyncReloadData];

		[self.list reloadData];
	}
	else if ( msg.failed )
    {
        [self showErrorTips:msg];
    }
}

ON_MESSAGE3( API, price_range, msg )
{
    if ( msg.sending )
    {
        [self presentLoadingTips:__TEXT(@"tips_loading")];
    }
    else
    {
        [self dismissTips];
    }
	
	if ( msg.succeed )
	{
		[self.list asyncReloadData];

		[self.list reloadData];
	}
	else if ( msg.failed )
    {
        [self showErrorTips:msg];
    }
}

@end
