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

#import "AdvancedSearchBoard_iPhone.h"
#import "GoodsListBoard_iPhone.h"
#import "ErrorMsg.h"
#import "UITagList.h"
#import "NSObject+TagList.h"

#pragma mark -

@interface AdvancedSearchCell_iPhone()
@property (nonatomic, retain) UITagList * taglist;
@end

@implementation AdvancedSearchCell_iPhone

SUPPORT_RESOURCE_LOADING( YES );
SUPPORT_AUTOMATIC_LAYOUT( YES );

+ (CGSize)estimateUISizeByWidth:(CGFloat)width forData:(id)data expaned:(BOOL)expaned
{
    if ( expaned )
    {
        CGSize size = [AdvancedSearchCell_iPhone estimateUISizeByWidth:width forData:data];
        return size;
    }
    else
    {
        return CGSizeMake( width, 60.0f );
    }
}

- (void)load
{
    [super load];
    
    UIImage * imageNoraml = [[UIImage imageNamed:@"item-info-buy-kinds-btn-grey.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 20, 5, 30)];
    UIImage * imageSelected = [[UIImage imageNamed:@"item-info-buy-kinds-active-btn.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 20, 5, 30)];

    _taglist = (UITagList *)$(@"#taglist").view;
    _taglist.isRadio = YES;
    _taglist.normalImage = imageNoraml;
    _taglist.selectedImage = imageSelected;
}

- (void)dataDidChanged
{
    if ( self.data )
    {
        $(@"#taglist").DATA( self.data );
        self.expaned = YES;
    }
    else
    {
        self.expaned = NO;
    }
}

- (void)setCellTitle:(NSString *)cellTitle
{
    [_cellTitle release];
    _cellTitle = [cellTitle retain];
    
    $(@"#title").DATA( _cellTitle );
}

- (void)layoutDidFinish
{
    // TODO: better way to implemente this
    self.expaned = _expaned;
}

ON_SIGNAL3( AdvancedSearchCell_iPhone, toggle, signal )
{
    [super handleUISignal:signal];
}

- (void)setExpaned:(BOOL)expaned
{
    _expaned = expaned;
    
    if ( _expaned )
    {
        $(@"#taglist").SHOW();
        $(@"#indictor").REMOVE_CLASS( @"active" );
        $(@"#indictor").ADD_CLASS( @"normal" );
    }
    else
    {
        $(@"#taglist").HIDE();
        $(@"#indictor").REMOVE_CLASS( @"normal" );
        $(@"#indictor").ADD_CLASS( @"active" );
    }
}

@end

#pragma mark -

@interface AdvancedSearchBoard_iPhone()
{
	BeeUIScrollView *       _scroll;
    NSMutableDictionary *   _expanedState;
    
    FILTER *                _tempFilter;
}
@end

@implementation AdvancedSearchBoard_iPhone

SUPPORT_RESOURCE_LOADING( NO );
SUPPORT_AUTOMATIC_LAYOUT( NO );

- (void)load
{
	[super load];
    
	self.brandModel = [[[BrandModel alloc] init] autorelease];
    [self.brandModel addObserver:self];

    self.categoryModel = [[[CategoryModel alloc] init] autorelease];
    [self.categoryModel addObserver:self];
	
    self.rangeModel = [[[PriceRangeModel alloc] init] autorelease];
    [self.rangeModel addObserver:self];
    
    _expanedState = [[NSMutableDictionary alloc] initWithCapacity:3];
}

- (void)unload
{
    [self.brandModel removeObserver:self];
    self.brandModel = nil;

    [self.categoryModel removeObserver:self];
    self.categoryModel = nil;

    [self.rangeModel removeObserver:self];
    self.rangeModel = nil;
    
    [_expanedState removeAllObjects];
    [_expanedState release];
    
	[super unload];
}

- (BOOL)shouldShowCategory
{
    return  self.filter && self.filter.category_id == nil;
}

#pragma mark Signal

ON_SIGNAL2( BeeUIBoard, signal )
{
    [super handleUISignal:signal];

    if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
    {
        self.view.backgroundColor = [UIColor whiteColor];
        [self showNavigationBarAnimated:NO];

        self.titleString = __TEXT(@"filter");
        [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav-back.png"]];
        [self showBarButton:BeeUINavigationBar.RIGHT title:__TEXT(@"collect_done") image:[UIImage imageNamed:@"nav-right.png"]];

        _scroll = [[BeeUIScrollView alloc] init];
		_scroll.dataSource = self;
		_scroll.vertical = YES;
		[self.view addSubview:_scroll];
        
        _tempFilter = [[FILTER alloc] init];
    }
    else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
    {
        [_tempFilter release];
        _tempFilter = nil;
        
        SAFE_RELEASE_SUBVIEW( _scroll );
    }
    else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
    {
        _scroll.frame = self.viewBound;
    }
    else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
    {
//        [self.brandModel loadCache];
//        [self.categoryModel loadCache];
//        [self.rangeModel loadCache];
        
        _tempFilter.brand_id = self.filter.brand_id;
        _tempFilter.category_id = self.filter.category_id;
        _tempFilter.price_range = self.filter.price_range;
    }
    else if ( [signal is:BeeUIBoard.FREE_DATAS] )
    {
    }
    else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
    {
        if ( self.filter.category_id == nil )
        {
            if ( NO == self.categoryModel.loaded )
            {
                [self.categoryModel fetchFromServer];
            }
        }
        else
        {
            self.brandModel.category_id = self.filter.category_id;
            self.rangeModel.category_id = self.filter.category_id;
        }
        
        if ( NO == self.brandModel.loaded )
        {
            [self.brandModel fetchFromServer];
        }

        if ( NO == self.rangeModel.loaded )
        {
            [self.rangeModel fetchFromServer];
        }
    }
    else if ( [signal is:BeeUIBoard.DID_APPEAR] )
    {
        [self expandSearchCell];
    }
    else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
    {
    }
    else if ( [signal is:BeeUIBoard.DID_DISAPPEAR] )
    {
    }
}

ON_SIGNAL2( BeeUINavigationBar, signal )
{
	if ( [signal is:BeeUINavigationBar.LEFT_TOUCHED] )
	{
		[self.stack popBoardAnimated:YES];
//        [self.parentBoard dismissModalStackAnimated:YES];
	}
	else if ( [signal is:BeeUINavigationBar.RIGHT_TOUCHED] )
	{
//        GoodsListBoard_iPhone * board = (GoodsListBoard_iPhone *)self.parentBoard;
        GoodsListBoard_iPhone * board = (GoodsListBoard_iPhone *)self.previousBoard;
        [board.model1 setValueWithFilter:_tempFilter];
        [board.model2 setValueWithFilter:_tempFilter];
        [board.model3 setValueWithFilter:_tempFilter];
		
		[self.stack popBoardAnimated:YES];
//        [self.parentBoard dismissModalStackAnimated:YES];
	}
}

ON_SIGNAL3( AdvancedSearchCell_iPhone, toggle, signal )
{
    if ( [signal is:[BeeUIButton TOUCH_UP_INSIDE]] )
    {
        AdvancedSearchCell_iPhone * cell = (AdvancedSearchCell_iPhone *)signal.sourceCell;
        
        if ( nil == cell.data  )
        {
            return;
        }
        
        BOOL expaned = [[_expanedState objectForKey:cell.indexKey] boolValue];
        expaned = !expaned;
        [_expanedState setObject:@(expaned) forKey:cell.indexKey];
        [_scroll reloadData];
    }
}

ON_SIGNAL3( UITagListCell, button, signal )
{
    [super handleUISignal:signal];
    
    UITagListCell * cell = (UITagListCell *)signal.sourceCell;
    
    if ( [signal is:[BeeUIButton TOUCH_UP_INSIDE]] )
    {
        if ( [cell.data isKindOfClass:[BRAND class]] )
        {
            _tempFilter.brand_id = ((BRAND *)cell.data).brand_id;
        }
        else if ( [cell.data isKindOfClass:[CATEGORY class]] )
        {
            _tempFilter.category_id = ((CATEGORY *)cell.data).id;
            
            if ( nil == self.filter.category_id )
            {
                self.rangeModel.category_id = ((CATEGORY *)cell.data).id;
                [self.rangeModel fetchFromServer];
            }
        }
        else if ( [cell.data isKindOfClass:[PRICE_RANGE class]] )
        {
            _tempFilter.price_range = (PRICE_RANGE *)cell.data;
        }
    }
}

- (void)expandSearchCell
{
    if ( self.brandModel.brands && self.brandModel.brands.count )
    {
        [_expanedState setObject:@(YES) forKey:@"brand"];
    }
    else
    {
        [_expanedState setObject:@(NO) forKey:@"brand"];
    }
    
    if ( self.categoryModel.categories && self.categoryModel.categories.count )
    {
        [_expanedState setObject:@(YES) forKey:@"category"];
    }
    else
    {
        [_expanedState setObject:@(NO) forKey:@"category"];
    }

    if ( self.rangeModel.price_ranges && self.rangeModel.price_ranges.count )
    {
        [_expanedState setObject:@(YES) forKey:@"range"];
    }
    else
    {
        [_expanedState setObject:@(NO) forKey:@"range"];
    }
    
    [_scroll reloadData];
}

#pragma mark -

- (void)handleMessage:(BeeMessage *)msg
{
    [super handleMessage:msg];
    
    if ( msg.sending )
    {
        [self presentLoadingTips:__TEXT(@"tips_loading")];
    }
    else if ( msg.failed )
    {
        [ErrorMsg presentErrorMsg:msg inBoard:self];
    }
    else
    {
        [self dismissTips];
    }
    
    if ( [msg is:API.home_category] )
    {
        if ( msg.succeed )
        {
            [_scroll asyncReloadData];
            [self expandSearchCell];
        }
        
    }
    else if ( [msg is:API.brand] )
	{
		if ( msg.succeed )
		{
			[_scroll asyncReloadData];
            [self expandSearchCell];
		}
    }
    else if ( [msg is:API.price_range] )
    {
        if ( msg.succeed )
		{
			[_scroll asyncReloadData];
            [self expandSearchCell];
		}
    }
}

#pragma mark -

- (NSInteger)numberOfLinesInScrollView:(BeeUIScrollView *)scrollView
{
	return 1;
}

- (NSInteger)numberOfViewsInScrollView:(BeeUIScrollView *)scrollView
{
    NSUInteger row = 0;
    
	row += self.brandModel.brands.count ? 1 : 0;
    
    if ( self.filter.category_id == nil )
    {
        row += self.categoryModel.categories.count ? 1 : 0;
    }
    
    row += self.rangeModel.price_ranges.count ? 1 : 0;
    
	return row;
}

- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index scale:(CGFloat)scale
{
    NSUInteger section = 0;
	
    AdvancedSearchCell_iPhone * cell = [scrollView dequeueWithContentClass:[AdvancedSearchCell_iPhone class]];
    
	section += self.brandModel.brands.count ? 1 : 0;
    if ( index < section )
	{
        cell.data       = self.brandModel.brands;
        cell.indexKey   = @"brand";
        cell.cellTitle  = __TEXT(@"brand");
        
        if ( nil == _expanedState[cell.indexKey] )
        {
            cell.expaned = ( nil != cell.data );
            [_expanedState setObject:@(cell.expaned) forKey:cell.indexKey];
        }
        else
        {
            cell.expaned = [_expanedState[cell.indexKey] boolValue];
        }
        
        if ( _tempFilter.brand_id )
        {
            cell.taglist.selectedTags = @[_tempFilter.brand_id];
        }
        
        return cell;
	}
	
    if ( self.filter.category_id == nil )
    {
        section += self.categoryModel.categories.count ? 1 : 0;
        
        if ( index < section )
        {
            cell.data       = self.categoryModel.categories;
            cell.indexKey   = @"category";
            cell.cellTitle  = __TEXT(@"category");
            
            if ( nil == _expanedState[cell.indexKey] )
            {
                cell.expaned = ( nil != cell.data );
                [_expanedState setObject:@(cell.expaned) forKey:cell.indexKey];
            }
            else
            {
                cell.expaned = [_expanedState[cell.indexKey] boolValue];
            }
            
            if ( _tempFilter.category_id )
            {
                cell.taglist.selectedTags = @[_tempFilter.category_id];
            }
            return cell;
        }
    }
    
    section += self.rangeModel.price_ranges.count ? 1 : 0;
    
    if ( index < section )
    {
        cell.data       = self.rangeModel.price_ranges;
        cell.indexKey   = @"range";
        cell.cellTitle  = __TEXT(@"price_range");
        
        if ( nil == _expanedState[cell.indexKey] )
        {
            cell.expaned = ( nil != cell.data );
            [_expanedState setObject:@(cell.expaned) forKey:cell.indexKey];
        }
        else
        {
            cell.expaned = [_expanedState[cell.indexKey] boolValue];
        }
        
        if ( _tempFilter.price_range )
        {
            cell.taglist.selectedTags = @[_tempFilter.price_range.tagRecipt];
        }
        
        return cell;
    }

    return nil;
}

- (CGSize)scrollView:(BeeUIScrollView *)scrollView sizeForIndex:(NSInteger)index
{
    CGSize size = CGSizeZero;
    
    NSUInteger section = 0;
    
	section += self.brandModel.brands.count ? 1 : 0;
    
    if ( index < section )
	{
        BOOL expaned = [[_expanedState objectForKey:@"brand"] boolValue];
        size = [AdvancedSearchCell_iPhone estimateUISizeByWidth:scrollView.width forData:self.brandModel.brands expaned:expaned];
        return size;
	}
	
    if ( self.filter.category_id == nil )
    {
        section += self.categoryModel.categories.count ? 1 : 0;
        
        if ( index < section )
        {
            BOOL expaned = [[_expanedState objectForKey:@"category"] boolValue];
            size = [AdvancedSearchCell_iPhone estimateUISizeByWidth:scrollView.width forData:self.categoryModel.categories expaned:expaned];
            return size;
        }
    }
    
    section += self.rangeModel.price_ranges.count ? 1 : 0;
    
    if ( index < section )
    {
        BOOL expaned = [[_expanedState objectForKey:@"range"] boolValue];
        size = [AdvancedSearchCell_iPhone estimateUISizeByWidth:scrollView.width forData:self.rangeModel.price_ranges expaned:expaned];
        return size;
    }
    
	return size;
}

@end
