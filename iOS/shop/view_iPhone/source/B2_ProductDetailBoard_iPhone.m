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

#import "B2_ProductDetailBoard_iPhone.h"
#import "AppBoard_iPhone.h"
#import "H0_BrowserBoard_iPhone.h"
#import "B2_ProductDetailBoard_iPhone.h"
#import "B3_ProductPhotoBoard_iPhone.h"
#import "B4_ProductParamBoard_iPhone.h"
#import "B5_ProductCommentBoard_iPhone.h"
#import "B6_ProductDescBoard_iPhone.h"
#import "C0_ShoppingCartBoard_iPhone.h"
#import "B2_ProductSpecifyBoard_iPhone.h"

#import "CommonPullLoader.h"
#import "CommonFootLoader.h"
#import "B2_ProductDetailCell_iPhone.h"
#import "B2_ProductDetailSlideCell_iPhone.h"
#import "B2_ProductDetailTabCell_iPhone.h"

#import "bee.services.share.sinaweibo.h"
#import "bee.services.share.tencentweibo.h"
#import "bee.services.share.weixin.h"

@implementation B2_ProductDetailBoard_iPhone

SUPPORT_RESOURCE_LOADING( YES )
SUPPORT_AUTOMATIC_LAYOUT( YES )

DEF_INT( ACTION_ADD,    1)
DEF_INT( ACTION_BUY,    2)
DEF_INT( ACTION_SPEC,   3)

DEF_SIGNAL( SHARE_TO_SINA )
DEF_SIGNAL( SHARE_TO_TENCENT )
DEF_SIGNAL( SHARE_TO_WEIXIN_FRIEND )
DEF_SIGNAL( SHARE_TO_WEIXIN_TIMELINE )

DEF_MODEL( CartModel,		cartModel )
DEF_MODEL( GoodsInfoModel,	goodsModel )
DEF_MODEL( CollectionModel,	collectionModel )

@synthesize action = _action;
@synthesize specs = _specs;
@synthesize count = _count;

- (void)load
{
	self.cartModel = [CartModel modelWithObserver:self];
	self.goodsModel = [GoodsInfoModel modelWithObserver:self];
	self.collectionModel = [CollectionModel modelWithObserver:self];
    
    self.specs = [NSMutableArray array];
    self.count = @(1);
}


- (void)unload
{
    self.specs = nil;
    
	SAFE_RELEASE_MODEL( self.cartModel );
	SAFE_RELEASE_MODEL( self.goodsModel );
	SAFE_RELEASE_MODEL( self.collectionModel );
}

#pragma mark -

ON_CREATE_VIEWS( signal )
{
    self.navigationBarTitle = __TEXT(@"gooddetail_product");
    self.navigationBarShown = YES;
    self.navigationBarLeft  = [UIImage imageNamed:@"nav_back.png"];;
	self.navigationBarRight = [UIImage imageNamed:@"item_info_header_share_icon.png"];

    self.specfied = @(NO);

    @weakify(self);

    self.list.headerClass = [CommonPullLoader class];
    self.list.headerShown = YES;
	
    self.list.lineCount = 1;
    self.list.animationDuration = 0.25f;

    self.list.whenReloading = ^
    {
        @normalize(self);
        
        self.list.total = self.goodsModel.loaded ? 1 : 0;

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
            [data setObject:self.specfied   forKey:@"specfied"];
            [data setObject:self.goodsModel forKey:@"goodsModel"];
            
            BeeUIScrollItem * item = self.list.items[0];
            item.clazz = [B2_ProductDetailCell_iPhone class];
            item.data = data;
            item.size = CGSizeAuto; 
            item.rule = BeeUIScrollLayoutRule_Tile;
        }
    };

    self.list.whenHeaderRefresh = ^
    {
        @normalize(self);
        [self.goodsModel reload];
    };

    [self.cartModel clearCache];

	[self observeNotification:CartModel.UPDATED];
}

ON_DELETE_VIEWS( signal )
{
    [self unobserveNotification:CartModel.UPDATED];
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
	[self.goodsModel reload];
	[self.cartModel reload];

	[bee.ui.appBoard hideLogin];
	[bee.ui.appBoard hideTabbar];

	[self.list reloadData];
}

ON_DID_APPEAR( signal )
{
	
	ALIAS( bee.services.share.weixin,		weixin );
	ALIAS( bee.services.share.tencentweibo,	tweibo );
	ALIAS( bee.services.share.sinaweibo,	sweibo );

	if ( sweibo.ready || tweibo.ready || weixin.ready )
	{
		self.navigationBarRight = [UIImage imageNamed:@"item_info_header_share_icon.png"];
	}
	else
	{
		self.navigationBarRight = nil;
	}
}

ON_WILL_DISAPPEAR( signal )
{
	[CartModel sharedInstance].loaded = NO;
}

ON_DID_DISAPPEAR( signal )
{
}

ON_LOAD_DATAS( signal )
{
}

//ON_SIGNAL3( BeeUIBoard, MODALVIEW_DID_HIDDEN, signal )
//{
//	if ( 0 == self.action )
//	{
//		[self addToCart:self.ACTION_SPEC];
//	}
//	else
//	{
//		[self addToCart:self.action];
//	}
//}

#pragma mark -

ON_LEFT_BUTTON_TOUCHED( signal )
{
    [self.stack popBoardAnimated:YES];
}

ON_RIGHT_BUTTON_TOUCHED( signal )
{
	ALIAS( bee.services.share.weixin,		weixin );
	ALIAS( bee.services.share.tencentweibo,	tweibo );
	ALIAS( bee.services.share.sinaweibo,	sweibo );

	BOOL valid = NO;
	
    BeeUIActionSheet * sheet = [BeeUIActionSheet spawn];
	
	if ( sweibo.ready )
	{
		[sheet addButtonTitle:__TEXT(@"share_sina") signal:self.SHARE_TO_SINA];
		
		valid = YES;
	}
	
	if ( tweibo.ready )
	{
		[sheet addButtonTitle:__TEXT(@"share_tencent") signal:self.SHARE_TO_TENCENT];
		
		valid = YES;
	}
	
	if ( weixin.ready )
	{
		[sheet addButtonTitle:__TEXT(@"share_weixin") signal:self.SHARE_TO_WEIXIN_FRIEND];
		[sheet addButtonTitle:__TEXT(@"share_weixin_timeline") signal:self.SHARE_TO_WEIXIN_TIMELINE];
		
		valid = YES;
	}

	if ( valid )
	{
		[sheet addCancelTitle:__TEXT(@"button_cancel")];
		[sheet showInViewController:self];
	}
}

#pragma mark -

ON_SIGNAL3( B2_ProductDetailBoard_iPhone, SHARE_TO_SINA, signal )
{
    NSString * text = __TEXT(@"share_blog");				// self.goodsModel.goods.goods_name
    NSString * imageUrl = self.goodsModel.goods.img.thumb;
    NSObject * image = [[BeeImageCache sharedInstance] imageForURL:imageUrl];
//	NSString * title = self.goodsModel.goods.goods_name;	// __TEXT(@"ecmobile")
//	NSString * thumb = self.goodsModel.goods.img.thumb;

    ALIAS( bee.services.share.sinaweibo, sweibo );
    
	if ( image )
    {
        sweibo.post.photo = image;
    }

	sweibo.post.text = text;
	sweibo.post.url = [[ConfigModel sharedInstance].config.goods_url stringByAppendingFormat:@"%@",self.goodsModel.goods_id];

	@weakify(self);
	
	sweibo.whenShareBegin = ^
	{
		@normalize(self);
		
		[self presentLoadingTips:__TEXT(@"uploading")];
	};
	sweibo.whenShareSucceed = ^
	{
		@normalize(self);
		
		[self presentSuccessTips:__TEXT(@"share_succeed")];
	};
	sweibo.whenShareFailed = ^
	{
		@normalize(self);
		
		[self presentFailureTips:sweibo.errorDesc];
	};

	sweibo.SHARE();
}

ON_SIGNAL3( B2_ProductDetailBoard_iPhone, SHARE_TO_TENCENT, signal )
{
    NSString * text = __TEXT(@"share_blog");				// self.goodsModel.goods.goods_name
    NSString * imageUrl = self.goodsModel.goods.img.thumb;
    NSObject * image = [[BeeImageCache sharedInstance] imageForURL:imageUrl];
//    NSString * title = self.goodsModel.goods.goods_name;	// __TEXT(@"ecmobile")
//    NSString * thumb = self.goodsModel.goods.img.thumb;

	ALIAS( bee.services.share.tencentweibo, tweibo );

    if ( image )
    {
        tweibo.post.photo = image;
    }
    
	tweibo.post.text = text;
	tweibo.post.url = [[ConfigModel sharedInstance].config.goods_url stringByAppendingFormat:@"%@",self.goodsModel.goods_id];
    
	@weakify(self);
	
	tweibo.whenShareBegin = ^
	{
		@normalize(self);
		
		[self presentLoadingTips:__TEXT(@"uploading")];
	};
	tweibo.whenShareSucceed = ^
	{
		@normalize(self);
		
		[self presentSuccessTips:__TEXT(@"share_succeed")];
	};
	tweibo.whenShareFailed = ^
	{
		@normalize(self);
		
		[self presentFailureTips:tweibo.errorMsg];
	};
	
	tweibo.SHARE();
}

ON_SIGNAL3( B2_ProductDetailBoard_iPhone, SHARE_TO_WEIXIN_FRIEND, signal)
{
	ALIAS( bee.services.share.weixin, weixin );

	NSString * text = __TEXT(@"share_blog");				// self.goodsModel.goods.goods_name
	NSString * title = self.goodsModel.goods.goods_name;	// __TEXT(@"ecmobile")
    UIImage * image = [[BeeImageCache sharedInstance] imageForURL:self.goodsModel.goods.img.url];
    UIImage * thumb = [[BeeImageCache sharedInstance] imageForURL:self.goodsModel.goods.img.thumb];

    if ( image )
    {
        weixin.post.photo = image;
    }
    
    if ( thumb )
    {
        weixin.post.thumb = thumb;
    }
    else
    {
        weixin.post.thumb = [UIImage imageNamed:@"icon.png"];
    }
    
	weixin.post.text = text;
	weixin.post.title = title;
	weixin.post.url = [[ConfigModel sharedInstance].config.goods_url stringByAppendingFormat:@"%@",self.goodsModel.goods_id];
	
	@weakify(self);
	
	weixin.whenShareSucceed = ^
	{
		@normalize(self);
		
		[self presentSuccessTips:__TEXT(@"share_succeed")];
	};
	
	weixin.whenShareFailed = ^
	{
		@normalize(self);
		
		[self presentFailureTips:weixin.errorDesc];
	};
	
	weixin.SHARE_TO_FRIEND();
}

ON_SIGNAL3( B2_ProductDetailBoard_iPhone, SHARE_TO_WEIXIN_TIMELINE, signal)
{
	NSString * text = __TEXT(@"share_blog");				// self.goodsModel.goods.goods_name
    NSString * title = self.goodsModel.goods.goods_name;	// __TEXT(@"ecmobile")
    UIImage * image = [[BeeImageCache sharedInstance] imageForURL:self.goodsModel.goods.img.url];
    UIImage * thumb = [[BeeImageCache sharedInstance] imageForURL:self.goodsModel.goods.img.thumb];
	
	ALIAS( bee.services.share.weixin, weixin );
	
    if ( image )
    {
        weixin.post.photo = image;
    }
    
    if ( thumb )
    {
        weixin.post.thumb = thumb;
    }
    else
    {
        weixin.post.thumb = [UIImage imageNamed:@"icon.png"];
    }
    
	weixin.post.text = text;
	weixin.post.title = title;
	weixin.post.url = [[ConfigModel sharedInstance].config.goods_url stringByAppendingFormat:@"%@",self.goodsModel.goods_id];
	
	@weakify(self);
	
	weixin.whenShareSucceed = ^
	{
		@normalize(self);
		
		[self presentSuccessTips:__TEXT(@"share_succeed")];
	};
	
	weixin.whenShareFailed = ^
	{
		@normalize(self);
		
		[self presentFailureTips:weixin.errorDesc];
	};
	
	weixin.SHARE_TO_TIMELINE();
}

#pragma mark - B2_ProductDetailSlideCell_iPhone

/**
 * 商品详情-商品图片，点击事件触发时执行的操作
 */
ON_SIGNAL2( B2_ProductDetailSlideCell_iPhone, signal)
{
	PHOTO * photo = signal.sourceCell.data;

    B3_ProductPhotoBoard_iPhone * board = [B3_ProductPhotoBoard_iPhone board];
    board.goods = self.goodsModel.goods;
	board.pageIndex = [self.goodsModel.goods.pictures indexOfObject:photo];
    [self.stack pushBoard:board animated:YES];
}

#pragma mark - B2_ProductDetailCell_iPhone

/**
 * 商品详情-商品数量配置，点击事件触发时执行的操作
 */
ON_SIGNAL3( B2_ProductDetailCell_iPhone, specify, signal )
{
    self.action = self.ACTION_SPEC;
    [self showSpecifyBoard];
}

/**
 * 商品详情-基本参数，点击事件触发时执行的操作
 */
ON_SIGNAL3( B2_ProductDetailCell_iPhone, property, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
        B4_ProductParamBoard_iPhone * board = [B4_ProductParamBoard_iPhone board];
        board.goods = self.goodsModel.goods;
        [self.stack pushBoard:board animated:YES];
    }
}

/**
 * 商品详情-商品描述，点击事件触发时执行的操作
 */
ON_SIGNAL3( B2_ProductDetailCell_iPhone, detail, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
        B6_ProductDescBoard_iPhone * board = [B6_ProductDescBoard_iPhone board];
        board.goodsPageModel.goods_id = self.goodsModel.goods.id;
        [self.stack pushBoard:board animated:YES];
    }
}

/**
 * 商品详情-商品评论，点击事件触发时执行的操作
 */
ON_SIGNAL3( B2_ProductDetailCell_iPhone, comment, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
        B5_ProductCommentBoard_iPhone * board = [B5_ProductCommentBoard_iPhone board];
        board.commentModel.goods_id = self.goodsModel.goods.id;
        [self.stack pushBoard:board animated:YES];
    }
}

#pragma mark - B2_ProductDetailTabCell_iPhone

/**
 * 商品详情-TABBAR-收藏，点击事件触发时执行的操作
 */
ON_SIGNAL3( B2_ProductDetailTabCell_iPhone, favorite, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
		if ( NO == self.goodsModel.loaded )
			return;
        
		if ( NO == [UserModel online] )
		{
			[bee.ui.appBoard showLogin];
			return;
		}
        
		BeeUIButton * button = (BeeUIButton *)signal.source;
		if ( button.selected )
		{
			[self presentFailureTips:__TEXT(@"favorite_added")];
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

/**
 * 商品详情-TABBAR-立即购买，点击事件触发时执行的操作
 */
ON_SIGNAL3( B2_ProductDetailTabCell_iPhone, buy, signal)
{
    [self addToCart:self.ACTION_BUY];
}

/**
 * 商品详情-TABBAR-加入购物车，点击事件触发时执行的操作
 */
ON_SIGNAL3( B2_ProductDetailTabCell_iPhone, add, signal)
{
    [self addToCart:self.ACTION_ADD];
}

/**
 * 商品详情-TABBAR-购物车，点击事件触发时执行的操作
 */
ON_SIGNAL3( B2_ProductDetailTabCell_iPhone, cart, signal)
{
    if ( NO == [UserModel online] )
    {
        [bee.ui.appBoard showLogin];
        return;
    }
    
    [self.stack pushBoard:[C0_ShoppingCartBoard_iPhone board] animated:YES];
}

#pragma mark -

- (void)showSpecifyBoard
{
    @weakify(self);

    B2_ProductSpecifyBoard_iPhone * board = [B2_ProductSpecifyBoard_iPhone board];
    board.goods = self.goodsModel.goods;
    board.count = self.count;
    [board setSpecsFromArray:self.specs];

    board.whenSpecified = ^( NSArray * specs, NSNumber * count ) {
        @normalize(self);

        [self.goodsModel reload];
        
		[self.specs removeAllObjects];
		[self.specs addObjectsFromArray:specs];

		self.count = count;
		self.specfied = @(YES);

		[self hideSpecifyBoard];

		if ( self.ACTION_SPEC == self.action )
            return;

        if ( !self.isSpecified )
        {
            [self presentFailureTips:__TEXT(@"select_specification_first")];
        }
        else
        {
            [self.cartModel create:self.goodsModel.goods
                            number:self.count
                              spec:[self specIDs]];
        }
    };
    
    board.whenCanceled = ^ {
        @normalize(self);
        [self hideSpecifyBoard];
    };
	
    if ( IOS7_OR_LATER )
    {
        [self presentModalBoard:board animated:YES];
    }
    else
    {
        [self presentModalStack:[BeeUIStack stackWithFirstBoard:board] animated:YES];
    }
}

- (void)hideSpecifyBoard
{
    if ( IOS7_OR_LATER )
    {
        [self dismissModalBoardAnimated:YES];
    }
    else
    {
        [self dismissModalStackAnimated:YES];
    }
}

- (void)addToCart:(NSUInteger)action
{
    if ( NO == [UserModel online] )
    {
        [bee.ui.appBoard showLogin];
        return;
    }
    
    [self setAction:action];
	
    if ( !self.isSpecified )
    {
        [self showSpecifyBoard];
    }
    else
    {
        [self.cartModel create:self.goodsModel.goods
                        number:self.count
                          spec:[self specIDs]];
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

ON_NOTIFICATION3( CartModel, UPDATED, n )
{
	NSUInteger count = 0;
	
	for ( CART_GOODS * goods in [CartModel sharedInstance].goods )
	{
		count += goods.goods_number.intValue;
	}

	_tabbar.data = __INT( count );
}

#pragma mark -

ON_MESSAGE3( API, goods, msg )
{
	if ( msg.sending )
	{
		if ( NO == self.goodsModel.loaded )
		{
			[self presentLoadingTips:__TEXT(@"tips_loading")];
		}
	}
	else
	{
		[self.list setHeaderLoading:NO];
		
		[self dismissTips];
	}
	
	if ( msg.succeed )
	{
		STATUS *	status = msg.GET_OUTPUT(@"status");
		GOODS *		goods = msg.GET_OUTPUT(@"data");
		
		if ( status && status.succeed.boolValue )
		{
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

ON_MESSAGE3( API, user_collect_create, msg )
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
		
		if ( status && status.succeed.boolValue )
		{
			[self presentSuccessTips:__TEXT(@"collection_success")];
			
			$(self.tabbar).FIND(@"#favorite").SELECT();
		}
	}
	else if ( msg.failed )
	{	
		$(self.tabbar).FIND(@"#favorite").SELECT();
	}
}

ON_MESSAGE3( API, user_collect_delete, msg )
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
		
		if ( status && status.succeed.boolValue )
		{
			$(_tabbar).FIND(@"#favorite").UNSELECT();
		}
	}
	else if ( msg.failed )
	{
		$(_tabbar).FIND(@"#favorite").UNSELECT();
	}
}

ON_MESSAGE3( API, cart_create, msg )
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

		if ( status && status.succeed.boolValue )
		{
		//	[self presentSuccessTips:__TEXT(@"add_to_cart_success")];

			if ( self.ACTION_BUY == self.action )
			{
				[self.stack pushBoard:[C0_ShoppingCartBoard_iPhone board] animated:YES];
			}

			NSNumber * count = (NSNumber *)_tabbar.data;
			if ( count )
			{
				_tabbar.data = __INT( count.intValue + 1 );
			}

			[[CartModel sharedInstance] reload];
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
