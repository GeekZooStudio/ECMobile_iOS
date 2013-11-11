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
#import "CollectionBoard_iPhone.h"
#import "CommonWaterMark.h"

@implementation CollectionCell_iPhone

SUPPORT_RESOURCE_LOADING( YES )

DEF_SIGNAL( TAPPED )
DEF_SIGNAL( DELETE )

- (void)load
{
    [super load];
    
    self.tappable = YES;
    self.tapSignal = self.TAPPED;
}

- (void)dataDidChanged
{
	COLLECT_GOODS * goods = self.data;
    
	if ( goods )
	{
	    $(@".goods-photo").IMAGE( goods.img.thumbURL );
		$(@".goods-title").TEXT( goods.name );
		$(@".goods-price").TEXT( goods.shop_price );
		$(@".goods-subprice").TEXT( goods.market_price );
        
        if ( self.isEditing )
        {
            $(@"#delete").SHOW();
        }
        else
        {
            $(@"#delete").HIDE();
        }
	}
}

ON_SIGNAL3( CollectionCell_iPhone, delete, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
        [self sendUISignal:self.DELETE];
    }
}

@end

#pragma mark -

@interface CollectionBoard_iPhone()
{
	BeeUIScrollView *           _scroll;
}
@end

#pragma mark -

@implementation CollectionBoard_iPhone

- (void)load
{
	[super load];
	
	self.collectionModel = [[[CollectionModel alloc] init] autorelease];
	[self.collectionModel addObserver:self];
}

- (void)unload
{
	[self.collectionModel removeObserver:self];
	self.collectionModel = nil;
	
	[super unload];
}

#pragma mark -

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        self.titleString = __TEXT(@"collect_myfavorite");
        self.isEditing = NO;
        
        [self showNavigationBarAnimated:NO];
        [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav-back.png"]];

		self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"body-bg.png"]];
        
		_scroll = [[BeeUIScrollView alloc] init];
		_scroll.dataSource = self;
        [_scroll showHeaderLoader:YES animated:NO];
        [_scroll showFooterLoader:YES animated:NO];
		[self.view addSubview:_scroll];
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
		SAFE_RELEASE_SUBVIEW( _scroll );
	}
	else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{
		_scroll.frame = self.viewBound;
	}
    else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
    {
        [_collectionModel loadCache];
    }
    else if ( [signal is:BeeUIBoard.FREE_DATAS] )
    {
    }
    else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
    {
		[[AppBoard_iPhone sharedInstance] setTabbarHidden:YES];
		
		[self updateViews];
    }
	else if ( [signal is:BeeUIBoard.DID_APPEAR] )
	{
		[self updateDatas];

        [_scroll reloadData];
	}
    else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
    {
		self.isEditing = NO;
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
        self.isEditing = !self.isEditing;
        
        [self updateViews];
	}
}

ON_SIGNAL2( BeeUIScrollView, signal )
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIScrollView.HEADER_REFRESH] )
	{        
		[self.collectionModel prevPageFromServer];
	}
	else if ( [signal is:BeeUIScrollView.REACH_BOTTOM] )
	{
		[self.collectionModel nextPageFromServer];
	}
}

ON_SIGNAL2( CollectionCell_iPhone, signal )
{
    COLLECT_GOODS * goods = ((CollectionCell_iPhone *)signal.source).data;
    
    if ( [signal is:CollectionCell_iPhone.TAPPED] )
    {
        GoodsDetailBoard_iPhone * board = [GoodsDetailBoard_iPhone board];
        board.goodsModel.goods_id = goods.goods_id;
        [self.stack pushBoard:board animated:YES];
    }
    else if ( [signal is:CollectionCell_iPhone.DELETE] )
    {
        [_collectionModel uncollect:goods];
    }
}

- (void)updateViews
{
    if ( self.isEditing )
    {
        [self showBarButton:BeeUINavigationBar.RIGHT title:__TEXT(@"collect_done") image:[UIImage imageNamed:@"nav-right.png"]];
    }
    else
    {
        [self showBarButton:BeeUINavigationBar.RIGHT title:__TEXT(@"collect_compile") image:[UIImage imageNamed:@"nav-right.png"]];
    }
    
    [_scroll reloadData];
}

- (void)updateDatas
{
    [_collectionModel prevPageFromServer];
}

#pragma mark -

- (void)handleMessage:(BeeMessage *)msg
{
    [super handleMessage:msg];
	
	if ( [msg is:API.user_collect_list] )
	{
        if ( msg.sending )
        {
            if ( self.collectionModel.loaded )
            {
                [_scroll setHeaderLoading:YES];
				[_scroll setFooterLoading:YES];
            }
            else
            {
                [self presentLoadingTips:__TEXT(@"tips_loading")];
            }
        }
        else
        {
            [_scroll setHeaderLoading:NO];
			[_scroll setFooterLoading:NO];

            [self dismissTips];
        }
        
        
		if ( msg.succeed )
		{
            self.isEditing = NO;
			
			[_scroll setFooterMore:self.collectionModel.more];
			[_scroll asyncReloadData];
		}
		else if ( msg.failed )
		{
//			[self presentFailureTips:@"网络异常，请稍后再试"];
			[ErrorMsg presentErrorMsg:msg inBoard:self];
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
			[self updateViews];
		}
		else if ( msg.failed )
		{
			[ErrorMsg presentErrorMsg:msg inBoard:self];
		}
	}
}

#pragma mark -

- (void)handleNotification:(NSNotification *)notification
{
    [super handleNotification:notification];
}

#pragma mark -

- (NSInteger)numberOfLinesInScrollView:(BeeUIScrollView *)scrollView
{
	if ( _collectionModel.loaded && 0 == _collectionModel.goods.count )
	{
		return 1;
	}

	return 2;
}

- (NSInteger)numberOfViewsInScrollView:(BeeUIScrollView *)scrollView
{
	if ( _collectionModel.loaded && 0 == _collectionModel.goods.count )
	{
		return 1;
	}

	return _collectionModel.goods.count;
}

- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index scale:(CGFloat)scale
{
	if ( _collectionModel.loaded && 0 == _collectionModel.goods.count )
	{
		return [scrollView dequeueWithContentClass:[NoResultCell class]];
	}

    CollectionCell_iPhone * cell = [scrollView dequeueWithContentClass:[CollectionCell_iPhone class]];
    cell.isEditing = self.isEditing;
    cell.data = [_collectionModel.goods objectAtIndex:index];
    return cell;
}

- (CGSize)scrollView:(BeeUIScrollView *)scrollView sizeForIndex:(NSInteger)index
{
	if ( _collectionModel.loaded && 0 == _collectionModel.goods.count )
	{
		return self.size;
	}

    return CGSizeMake( (scrollView.width / 2), 180.0f );
}

@end
