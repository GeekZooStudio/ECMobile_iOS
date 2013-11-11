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

#import "GoodsDetailBoard_iPhone.h"
#import "AppBoard_iPhone.h"
#import "WebViewBoard_iPhone.h"
#import "CartBoard_iPhone.h"
#import "SlideBoard_iPhone.h"
#import "GoodsCommentBoard_iPhone.h"
#import "GoodsPropertyBoard_iPhone.h"
#import "GoodsEntryBoard_iPhone.h"
#import "GoodsSpecifyBoard_iPhone.h"
#import "GoodsSpecifyBoard_iPhone.h"
#import "ShareBoard_iPhone.h"
#import "Placeholder.h"

@implementation GoodsDetailTab_iPhone

SUPPORT_RESOURCE_LOADING( YES )

- (void)load
{
	$(@"#badge-bg").HIDE();
	$(@"#badge").HIDE();
}

- (void)unload
{
    [super unload];
}

- (void)dataDidChanged
{
	NSNumber * count = self.data;
	
	if ( count && count.intValue > 0 )
	{
		$(@"#badge-bg").SHOW();
		$(@"#badge").SHOW().DATA( count );
	}
	else
	{
		$(@"#badge-bg").HIDE();
		$(@"#badge").HIDE();
	}
}

@end

@implementation GoodsDetailSlide_iPhone

DEF_SIGNAL( TOUCHED )

SUPPORT_RESOURCE_LOADING( YES )

- (void)load
{
    [super load];

    self.tappable = YES;
    self.tapSignal = self.TOUCHED;
}

- (void)dataDidChanged
{
    if ( self.data )
    {
        PHOTO * photo = self.data;
        
        $(@"#slide-image").IMAGE( photo.thumbURL );
    }
}

ON_SIGNAL2( BeeUIImageView, signal )
{
    [super handleUISignal:signal];

    if ( [signal is:BeeUIImageView.LOAD_FAILED] )
    {
        $(@"#slide-image").IMAGE( [Placeholder image] );
    }
}

@end

#pragma mark -

@interface GoodsDetailCell_iPhone()
{
    BeeUIPageControl *	_pageControl;
    BeeUIScrollView *   _slideScroll;
    NSArray *           _datas;
}
@end

@implementation GoodsDetailCell_iPhone

SUPPORT_RESOURCE_LOADING( YES )

- (void)load
{
    [super load];
    
    _slideScroll = (BeeUIScrollView *)$(@"goods-slide").view;
    _slideScroll.dataSource = self;
    _slideScroll.horizontal = YES;
    
    _pageControl = (BeeUIPageControl *)$(@"goods-pagectrl").view;
	_pageControl.hidesForSinglePage = NO;
	_pageControl.backgroundColor = HEX_RGBA(0x000, 0.8);
	_pageControl.layer.cornerRadius = 8.0f;
}

- (void)unload
{
    [super unload];
}

- (void)dataDidChanged
{
    GoodsModel * goodsModel = [self.data objectForKey:@"goodsModel"];
    
    if ( goodsModel )
    {
        // name
        $(@"#goods-title").TEXT( goodsModel.goods.goods_name );
        
        // price
        if ( goodsModel.goods.promote_price.length && goodsModel.goods.promote_price.integerValue )
        {
            $(@"#goods-price").TEXT( goodsModel.goods.formated_promote_price );
        }
        else
        {
            $(@"#goods-price").TEXT( goodsModel.goods.shop_price );
        }

		$(@"#goods-subprice").TEXT( goodsModel.goods.market_price );

        // pictures
        if ( goodsModel.goods.pictures && goodsModel.goods.pictures.count > 0 )
        {
            _datas = goodsModel.goods.pictures;
            
//            [_slideScroll reloadData];
        }
        else
        {
            $(@"#goods-slide").HIDE();
            $(@"#goods-pagectrl").HIDE();
        }

		// info
		NSMutableString * goodsInfo = [NSMutableString string];
		goodsInfo
		.LINE( @"%@: %@", __TEXT(@"shipping_fee"), goodsModel.goods.is_shipping.boolValue ?  __TEXT(@"shipping_fee_free") : __TEXT(@"shipping_fee_notfree") )
		.LINE( @"%@: %@", __TEXT(@"remain"), goodsModel.goods.goods_number )
		.LINE( @"%@: %@", __TEXT(@"shop_price"), goodsModel.goods.shop_price )
		.LINE( @"%@: %@", __TEXT(@"market_price"), goodsModel.goods.market_price );

		for ( GOOD_RANK_PRICE * price in goodsModel.goods.rank_prices )
		{
			goodsInfo.LINE( @"%@ %@: %@", price.rank_name, __TEXT(@"price"), price.price );
		}

        $(@"#goods-info").TEXT( goodsInfo );
        
        if ( goodsModel.goods.promote_end_date )
        {
            NSDate * endDate = [goodsModel.goods.promote_end_date asNSDate];
            
            if ( NSOrderedDescending == [endDate compare:[NSDate date]] )
            {
                $(@"#countdown").SHOW();
                $(@"#countdown").DATA( endDate );
            }
            else
            {
                $(@"#countdown").HIDE();
            }
        }
        else
        {
            $(@"#countdown").HIDE();
        }
        
        NSArray * specs = [self.data objectForKey:@"specs"];
        NSNumber * count = [self.data objectForKey:@"count"];
        
        if ( specs || count )
        {
            $(@"#specification").SHOW();

            [self updateSpec:specs count:count];
        }
        else
        {
            $(@"#specification").HIDE();
        }
    }
}

- (void)updateSpec:(NSArray *)specs count:(NSNumber *)count
{
    NSMutableString * string = [NSMutableString string];
    
    for ( GOOD_SPEC_VALUE * spec_value in specs )
    {
        [string appendFormat:@"%@: %@\n", spec_value.spec.name, spec_value.value.label];
    }
    
    [string appendFormat:@"%@: %@", __TEXT(@"amount"), count];
    
    if ( [string notEmpty] )
    {
        $(@"#specification-bg").SHOW();
        $(@"#specification-indictor").SHOW();
        $(@"#specification-title").DATA(string);
    }
    else
    {
        $(@"#specification-bg").HIDE();
        $(@"#specification-indictor").HIDE();
        $(@"#specification-title").HIDE();
    }
}

ON_SIGNAL2( BeeUIScrollView, signal )
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIScrollView.DID_STOP] ||
         [signal is:BeeUIScrollView.RELOADED] ||
         [signal is:BeeUIScrollView.DID_DRAG] ||
         [signal is:BeeUIScrollView.DID_SCROLL] )
	{
		NSInteger pageCount = _datas.count;
		
		_pageControl.currentPage = ( _slideScroll.contentOffset.x ) / 104;
        _pageControl.numberOfPages = pageCount;
	}
}

#pragma mark -

- (NSInteger)numberOfLinesInScrollView:(BeeUIScrollView *)scrollView
{
	return 1;
}

- (NSInteger)numberOfViewsInScrollView:(BeeUIScrollView *)scrollView
{
    return _datas.count;
}

- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index scale:(CGFloat)scale
{
	GoodsDetailSlide_iPhone * cell = [scrollView dequeueWithContentClass:[GoodsDetailSlide_iPhone class]];
	cell.data = [_datas objectAtIndex:index];
	return cell;
}

- (CGSize)scrollView:(BeeUIScrollView *)scrollView sizeForIndex:(NSInteger)index
{
    id data = [_datas objectAtIndex:index];
    return [GoodsDetailSlide_iPhone estimateUISizeByWidth:scrollView.width forData:data];
}

@end

#pragma mark -

@interface GoodsDetailBoard_iPhone()
@end

@implementation GoodsDetailBoard_iPhone

DEF_INT( ACTION_ADD,    1)
DEF_INT( ACTION_BUY,    2)
DEF_INT( ACTION_SPEC,   3)

@synthesize action = _action;
@synthesize cartModel = _cartModel;
@synthesize collectionModel = _collectionModel;
@synthesize goodsModel = _goodsModel;

- (void)load
{
    [super load];
    
	self.cartModel = [CartModel sharedInstance];
	[self.cartModel addObserver:self];

	self.collectionModel = [CollectionModel sharedInstance];
	[self.collectionModel addObserver:self];
    
    self.goodsModel = [[[GoodsModel alloc] init] autorelease];
    [self.goodsModel addObserver:self];
    
    self.specs = [NSMutableArray array];
    self.count = @(1);
}

- (void)unload
{
    self.specs = nil;
    
    [self.goodsModel removeObserver:self];
    self.goodsModel = nil;

	[self.collectionModel removeObserver:self];
    self.collectionModel = nil;

	[self.cartModel removeObserver:self];
    self.cartModel = nil;
    
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [super unload];
}

#pragma mark -

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal_BeeUIBoard:signal];
    
    if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
    {
        self.titleString = __TEXT(@"gooddetail_product");
        [self showNavigationBarAnimated:YES];
        
        [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav-back.png"]];
        [self showBarButton:BeeUINavigationBar.RIGHT image:[UIImage imageNamed:@"item-info-header-share-icon.png"]];

		_scroll = [[[BeeUIScrollView alloc] init] autorelease];
        _scroll.dataSource = self;
		_scroll.baseInsets = UIEdgeInsetsMake(0, 0, 20.0f, 0);
		[_scroll showHeaderLoader:YES animated:NO];
        [self.view addSubview:_scroll];
        
        _tabbar = [[[GoodsDetailTab_iPhone alloc] init] autorelease];
        [self.view addSubview:_tabbar];
        
		[self.cartModel clearCache];
		
		[self observeNotification:CartModel.UPDATED];
    }
    else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
    {
		[self unobserveAllNotifications];
    }
    else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
    {
        _tabbar.frame = CGRectMake(0, self.view.height - 44, self.view.width, 44);
		_scroll.frame = CGRectMake(0, 0, self.width, self.height - 44);
    }
    else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
    {
        [self.goodsModel loadCache];
    }
    else if ( [signal is:BeeUIBoard.FREE_DATAS] )
    {
    }
    else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
    {
        if ( NO == self.goodsModel.loaded )
		{
			[self.goodsModel update];
		}

		[self.cartModel fetchFromServer];

		[[AppBoard_iPhone sharedInstance] setTabbarHidden:YES];
		
        [_scroll asyncReloadData];
    }
    else if ( [signal is:BeeUIBoard.DID_APPEAR] )
    {
        
    }
    else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
    {
    }
    else if ( [signal is:BeeUIBoard.MODALVIEW_DID_HIDDEN] )
    {
        if ( 0 == self.action )
        {
            [self addToCart:self.ACTION_SPEC];
        }
        else
        {
            [self addToCart:self.action];
        }
    }
}

ON_SIGNAL2( BeeUINavigationBar, signal )
{
	[super handleUISignal:signal];

    if ( [signal is:BeeUINavigationBar.LEFT_TOUCHED] )
    {
        [self.stack popBoardAnimated:YES];
    }
    else if ( [signal is:BeeUINavigationBar.RIGHT_TOUCHED] )
    {
		BeeUIActionSheet * sheet = [BeeUIActionSheet spawn];
		[sheet addButtonTitle:__TEXT(@"share_sina") signal:ShareBoard_iPhone.SHARE_TO_SINA];
		[sheet addButtonTitle:__TEXT(@"share_tencent") signal:ShareBoard_iPhone.SHARE_TO_TENCENT];
        [sheet addButtonTitle:__TEXT(@"share_weixin") signal:ShareBoard_iPhone.SHARE_TO_WEIXIN_FRIEND];
        [sheet addButtonTitle:__TEXT(@"share_weixin_timeline") signal:ShareBoard_iPhone.SHARE_TO_WEIXIN_TIMELINE];
		[sheet addCancelTitle:__TEXT(@"button_cancel")];
		[sheet showInViewController:self];
    }
}

ON_SIGNAL2( ShareBoard_iPhone, signal)
{
    // for share
//    NSString * text = __TEXT(@"share_blog");
//    NSString * imageUrl = self.goodsModel.goods.img.thumb;
//    NSObject * image = [[BeeImageCache sharedInstance] imageForURL:imageUrl];

//    if ( nil == image )
//    {
//        image = imageUrl;
//    }
//
//    NSString * title = self.goodsModel.goods.goods_name;
//    NSString * thumb = self.goodsModel.goods.img.thumb;

    if ( [signal is:ShareBoard_iPhone.SHARE_TO_SINA] )
	{
	}
	else if ( [signal is:ShareBoard_iPhone.SHARE_TO_TENCENT] )
	{
	}
    else if ( [signal is:ShareBoard_iPhone.SHARE_TO_WEIXIN_FRIEND] )
	{
	}
    else if ( [signal is:ShareBoard_iPhone.SHARE_TO_WEIXIN_TIMELINE] )
	{
	}
}

ON_SIGNAL2( BeeUIScrollView, signal )
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIScrollView.HEADER_REFRESH] )
	{
		[self.goodsModel update];
	}
}

ON_SIGNAL2( GoodsDetailSlide_iPhone, signal)
{
	PHOTO * photo = signal.sourceCell.data;

    SlideBoard_iPhone * board = [SlideBoard_iPhone board];
    board.goods = self.goodsModel.goods;
	board.pageIndex = [self.goodsModel.goods.pictures indexOfObject:photo];
    [self.stack pushBoard:board animated:YES];
}

ON_SIGNAL3( GoodsDetailCell_iPhone, specify, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
        self.action = self.ACTION_SPEC;

        [self showSpecifyBoard];
    }
}

ON_SIGNAL3( GoodsDetailCell_iPhone, property, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
        GoodsPropertyBoard_iPhone * board = [GoodsPropertyBoard_iPhone board];
        board.goods = self.goodsModel.goods;
        [self.stack pushBoard:board animated:YES];
    }
}

ON_SIGNAL3( GoodsDetailCell_iPhone, detail, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
        GoodsEntryBoard_iPhone * board = [GoodsEntryBoard_iPhone board];
        board.model.goods_id = self.goodsModel.goods.id;
        [self.stack pushBoard:board animated:YES];
    }
}

ON_SIGNAL3( GoodsDetailCell_iPhone, comment, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
        GoodsCommentBoard_iPhone * board = [GoodsCommentBoard_iPhone board];
        board.commentModel.goods_id = self.goodsModel.goods.id;
        [self.stack pushBoard:board animated:YES];
    }
}

ON_SIGNAL3( GoodsDetailTab_iPhone, favorite, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
		if ( NO == self.goodsModel.loaded )
			return;
        
		if ( NO == [UserModel online] )
		{
			[[AppBoard_iPhone sharedInstance] showLogin];
			return;
		}
        
		BeeUIButton * button = (BeeUIButton *)signal.source;
		if ( button.selected )
		{
//			[self presentFailureTips:__TEXT(@"favorite_added")];
			return;
		}
		else
		{
			if ( self.goodsModel.goods )
			{
				[self.collectionModel collect:self.goodsModel.goods];
			}
		}
    }
}

ON_SIGNAL3( GoodsDetailTab_iPhone, buy, signal)
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
		if ( NO == [UserModel online] )
		{
			[[AppBoard_iPhone sharedInstance] showLogin];
			return;
		}

        [self addToCart:self.ACTION_BUY];
    }
}

ON_SIGNAL3( GoodsDetailTab_iPhone, add, signal)
{
	if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
		if ( NO == [UserModel online] )
		{
			[[AppBoard_iPhone sharedInstance] showLogin];
			return;
		}

        [self addToCart:self.ACTION_ADD];
    }
}

ON_SIGNAL3( GoodsDetailTab_iPhone, cart, signal)
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
		if ( NO == [UserModel online] )
		{
			[[AppBoard_iPhone sharedInstance] showLogin];
			return;
		}
        
        [self.stack pushBoard:[CartBoard_iPhone board] animated:YES];
    }
}

- (void)showSpecifyBoard
{
    GoodsSpecifyBoard_iPhone * board = [GoodsSpecifyBoard_iPhone board];
    board.goods = self.goodsModel.goods;
    board.count = self.count;
    [board.specs removeAllObjects];
    [board.specs addObjectsFromArray:self.specs];

    if ( IOS7_OR_LATER )
    {
        [self presentModalBoard:board animated:YES];
    }
    else
    {
        [self presentModalStack:[BeeUIStack stackWithFirstBoard:board] animated:YES];
    }
}

- (void)addToCart:(NSUInteger)action
{
    if ( self.ACTION_SPEC == action )
    {   
        return;
    }
    
    self.action = action;
    
    if ( NO == [UserModel online] )
    {
        [[AppBoard_iPhone sharedInstance] showLogin];
        return;
    }

    if ( self.isSpecified )
    {
        [self.cartModel create:self.goodsModel.goods
						number:self.count
						  spec:[self specIDs]];
    }
    else
    {
        [self showSpecifyBoard];
    }
}

- (NSArray *)specIDs
{
    NSMutableArray * ids = [NSMutableArray array];
    
    for ( GOOD_SPEC_VALUE * spec_value in self.specs )
    {
        [ids addObject:spec_value.value.id];
    }
    
    return ids;
}

- (BOOL)isSpecified
{
    BOOL result = YES;
    
    if ( self.goodsModel.goods.specification.count > 0 && self.specs.count  == 0 )
    {
        return NO;
    }
    
    return result;
}

- (void)handleNotification:(NSNotification *)notification
{
	if ( [notification is:CartModel.UPDATED] )
	{
		NSUInteger count = 0;
		
		for ( CART_GOODS * goods in [CartModel sharedInstance].goods )
		{
			count += goods.goods_number.intValue;
		}

		_tabbar.data = __INT( count );
	}
}

#pragma mark -

- (void)handleMessage:(BeeMessage *)msg
{
    if ( [msg is:API.goods] )
    {
        if ( msg.sending )
        {
			if ( NO == self.goodsModel.loaded )
			{
				[self presentLoadingTips:__TEXT(@"tips_loading")];
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
			GOODS * goods = msg.GET_OUTPUT(@"data");
			if ( goods )
			{
				if ( goods.collected && goods.collected.boolValue )
				{
					$(_tabbar).FIND(@"#favorite").SELECT();
				}
				else
				{
					$(_tabbar).FIND(@"#favorite").UNSELECT();
				}
			}
			
            [_scroll asyncReloadData];
        }
        else if ( msg.failed )
        {
			[ErrorMsg presentErrorMsg:msg inBoard:self];
        }
    }
    else if ( [msg is:API.user_collect_create] )
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
			$(_tabbar).FIND(@"#favorite").SELECT();
        }
        else if ( msg.failed )
        {
			$(_tabbar).FIND(@"#favorite").SELECT();
        }
    }
    else if ( [msg is:API.user_collect_delete] )
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
			$(_tabbar).FIND(@"#favorite").UNSELECT();
        }
        else if ( msg.failed )
        {
			$(_tabbar).FIND(@"#favorite").UNSELECT();
        }
    }
    else if ( [msg is:API.cart_create] )
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
            STATUS * status = msg.GET_OUTPUT(@"status");
            
            if ( status.succeed.boolValue )
            {
                [self presentSuccessTips:__TEXT(@"add_to_cart_success")];

                if ( self.ACTION_BUY == self.action )
                {
                    [self.stack pushBoard:[CartBoard_iPhone board] animated:YES];
                }
            }
			
			NSNumber * count = (NSNumber *)_tabbar.data;
			if ( count )
			{
				_tabbar.data = __INT( count.intValue + 1 );
			}
			
			[[CartModel sharedInstance] fetchFromServer];
        }
		else if ( msg.failed )
        {
            [ErrorMsg presentErrorMsg:msg inBoard:self];
        }
    }
}

- (NSArray *)specsFromGoods:(GOODS *)goods;
{
    NSMutableArray * specs = [NSMutableArray array];
    
    if ( goods.specification.count > 0 )
    {
        for ( GOOD_SPEC * spec in goods.specification )
        {
            NSArray * values = spec.value;
            
            GOOD_SPEC_VALUE * spec_value = [[[GOOD_SPEC_VALUE alloc] init] autorelease];
            GOOD_VALUE * value = [[[GOOD_VALUE alloc] init] autorelease];
            
            spec_value.spec = spec;
            
            NSString * string = @"";
            
            for ( GOOD_VALUE * value in values )
            {
                string = [string stringByAppendingFormat:@"%@ ", value.label];
            }
            
            value.label = string;
            spec_value.value = value;
            
            [specs addObject:spec_value];
        }
    }
    
    return [NSArray arrayWithArray:specs];
}

#pragma mark -

- (NSInteger)numberOfLinesInScrollView:(BeeUIScrollView *)scrollView
{
	return 1;
}

- (NSInteger)numberOfViewsInScrollView:(BeeUIScrollView *)scrollView
{
    return self.goodsModel.loaded ? 1 : 0;
}

- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index scale:(CGFloat)scale
{
    GoodsDetailCell_iPhone * cell = [scrollView dequeueWithContentClass:[GoodsDetailCell_iPhone class]];
    
    if ( self.goodsModel.goods )
    {
        NSArray * specs = nil;
        
        if ( 0 == self.specs.count )
        {
            specs = nil; // [self specsFromGoods:self.goodsModel.goods];
        }
        else
        {
            specs = self.specs;
        }
        
        NSMutableDictionary * data = [NSMutableDictionary dictionary];

		if ( specs )
		{
			[data setObject:specs forKey:@"specs"];
		}
		
        [data setObject:self.count      forKey:@"count"];
        [data setObject:self.goodsModel forKey:@"goodsModel"];

        
        cell.data = data;
    }
    
    return cell;
}

- (CGSize)scrollView:(BeeUIScrollView *)scrollView sizeForIndex:(NSInteger)index
{
    if ( self.goodsModel.goods )
    {
        NSArray * specs = nil;
        
        if ( 0 == self.specs.count )
        {
            specs = nil; // [self specsFromGoods:self.goodsModel.goods];
        }
        else
        {
            specs = self.specs;
        }
        
        NSMutableDictionary * data = [NSMutableDictionary dictionary];
		
		if ( specs )
		{
			[data setObject:specs forKey:@"specs"];
		}
		
        [data setObject:self.count      forKey:@"count"];
        [data setObject:self.goodsModel forKey:@"goodsModel"];

        return [GoodsDetailCell_iPhone estimateUISizeByWidth:scrollView.width forData:data];
    }
    
    return CGSizeZero;
}

@end
