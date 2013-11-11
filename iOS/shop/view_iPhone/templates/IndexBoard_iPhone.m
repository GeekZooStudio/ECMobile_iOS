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
	
#import "IndexBoard_iPhone.h"
#import "AppBoard_iPhone.h"
#import "GoodsListBoard_iPhone.h"
#import "GoodsDetailBoard_iPhone.h"
#import "WebViewBoard_iPhone.h"
#import "HelpBoard_iPhone.h"
#import "NotificationBoard_iPhone.h"
#import "Placeholder.h"

#import "CommonFootLoader.h"
#import "CommonPullLoader.h"

#pragma mark -

@interface BannerPhotoCell_iPhone()
{
	BeeUIImageView * _image;
}
@end

#pragma mark -

@implementation BannerPhotoCell_iPhone

DEF_SIGNAL( TOUCHED )

- (void)load
{
    [super load];

	self.tappable = YES;
	self.tapSignal = self.TOUCHED;

	_image = [[BeeUIImageView alloc] init];
    _image.image = [Placeholder image];
	_image.contentMode = UIViewContentModeScaleAspectFill;
	_image.indicatorStyle = UIActivityIndicatorViewStyleGray;
	[self addSubview:_image];
}

- (void)unload
{
	SAFE_RELEASE_SUBVIEW( _image );
	
	[super unload];
}

- (void)layoutDidFinish
{
	_image.frame = self.bounds;
}

- (void)dataDidChanged
{
	BANNER * banner = self.data;
	if ( banner )
	{
		_image.url = banner.photo.largeURL;
	}
}

@end

#pragma mark -

@implementation BannerCell_iPhone

DEF_SIGNAL( TOUCHED )

SUPPORT_RESOURCE_LOADING( YES )

@synthesize scroll = _scroll;
@synthesize pageControl = _pageControl;

- (void)load
{
    [super load];
    
    self.scroll = [[[BeeUIScrollView alloc] init] autorelease];
	self.scroll.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6f];
    self.scroll.dataSource = self;
    self.scroll.horizontal = YES;
    self.scroll.pagingEnabled = YES;
    [self addSubview:self.scroll];
	
	self.pageControl = [[[BeeUIPageControl alloc] init] autorelease];
	self.pageControl.hidesForSinglePage = NO;
//	self.pageControl.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f];
	self.pageControl.layer.cornerRadius = 8.0f;
	self.pageControl.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:1.0f].CGColor;
	self.pageControl.layer.shadowOffset = CGSizeMake( 0.0f, 0.0f );
	self.pageControl.layer.shadowRadius = 0.0f;
	self.pageControl.layer.shadowOpacity = 1.0f;
	[self addSubview:self.pageControl];
}

- (void)unload
{
	self.scroll = nil;
	self.pageControl = nil;
	
	[super unload];
}

- (void)layoutDidFinish
{
    self.scroll.frame = self.bounds;
	[_scroll reloadData];
	
	CGRect controlFrame;
	controlFrame.size.width = 60.0f;
	controlFrame.size.height = 16.0f;
	controlFrame.origin.x = (self.width - controlFrame.size.width) / 2.0f;
	controlFrame.origin.y = self.height - controlFrame.size.height - 5.0f;
	self.pageControl.frame = controlFrame;
}

- (void)dataDidChanged
{
    [self.scroll reloadData];
}

#pragma mark -

ON_SIGNAL2( BeeUIScrollView , signal)
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIScrollView.DID_STOP] )
	{
		NSInteger pageCount = ((NSArray *)self.data).count;
		
		self.pageControl.currentPage = self.scroll.pageIndex;
		self.pageControl.numberOfPages = pageCount;
	}
	else if ( [signal is:BeeUIScrollView.RELOADED] )
	{
		NSInteger pageCount = ((NSArray *)self.data).count;
		
		self.pageControl.currentPage = self.scroll.pageIndex;
		self.pageControl.numberOfPages = pageCount;
	}
}

#pragma mark -

- (NSInteger)numberOfViewsInScrollView:(BeeUIScrollView *)scrollView
{
    return ((NSArray *)self.data).count;
}

- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index scale:(CGFloat)scale
{
	BANNER * banner = [(NSArray *)self.data safeObjectAtIndex:index];
	if ( banner )
	{
		BannerPhotoCell_iPhone * cell = [scrollView dequeueWithContentClass:[BannerPhotoCell_iPhone class]];
		cell.data = banner;
		return cell;
	}
	
	return nil;
}

- (CGSize)scrollView:(BeeUIScrollView *)scrollView sizeForIndex:(NSInteger)index
{
	return scrollView.bounds.size;
}

@end

#pragma mark -

@implementation IndexNotifiCell_iPhone

DEF_SIGNAL( TOUCHED )

SUPPORT_RESOURCE_LOADING( YES )

@end

#pragma mark -

@implementation CategoryCell_iPhone

DEF_SIGNAL( CATEGORY_TOUCHED )
DEF_SIGNAL( GOODS1_TOUCHED )
DEF_SIGNAL( GOODS2_TOUCHED )

SUPPORT_RESOURCE_LOADING( YES )

- (void)load
{
    [super load];
}

- (void)dataDidChanged
{
	CATEGORY * category = self.data;
	if ( category )
	{
		$(@"#category-title").TEXT( category.name );
		
		if ( category.goods.count > 0 )
		{
			SIMPLE_GOODS * goods = [category.goods objectAtIndex:0];
			
			$(@"#category-image").SHOW();
			$(@"#category-image").IMAGE( goods.img.thumbURL );
		}
		else
		{
            $(@"#category-image").HIDE();
//			$(@"#category-image").IMAGE( [Placeholder image] );
		}
		
		if ( category.goods.count > 1 )
		{
			SIMPLE_GOODS * goods = [category.goods objectAtIndex:1];
			
			$(@"#goods-title1").SHOW();
			$(@"#goods-title1").TEXT( goods.name );

			$(@"#goods-price1").SHOW();
			$(@"#goods-price1").TEXT( goods.shop_price );
			
			$(@"#goods-image1").SHOW();
			$(@"#goods-image1").IMAGE( goods.img.thumbURL );
		}
		else
		{
			$(@"#goods-title1").HIDE();
			$(@"#goods-price1").HIDE();
            $(@"#goods-image1").HIDE();
//			$(@"#goods-image1").IMAGE( [Placeholder image] );
		}

		if ( category.goods.count > 2 )
		{
			SIMPLE_GOODS * goods = [category.goods objectAtIndex:2];

			$(@"#goods-title2").SHOW();
			$(@"#goods-title2").TEXT( goods.name );
			
			$(@"#goods-price2").SHOW();
			$(@"#goods-price2").TEXT( goods.shop_price );
			
			$(@"#goods-image2").SHOW();
			$(@"#goods-image2").IMAGE( goods.img.thumbURL );
		}
		else
		{
			$(@"#goods-title2").HIDE();
			$(@"#goods-price2").HIDE();
            $(@"#goods-image2").HIDE();
//			$(@"#goods-image2").IMAGE( [Placeholder image] );
		}
	}
}

ON_SIGNAL3( CategoryCell_iPhone, category, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
        [self sendUISignal:self.CATEGORY_TOUCHED];
    }
}

ON_SIGNAL3( CategoryCell_iPhone, goods1, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
        [self sendUISignal:self.GOODS1_TOUCHED];
    }
}

ON_SIGNAL3( CategoryCell_iPhone, goods2, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
        [self sendUISignal:self.GOODS2_TOUCHED];
    }
}

@end

#pragma mark -

@implementation RecommendCell_iPhone

DEF_SIGNAL( TOUCHED )

SUPPORT_RESOURCE_LOADING( YES )

- (void)dataDidChanged
{
	NSArray * array = self.data;
	
    if ( array.count >= 1 )
	{
		$(@"#goods-1").SHOW();
		$(@"#goods-1").DATA( [array objectAtIndex:0] );
	}
	else
	{
		$(@"#goods-1").HIDE();
	}

    if ( array.count >= 2 )
	{
		$(@"#goods-2").SHOW();
		$(@"#goods-2").DATA( [array objectAtIndex:1] );
	}
	else
	{
		$(@"#goods-2").HIDE();
	}

    if ( array.count >= 3 )
	{
		$(@"#goods-3").SHOW();
		$(@"#goods-3").DATA( [array objectAtIndex:2] );
	}
	else
	{
		$(@"#goods-3").HIDE();
	}

	if ( array.count >= 4 )
	{
		$(@"#goods-4").SHOW();
		$(@"#goods-4").DATA( [array objectAtIndex:3] );
	}
	else
	{
		$(@"#goods-4").HIDE();
	}
}

@end

#pragma mark -

@implementation RecommendGoodsCell_iPhone

DEF_SIGNAL( TOUCHED )

SUPPORT_RESOURCE_LOADING( YES )

- (void)load
{
    self.tappable = YES;
    self.tapSignal = self.TOUCHED;
}

- (void)dataDidChanged
{
	SIMPLE_GOODS * goods = self.data;
	if ( goods )
	{
		$(@"#goods-subprice").TEXT( goods.market_price );
	    $(@"#recommend-goods-price").TEXT( [goods.promote_price empty] ? goods.shop_price : goods.promote_price );
		$(@"#recommend-goods-image").IMAGE( goods.img.thumbURL );
	}
}

@end

@implementation IndexNotifiBarItem_iPhone

SUPPORT_RESOURCE_LOADING( YES )

- (void)dataDidChanged
{
    NSNumber * number = self.data;
    
    if ( number && number.integerValue > 0 )
    {
        $(@"#badge-bg").SHOW();
        $(@"#badge-count").SHOW();
        $(@"#badge-count").TEXT( [NSString stringWithFormat:@"%@", self.data] );
    }
    else
    {
        $(@"#badge-bg").HIDE();
        $(@"#badge-count").HIDE();
    }
}

@end

#pragma mark -

@interface IndexBoard_iPhone()
{
	BeeUIScrollView *	_scroll;
}
@end

#pragma mark -

@implementation IndexBoard_iPhone

@synthesize model1 = _model1;
@synthesize model2 = _model2;
//@synthesize model3 = _model3;

#pragma mark -

- (void)load
{
	[super load];
	
	self.model1 = [[[BannerModel alloc] init] autorelease];
	[self.model1 addObserver:self];

	self.model2 = [[[CategoryModel alloc] init] autorelease];
	[self.model2 addObserver:self];

//	self.model3 = [[[HelpModel alloc] init] autorelease];
//	[self.model3 addObserver:self];

}

- (void)unload
{
	self.model1 = nil;
	self.model2 = nil;
//	self.model3 = nil;

	[super unload];
}

#pragma mark -

ON_SIGNAL2( BeeUIBoard, signal )
{		
    [super handleUISignal_BeeUIBoard:signal];
    
    if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
    {
        [self showNavigationBarAnimated:NO];
		[self setTitleString:__TEXT(@"ecmobile")];

        [self showBarButton:BeeUINavigationBar.RIGHT custom:[IndexNotifiBarItem_iPhone cell]];
        $(self.rightBarButton).FIND(@"#badge-bg, #badge-count").HIDE();
        
		_scroll = [[BeeUIScrollView alloc] init];
		_scroll.dataSource = self;
		_scroll.vertical = YES;
		[_scroll showHeaderLoader:YES animated:NO];
		[self.view addSubview:_scroll];
    }
    else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
    {
        SAFE_RELEASE_SUBVIEW( _scroll );
    }
    else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
    {
        [_scroll setBaseInsets:UIEdgeInsetsMake(0, 0, [AppBoard_iPhone sharedInstance].tabbar.height, 0)];
		_scroll.frame = self.viewBound;
    }
    else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
    {
        [self.model1 loadCache];
		[self.model2 loadCache];
//		[self.model3 loadCache];
    }
    else if ( [signal is:BeeUIBoard.FREE_DATAS] )
    {
    }
    else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
    {
        [[AppBoard_iPhone sharedInstance] setTabbarHidden:NO];
		
		if ( [UserModel online] )
		{
			[[CartModel sharedInstance] fetchFromServer];
		}
    }
    else if ( [signal is:BeeUIBoard.DID_APPEAR] )
    {        
        if ( NO == self.model1.loaded )
		{
			[self.model1 fetchFromServer];
		}
        
		if ( NO == self.model2.loaded )
		{
			[self.model2 fetchFromServer];
		}
        
//		if ( NO == self.model3.loaded )
//		{
//			[self.model3 fetchFromServer];
//		}
        
        [_scroll reloadData];
        
    }
    else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
    {
    }
    else if ( [signal is:BeeUIBoard.DID_DISAPPEAR] )
    {
        [[AppBoard_iPhone sharedInstance] setTabbarHidden:YES];
    }
    else if ( [signal is:BeeUIBoard.ORIENTATION_WILL_CHANGE] )
    {
    }
    else if ( [signal is:BeeUIBoard.ORIENTATION_DID_CHANGED] )
    {
    }
}

ON_SIGNAL2( BeeUINavigationBar, signal )
{
	[super handleUISignal:signal];
    
	if ( [signal is:BeeUINavigationBar.RIGHT_TOUCHED] )
	{
        [self.stack pushBoard:[NotificationBoard_iPhone board] animated:YES];
	}
}

ON_SIGNAL2( BeeUIScrollView, signal )
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIScrollView.HEADER_REFRESH] )
	{
		[self.model1 fetchFromServer];
		[self.model2 fetchFromServer];
        
//		if ( NO == self.model3.loaded )
//		{
//			[self.model3 fetchFromServer];
//		}
		
		[[CartModel sharedInstance] fetchFromServer];
	}
}

ON_SIGNAL2( BannerPhotoCell_iPhone, signal )
{	
	[super handleUISignal:signal];
	
    BANNER * banner = signal.sourceCell.data;

    // TODO: for test to be removed
//    banner.action = BANNER_ACTION_GOODS;
//    banner.action_id = @(33);

//    banner.action = BANNER_ACTION_CATEGORY;
//    banner.action_id = @(1);

//    banner.action = BANNER_ACTION_BRAND;
//    banner.action_id = @();
    
	if ( banner )
	{
        if ( [banner.action isEqualToString:BANNER_ACTION_GOODS] )
        {
            GoodsDetailBoard_iPhone * board = [GoodsDetailBoard_iPhone board];
            board.goodsModel.goods_id = banner.action_id;
            [self.stack pushBoard:board animated:YES];
        }
        else if ( [banner.action isEqualToString:BANNER_ACTION_BRAND] )
        {
            GoodsListBoard_iPhone * board = [GoodsListBoard_iPhone board];
            board.model1.filter.brand_id = banner.action_id;
            board.model2.filter.brand_id = banner.action_id;
            board.model3.filter.brand_id = banner.action_id;
            [self.stack pushBoard:board animated:YES];
        }
        else if ( [banner.action isEqualToString:BANNER_ACTION_CATEGORY] )
        {
            GoodsListBoard_iPhone * board = [GoodsListBoard_iPhone board];
			board.category = banner.description;
            board.model1.filter.category_id = banner.action_id;
            board.model2.filter.category_id = banner.action_id;
            board.model3.filter.category_id = banner.action_id;
            [self.stack pushBoard:board animated:YES];
        }
        else
        {
            WebViewBoard_iPhone * board = [[[WebViewBoard_iPhone alloc] init] autorelease];
            board.defaultTitle = banner.description.length ? banner.description : __TEXT(@"new_activity");
            board.urlString = banner.url;
            [self.stack pushBoard:board animated:YES];
        }
	}
}

ON_SIGNAL2( CategoryCell_iPhone, signal )
{	
	[super handleUISignal:signal];
	
	CATEGORY * category = signal.sourceCell.data;
    
    if ( category )
	{
        if ( [signal is:CategoryCell_iPhone.CATEGORY_TOUCHED] )
        {
            GoodsListBoard_iPhone * board = [GoodsListBoard_iPhone board];
			board.category = category.name;
            board.model1.filter.category_id = category.id;
            board.model2.filter.category_id = category.id;
            board.model3.filter.category_id = category.id;
            [self.stack pushBoard:board animated:YES];
        }
        else if ( [signal is:CategoryCell_iPhone.GOODS1_TOUCHED] )
        {
            SIMPLE_GOODS * goods = [category.goods safeObjectAtIndex:1];
            
            if ( goods )
            {
                GoodsDetailBoard_iPhone * board = [GoodsDetailBoard_iPhone board];
                board.goodsModel.goods_id = goods.id;
                [self.stack pushBoard:board animated:YES];
            }
        }
        else if ( [signal is:CategoryCell_iPhone.GOODS2_TOUCHED] )
        {
            SIMPLE_GOODS * goods = [category.goods safeObjectAtIndex:2];
            
            if ( goods )
            {
                GoodsDetailBoard_iPhone * board = [GoodsDetailBoard_iPhone board];
                board.goodsModel.goods_id = goods.id;
                [self.stack pushBoard:board animated:YES];
            }
        }
    }
}

ON_SIGNAL2( RecommendGoodsCell_iPhone, signal )
{	
	[super handleUISignal:signal];
	
    SIMPLE_GOODS * goods = signal.sourceCell.data;
	if ( goods )
	{
	    GoodsDetailBoard_iPhone * board = [GoodsDetailBoard_iPhone board];
		board.goodsModel.goods_id = goods.id;
		[self.stack pushBoard:board animated:YES];	
	}
}

ON_SIGNAL3( IndexNotifiBarItem_iPhone, notify, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE ] )
    {
        [self.stack pushBoard:[NotificationBoard_iPhone board] animated:YES];
    }
}

#pragma mark -

- (void)handleMessage:(BeeMessage *)msg
{
	if ( [msg is:API.home_data] )
	{
		if ( msg.sending )
		{
			if ( NO == self.model1.loaded )
			{
//				[self presentLoadingTips:__TEXT(@"tips_loading")];
			}
			else
			{
				[_scroll setHeaderLoading:YES];
			}
		}
		else
		{
			[_scroll setHeaderLoading:NO];

			[self dismissTips];
		}

		if ( msg.succeed )
		{
			[_scroll asyncReloadData];
		}
		else if ( msg.failed )
		{
			[ErrorMsg presentErrorMsg:msg inBoard:self];
		}
	}
	else if ( [msg is:API.home_category] )
	{
		if ( msg.sending )
		{
			if ( NO == self.model2.loaded )
			{
//				[self presentLoadingTips:__TEXT(@"tips_loading")];
			}
			else
			{
				[_scroll setHeaderLoading:YES];
			}
		}
		else
		{
			[_scroll setHeaderLoading:NO];
			
			[self dismissTips];
		}
		
		if ( msg.succeed )
		{
			[_scroll asyncReloadData];
		}
		else if ( msg.failed )
		{
			[ErrorMsg presentErrorMsg:msg inBoard:self];
		}
	}
}

#pragma mark -

- (NSInteger)numberOfViewsInScrollView:(BeeUIScrollView *)scrollView
{
	NSUInteger row = 0;

	row += 1;
	row += self.model1.goods.count ? 1 : 0;
	row += self.model2.categories.count;

	return row;
}

- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index scale:(CGFloat)scale
{
	NSUInteger section = 0;
	
	section += 1;
	if ( index < section )
	{		
		BeeUICell * cell = [scrollView dequeueWithContentClass:[BannerCell_iPhone class]];
        cell.data = self.model1.banners;
		return cell;
	}

	section += self.model1.goods.count ? 1 : 0;
	if ( index < section )
	{
		BeeUICell * cell = [scrollView dequeueWithContentClass:[RecommendCell_iPhone class]];
        cell.data = self.model1.goods;
		return cell;
	}

	section += self.model2.categories.count;
	if ( index < section )
	{
		BeeUICell * cell = [scrollView dequeueWithContentClass:[CategoryCell_iPhone class]];
        cell.data = [self.model2.categories safeObjectAtIndex:(self.model2.categories.count - (section - index))];
		return cell;
	}

    return nil;
}

- (CGSize)scrollView:(BeeUIScrollView *)scrollView sizeForIndex:(NSInteger)index
{
	NSUInteger section = 0;
	
	section += 1;
	if ( index < section )
	{
		return CGSizeMake( scrollView.width, 150.0f );
	}

	section += self.model1.goods.count ? 1 : 0;
	if ( index < section )
	{
		return [RecommendCell_iPhone estimateUISizeByWidth:scrollView.width forData:self.model1.goods];
	}
	
	section += self.model2.categories.count;
	if ( index < section )
	{
		id data = [self.model2.categories safeObjectAtIndex:(self.model2.categories.count - (section - index))];
		return [CategoryCell_iPhone estimateUISizeByWidth:scrollView.width forData:data];
	}
	
    return CGSizeZero;
}

@end
