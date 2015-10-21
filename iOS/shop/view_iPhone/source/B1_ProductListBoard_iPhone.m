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
	
#import "B1_ProductListBoard_iPhone.h"
#import "B2_ProductDetailBoard_iPhone.h"
#import "B1_ProductListCartCell_iPhone.h"
#import "B1_ProductListFilterCell_iPhone.h"
#import "B1_ProductListGridCell_iPhone.h"
#import "B1_ProductListLargeCell_Phone.h"
#import "B1_ProductListSearchBarCell_iPhone.h"
#import "C0_ShoppingCartBoard_iPhone.h"
#import "D2_FilterBoard_iPhone.h"
#import "B1_ProductListSearchBackgroundCell_iPhone.h"

#import "AppBoard_iPhone.h"

#import "CommonPullLoader.h"
#import "CommonFootLoader.h"
#import "CommonNoResultCell.h"

#pragma mark -

@interface B1_ProductListBoard_iPhone()
{
	B1_ProductListSearchBarCell_iPhone *	_titleSearch;
	B1_ProductListSearchBackgroundCell_iPhone * _searchBackground;
}
@end

@implementation B1_ProductListBoard_iPhone

SUPPORT_RESOURCE_LOADING( YES )
SUPPORT_AUTOMATIC_LAYOUT( YES )

DEF_INT( TAB_HOT,		0 )
DEF_INT( TAB_CHEAPEST,	1 )
DEF_INT( TAB_EXPENSIVE,	2 )

DEF_INT( MODE_GRID, 0 )
DEF_INT( MODE_LARGE, 1 )

DEF_OUTLET( B1_ProductListFilterCell_iPhone, filter )
DEF_OUTLET( BeeUIScrollView, list )
DEF_OUTLET( B1_ProductListCartCell_iPhone, listcart )

@synthesize tabIndex = _tabIndex;
@synthesize currentMode = _currentMode;
@synthesize category = _category;

@synthesize searchByHotModel = _searchByHotModel;
@synthesize searchByCheapestModel = _searchByCheapestModel;
@synthesize searchByExpensiveModel = _searchByExpensiveModel;

- (void)load
{
	self.tabIndex = self.TAB_CHEAPEST;
	
	self.searchByHotModel = [SearchModel modelWithObserver:self];
	self.searchByHotModel.filter.sort_by = SEARCH_ORDER_BY_HOT;

	self.searchByCheapestModel = [SearchModel modelWithObserver:self];
	self.searchByCheapestModel.filter.sort_by = SEARCH_ORDER_BY_CHEAPEST;

	self.searchByExpensiveModel = [SearchModel modelWithObserver:self];
	self.searchByExpensiveModel.filter.sort_by = SEARCH_ORDER_BY_EXPENSIVE;
}

- (void)unload
{
	SAFE_RELEASE_MODEL( self.searchByHotModel );
	SAFE_RELEASE_MODEL( self.searchByCheapestModel );
	SAFE_RELEASE_MODEL( self.searchByExpensiveModel );
	
	self.category = nil;
}

#pragma mark -

ON_CREATE_VIEWS( signal )
{
    [self showNavigationBarAnimated:NO];
    [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav_back.png"]];
    [self showBarButton:BeeUINavigationBar.RIGHT title:__TEXT(@"filter") image:[UIImage imageNamed:@"nav_right.png"]];

    self.currentMode = self.MODE_GRID;
    
    @weakify(self);
    
    self.list.headerClass = [CommonPullLoader class];
    self.list.headerShown = YES;
    
    self.list.footerClass = [CommonFootLoader class];
    self.list.footerShown = YES;
    
    self.list.lineCount = 2;
    self.list.animationDuration = 0.25f;

    self.list.whenReloading = ^
    {
        @normalize(self);
        // 已加载，无数据
        if ( [self currentModel].loaded && 0 == [self currentModel].goods.count )
        {
            self.list.lineCount = 1;
            
            self.list.total = 1;
            
            BeeUIScrollItem * item = self.list.items[0];
            item.clazz = [CommonNoResultCell class];
            item.size = self.list.size;
            item.rule = BeeUIScrollLayoutRule_Tile;
        }
        else // 未加载（未加载过时，count=0）或者有数据
        {
            self.list.total = [self currentModel].goods.count;
            
            for ( int i = 0; i < [self currentModel].goods.count; i++ )
            {
                BeeUIScrollItem * item = self.list.items[i];
                item.data = [[self currentModel].goods safeObjectAtIndex:i];
                
                if ( self.currentMode == self.MODE_GRID )
                {
                    self.list.lineCount = 2;
                    
                    item.clazz = [B1_ProductListGridCell_iPhone class];
                    item.size = CGSizeMake( self.list.width / 2, 178 );
                    item.rule = BeeUIScrollLayoutRule_Inject;
                }
                else if ( self.currentMode == self.MODE_LARGE )
                {
                    self.list.lineCount = 1;
                    
                    item.clazz = [B1_ProductListLargeCell_Phone class];
                    item.size = CGSizeMake( self.list.width, 364 );
                    item.rule = BeeUIScrollLayoutRule_Tile;
                }
            }
        }
    };
    self.list.whenHeaderRefresh = ^
    {
        @normalize(self);
        [[self currentModel] firstPage];
    };
    self.list.whenFooterRefresh = ^
    {
        @normalize(self);
        [[self currentModel] nextPage];
    };
    self.list.whenReachBottom = ^
    {
        @normalize(self);
     
        [[self currentModel] nextPage];
    };
    
    [self observeNotification:CartModel.UPDATED];
}

ON_DELETE_VIEWS( signal )
{
    [self unobserveNotification:CartModel.UPDATED];
    
    self.list = nil;
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
//	[self.list reloadData];
	
    [bee.ui.appBoard hideTabbar];
    
    if ( nil == _titleSearch )
    {
		_searchBackground = [[B1_ProductListSearchBackgroundCell_iPhone alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
		[self.view insertSubview:_searchBackground atIndex:self.view.subviews.count];
		
        _titleSearch = [[B1_ProductListSearchBarCell_iPhone alloc] initWithFrame:CGRectZero];
        _titleSearch.frame = CGRectMake(0, 0, self.view.width, 44.0f);
        self.navigationBarTitle = _titleSearch;
    }
    
    [self updateViews];
    
    [[self currentModel] firstPage];
    
    [[CartModel sharedInstance] addObserver:self];
    
    [[CartModel sharedInstance] reload];

}

ON_DID_APPEAR( signal )
{
    [self updateDatas];
	
    [self.list reloadData];
}

ON_WILL_DISAPPEAR( signal )
{
	[CartModel sharedInstance].loaded = NO;
    [[CartModel sharedInstance] removeObserver:self];
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
    D2_FilterBoard_iPhone * board = [D2_FilterBoard_iPhone board];
    board.filter = [self currentModel].filter;
    [self.stack pushBoard:board animated:YES];
}

ON_SIGNAL2( BeeUIBoard, signal )
{
    if ( [signal is:BeeUIBoard.MODALVIEW_DID_HIDDEN] )
	{
		[self.list reloadData];
		[self updateDatas];
	}
}

#pragma mark - BeeUITextField

ON_SIGNAL2( BeeUITextField, signal )
{
	BeeUITextField * textField = (BeeUITextField *)signal.source;
	
	if ( [signal is:BeeUITextField.RETURN] )
	{
		[textField endEditing:YES];
        
        [self doSearch:textField.text];
	}
    
	if ( [signal is:BeeUITextField.WILL_ACTIVE] )
	{
		_searchBackground.hidden = NO;
		[self hideBarButton:BeeUINavigationBar.RIGHT];
		_titleSearch.frame = CGRectMake(0, 0, self.view.width, 44.0f);
	}
	
	if ( [signal is:BeeUITextField.WILL_DEACTIVE] )
	{
		_searchBackground.hidden = YES;
		[self showBarButton:BeeUINavigationBar.RIGHT title:__TEXT(@"filter") image:[UIImage imageNamed:@"nav_right.png"]];
		_titleSearch.frame = CGRectMake(0, 0, self.view.width, 44.0f);
	}

}

#pragma mark - B1_ProductListGridCell_iPhone

/**
 * 商品列表-商品（网格视图模式），点击事件触发时执行的操作
 */
ON_SIGNAL2( B1_ProductListGridCell_iPhone, signal )
{
    SIMPLE_GOODS * goods = signal.sourceCell.data;
	if ( goods )
	{
		B2_ProductDetailBoard_iPhone * board = [B2_ProductDetailBoard_iPhone board];
		board.goodsModel.goods_id = goods.goods_id;
		[self.stack pushBoard:board animated:YES];
	}
}

#pragma mark - B1_ProductListLargeCell_Phone

/**
 * 商品列表-商品（宽屏视图模式），点击事件触发时执行的操作
 */
ON_SIGNAL2( B1_ProductListLargeCell_Phone, signal )
{
    SIMPLE_GOODS * goods = signal.sourceCell.data;
	if ( goods )
	{
		B2_ProductDetailBoard_iPhone * board = [B2_ProductDetailBoard_iPhone board];
		board.goodsModel.goods_id = goods.goods_id;
		[self.stack pushBoard:board animated:YES];
	}
}

#pragma mark - B1_ProductListFilterCell_iPhone

/**
 * 商品列表-TABBAR-人气排行，点击事件触发时执行的操作
 */

ON_SIGNAL3( B1_ProductListFilterCell_iPhone, item_popular_button, signal )
{
	if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
	{
		self.tabIndex = self.TAB_HOT;
		
		[self updateViews];
		[self updateDatas];
	}
}

/**
 * 商品列表-TABBAR-最便宜，点击事件触发时执行的操作
 */
ON_SIGNAL3( B1_ProductListFilterCell_iPhone, item_cheap_button, signal )
{
	if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
	{
		self.tabIndex = self.TAB_CHEAPEST;
		
		[self updateViews];
		[self updateDatas];
	}
}

/**
 * 商品列表-TABBAR-最贵，点击事件触发时执行的操作
 */
ON_SIGNAL3( B1_ProductListFilterCell_iPhone, item_expensive_button, signal )
{
	if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
	{
		self.tabIndex = self.TAB_EXPENSIVE;
		
		[self updateViews];
		[self updateDatas];
	}
}

#pragma mark - B1_ProductListCartCell_iPhone

/**
 * 商品列表-购物车，点击事件触发时执行的操作
 */
ON_SIGNAL3( B1_ProductListCartCell_iPhone, cart, signal )
{
	C0_ShoppingCartBoard_iPhone * board = [C0_ShoppingCartBoard_iPhone board];
	[self.stack pushBoard:board animated:YES];
}

#pragma mark -

- (void)doSearch:(NSString *)keyword
{

//    if ( 0 == keyword.length )
//    {
//		// [self presentFailureTips:@"请输入正确的关键字"];
//        return;
//    }
    
    self.searchByHotModel.filter.keywords = keyword;
    self.searchByCheapestModel.filter.keywords = keyword;
    self.searchByExpensiveModel.filter.keywords = keyword;

    [self updateDatas];
}

- (void)updateViews
{
//    if ( self.MODE_GRID == self.currentMode )
//    {
//        [self showBarButton:BeeUINavigationBar.RIGHT image:[UIImage imageNamed:@"item_graph_header_view_icon.png"]];
//    }
//    else if ( self.MODE_LARGE == self.currentMode )
//    {
//        [self showBarButton:BeeUINavigationBar.RIGHT image:[UIImage imageNamed:@"item_grid_header_view_icon.png"]];
//    }
    
	NSUInteger count = 0;
	
	for ( CART_GOODS * goods in [CartModel sharedInstance].goods )
	{
		count += goods.goods_number.intValue;
	}
	
	self.listcart.data = __INT( count );

	if ( self.TAB_HOT == self.tabIndex )
	{
		[_filter selectTab1];
	}
	else if ( self.TAB_CHEAPEST == self.tabIndex )
	{
		[_filter selectTab2];
	}
	else if ( self.TAB_EXPENSIVE == self.tabIndex )
	{
		[_filter selectTab3];
	}

	$(_titleSearch).FIND( @"#search-input" ).TEXT( [self currentModel].filter.keywords );


    [self.list asyncReloadData];
}

- (void)updateDatas
{
	[[self currentModel] firstPage];
}

#pragma mark -

- (SearchModel *)currentModel
{
	if ( self.TAB_HOT == self.tabIndex )
	{
		return self.searchByHotModel;
	}
	else if ( self.TAB_CHEAPEST == self.tabIndex )
	{
		return self.searchByCheapestModel;
	}
	else if ( self.TAB_EXPENSIVE == self.tabIndex )
	{
		return self.searchByExpensiveModel;
	}
	
	return self.searchByHotModel;
}

#pragma mark -

ON_NOTIFICATION3( CartModel, UPDATED, n )
{
	NSUInteger count = 0;
	
	for ( CART_GOODS * goods in [CartModel sharedInstance].goods )
	{
		count += goods.goods_number.intValue;
	}
	
	self.listcart.data = __INT( count );
}

#pragma mark -

ON_MESSAGE3( API, search, msg )
{
	if ( msg.sending )
	{
		if ( NO == [self currentModel].loaded )
		{
			[self presentLoadingTips:__TEXT(@"tips_loading")];
		}

		[self.list setFooterLoading:([self currentModel].goods.count ? YES : NO)];
	}
	else
	{
		[self.list setHeaderLoading:NO];
		[self.list setFooterLoading:NO];

		[self dismissTips];
	}

	if ( msg.succeed )
	{
		STATUS * status = msg.GET_OUTPUT(@"status");
		
		if ( status && status.succeed.boolValue )
		{
			[self.list setFooterMore:[self currentModel].more];
            
		
			[self.list asyncReloadData];
		}
		else
		{
			[self showErrorTips:msg];
		}
	}
	else if ( msg.failed )
	{
		[self showErrorTips:msg];
	}
}

@end
