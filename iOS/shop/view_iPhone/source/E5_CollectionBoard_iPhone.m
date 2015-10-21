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
#import "E5_CollectionBoard_iPhone.h"
#import "E5_CollectionCell_iPhone.h"

#import "AppBoard_iPhone.h"

#import "CommonNoResultCell.h"
#import "CommonPullLoader.h"
#import "CommonFootLoader.h"

#pragma mark -

@implementation E5_CollectionBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_SIGNAL( UNFAVOURITE )

DEF_OUTLET( BeeUIScrollView, list )

DEF_MODEL( CollectionModel, collectionModel )

- (void)load
{
	self.collectionModel = [CollectionModel modelWithObserver:self];
}

- (void)unload
{
	SAFE_RELEASE_MODEL( self.collectionModel );
}

#pragma mark -

ON_CREATE_VIEWS( signal )
{
    self.navigationBarTitle = __TEXT(@"collect_myfavorite");
    self.isEditing = NO;
    
    [self showNavigationBarAnimated:NO];
    [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav_back.png"]];
    
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
        
        self.list.total = self.collectionModel.goods.count;
        
        if ( self.collectionModel.loaded && 0 == self.collectionModel.goods.count )
        {
            self.list.total = 1;
            
            BeeUIScrollItem * item = self.list.items[0];
            item.clazz = [CommonNoResultCell class];
            item.size = self.list.size;
            item.rule = BeeUIScrollLayoutRule_Tile;
        }
        else
        {
            for ( int i = 0; i < self.collectionModel.goods.count; i++ )
            {
                COLLECT_GOODS * goods = [self.collectionModel.goods safeObjectAtIndex:i];
                goods.isEditing = self.isEditing;
                
                BeeUIScrollItem * item = self.list.items[i];
                item.clazz = [E5_CollectionCell_iPhone class];
                item.size = CGSizeMake( self.list.width / 2, 180.0f );
                item.data = goods;
                item.rule = BeeUIScrollLayoutRule_Tile;
            }
        }
    };
    self.list.whenHeaderRefresh = ^
    {
        @normalize(self);
        
        [self.collectionModel firstPage];
    };
    self.list.whenFooterRefresh = ^
    {
        @normalize(self);
        
        [self.collectionModel nextPage];
    };
    self.list.whenReachBottom = ^
    {
        @normalize(self);
        
        [self.collectionModel nextPage];
    };
}

ON_DELETE_VIEWS( signal )
{
    self.list = nil;
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
    [bee.ui.appBoard hideTabbar];
    
    [self updateViews];
}

ON_DID_APPEAR( signal )
{
    [self updateDatas];

    [self.list reloadData];
}

ON_WILL_DISAPPEAR( signal )
{
    self.isEditing = NO;
}

ON_DID_DISAPPEAR( signal )
{
}

#pragma mark -

ON_LEFT_BUTTON_TOUCHED( signal )
{
    [self.stack popBoardAnimated:YES];
}

ON_RIGHT_BUTTON_TOUCHED( signal )
{
    self.isEditing = !self.isEditing;
    
    [self updateViews];
}

#pragma mark - E5_CollectionCell_iPhone

/**
 * 个人中心-我的收藏-商品，点击事件触发时执行的操作
 */
ON_SIGNAL3( E5_CollectionCell_iPhone, TAPPED, signal )
{
    COLLECT_GOODS * goods = ((E5_CollectionCell_iPhone *)signal.source).data;
    
    B2_ProductDetailBoard_iPhone * board = [B2_ProductDetailBoard_iPhone board];
    board.goodsModel.goods_id = goods.goods_id;
    [self.stack pushBoard:board animated:YES];
}

/**
 * 个人中心-我的收藏-商品，收藏取消事件触发时执行的操作
 */
ON_SIGNAL3( E5_CollectionCell_iPhone, delete, signal )
{
    COLLECT_GOODS * goods = ((E5_CollectionCell_iPhone *)signal.sourceCell).data;
    
    BeeUIAlertView * alert = [BeeUIAlertView spawn];
    alert.title = @"确定删除收藏?";
    [alert addButtonTitle:@"确定" signal:self.UNFAVOURITE object:goods];
    [alert addCancelTitle:@"取消"];
    [alert showInViewController:self];
}

#pragma mark -

ON_SIGNAL3( E5_CollectionBoard_iPhone , UNFAVOURITE, signal )
{
    COLLECT_GOODS * goods = signal.object;
    [self.collectionModel uncollect:goods];
}

#pragma mark -

- (void)updateViews
{
    if ( self.isEditing )
    {
        [self showBarButton:BeeUINavigationBar.RIGHT title:__TEXT(@"collect_done") image:[UIImage imageNamed:@"nav_right.png"]];
    }
    else
    {
        [self showBarButton:BeeUINavigationBar.RIGHT title:__TEXT(@"collect_compile") image:[UIImage imageNamed:@"nav_right.png"]];
    }

    [self.list reloadData];
}

- (void)updateDatas
{
    [self.collectionModel firstPage];
}

#pragma mark -

ON_MESSAGE3( API, user_collect_list, msg )
{
	if ( msg.sending )
	{
		if ( NO == self.collectionModel.loaded )
		{
			[self presentLoadingTips:__TEXT(@"tips_loading")];
		}

		[self.list setFooterLoading:(self.collectionModel.goods.count ? YES : NO)];
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
			self.isEditing = NO;
			
			[self.list setFooterMore:self.collectionModel.more];
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
			[self updateViews];
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
