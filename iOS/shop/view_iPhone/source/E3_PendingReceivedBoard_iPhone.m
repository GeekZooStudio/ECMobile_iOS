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

#import "E3_PendingReceivedBoard_iPhone.h"
#import "E3_PendingReceivedCell_iPhone.h"
#import "E3_PendingReceivedCellFooter_iPhone.h"
#import "E6_ShippingStatusBoard_iPhone.h"

#import "AppBoard_iPhone.h"
#import "OrderCell_iPhone.h"

#import "CommonNoResultCell.h"
#import "CommonPullLoader.h"
#import "CommonFootLoader.h"

#pragma mark -

@implementation E3_PendingReceivedBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_MODEL( OrderModel, orderModel );

DEF_OUTLET( BeeUIScrollView, list )

- (void)load
{
	self.orderModel = [OrderModel modelWithObserver:self];
    self.orderModel.type = ORDER_LIST_SHIPPED;
}

- (void)unload
{
	SAFE_RELEASE_MODEL( self.orderModel );
}

#pragma mark -

ON_CREATE_VIEWS( signal )
{
    self.navigationBarTitle = __TEXT(@"shipped");
    
    [self showNavigationBarAnimated:NO];
    [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav_back.png"]];
    
    @weakify(self);
    
    self.list.headerClass = [CommonPullLoader class];
    self.list.headerShown = YES;
    
    self.list.footerClass = [CommonFootLoader class];
    self.list.footerShown = YES;
    
    self.list.lineCount = 1;
    self.list.animationDuration = 0.25f;
    
    self.list.whenReloading = ^
    {
        @normalize(self);
        
        self.list.total = self.orderModel.orders.count;
        
        if ( self.orderModel.loaded && 0 == self.orderModel.orders.count )
        {
            self.list.total = 1;
            
            BeeUIScrollItem * item = self.list.items[0];
            item.clazz = [CommonNoResultCell class];
            item.size = self.list.size;
            item.rule = BeeUIScrollLayoutRule_Tile;
        }
        else
        {
            for ( int i = 0; i < self.orderModel.orders.count; i++ )
            {
                BeeUIScrollItem * item = self.list.items[i];
                item.clazz = [E3_PendingReceivedCell_iPhone class];
                item.size = CGSizeAuto;
                item.data = [self.orderModel.orders safeObjectAtIndex:i];
                item.rule = BeeUIScrollLayoutRule_Tile;
            }
        }
    };
    self.list.whenHeaderRefresh = ^
    {
        @normalize(self);
        
        [self.orderModel firstPage];
        
    };
    self.list.whenFooterRefresh = ^
    {
        @normalize(self);
        
        [self.orderModel nextPage];
    };
    self.list.whenReachBottom = ^
    {
        @normalize(self);
        
        [self.orderModel nextPage];
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

	[self.list reloadData];
}

ON_DID_APPEAR( signal )
{
    if ( [UserModel online] )
    {
        [self.orderModel firstPage];
    }
    else
    {
        [bee.ui.appBoard showLogin];
    }
}

ON_WILL_DISAPPEAR( signal )
{
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
}

#pragma mark - E3_PendingReceivedCell_iPhone

/**
 * 个人中心-待收货订单，确认订单事件触发时执行的操作
 */
ON_SIGNAL3( E3_PendingReceivedCell_iPhone, ORDER_AFFIRM, signal )
{
    E3_PendingReceivedCell_iPhone * cell = (E3_PendingReceivedCell_iPhone *)signal.source;

    [self.orderModel affirmReceived:cell.order];
}

/**
 * 个人中心-待收货订单，查看物流事件触发时执行的操作
 */
ON_SIGNAL3( E3_PendingReceivedCell_iPhone, ORDER_SHIIPING, signal )
{
    E3_PendingReceivedCell_iPhone * cell = (E3_PendingReceivedCell_iPhone *)signal.source;
    
    // 后台需要配置快递100的key
    {
        E6_ShippingStatusBoard_iPhone * board = [E6_ShippingStatusBoard_iPhone board];
        board.expressModel.order = cell.order;
        [self.stack pushBoard:board animated:YES];
    }
}

#pragma mark -

ON_MESSAGE3( API, order_list, msg )
{
	if ( msg.sending )
	{
		if ( NO == self.orderModel.loaded )
		{
			[self presentLoadingTips:__TEXT(@"tips_loading")];
		}
		
		if ( self.orderModel.orders.count )
		{
			[self.list setFooterLoading:YES];
		}
		else
		{
			[self.list setFooterLoading:NO];
		}
	}
	else
	{
		[self dismissTips];
		
		[self.list setHeaderLoading:NO];
		[self.list setFooterLoading:NO];
	}
	
	if ( msg.succeed )
	{
		STATUS * status = msg.GET_OUTPUT(@"status");
		
		if ( status && status.succeed.boolValue )
		{
			[self.list setFooterMore:self.orderModel.more];
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

ON_MESSAGE3( API, order_affirmReceived, msg )
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
			[self presentSuccessTips:__TEXT(@"successful_operation")];
			
			[self.list setFooterMore:self.orderModel.more];

			[self.list reloadData];
			
			[self.orderModel firstPage];
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
