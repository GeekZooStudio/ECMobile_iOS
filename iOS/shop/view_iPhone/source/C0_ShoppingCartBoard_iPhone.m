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

#import "C0_ShoppingCartBoard_iPhone.h"
#import "F1_NewAddressBoard_iPhone.h"
#import "C1_CheckOutBoard_iPhone.h"

#import "AppBoard_iPhone.h"
#import "UserModel.h"

#import "C0_ShoppingCartPullLoader_iPhone.h"
#import "C0_ShoppingCartHeaderCell_iPhone.h"
#import "C0_ShoppingCartCheckoutCell_iPhone.h"
#import "C0_ShoppingCartCell_iPhone.h"
#import "C0_ShoppingCartEditCell_iPhone.h"
#import "C0_ShoppingCartEmptyCell_iPhone.h"

#pragma mark -

@interface C0_ShoppingCartBoard_iPhone()
{
    C0_ShoppingCartCheckoutCell_iPhone *   _checkoutCell;
}
@end

#pragma mark -

@implementation C0_ShoppingCartBoard_iPhone

SUPPORT_RESOURCE_LOADING( YES );
SUPPORT_AUTOMATIC_LAYOUT( YES );

DEF_SIGNAL( REMOVE_CONFIRM )
DEF_SIGNAL( REMOVE_CANCEL )

DEF_OUTLET( BeeUIScrollView, list )
DEF_OUTLET( BeeUIImageView, header )

DEF_MODEL( CartModel,			cartModel )
DEF_MODEL( AddressListModel,	addressListModel )

- (void)load
{
    self.cartModel = [CartModel modelWithObserver:self];
    self.addressListModel = [AddressListModel modelWithObserver:self];
    
    self.editingState = [NSMutableArray array];
}

- (void)unload
{
	SAFE_RELEASE_MODEL( self.cartModel );
	SAFE_RELEASE_MODEL( self.addressListModel );
    
    self.editingState = nil;
}

#pragma mark -

ON_CREATE_VIEWS( signal )
{
    self.navigationBarShown = YES;
    self.navigationBarTitle = __TEXT(@"shopcar_shopcar");
    
    [self handleEmpty:YES];
    
    @weakify(self);
    
    self.list.lineCount = 1;
    self.list.animationDuration = 0.25f;
    
    self.list.headerClass = [C0_ShoppingCartPullLoader_iPhone class];
    self.list.headerShown = YES;
    
    self.list.whenReloading = ^
    {
        @normalize(self);
        
        /**购物车为空的情况：
         * 1.用户未登录状态；
         * 2.用户已登录，并且请求返回的数据为空
         */
        
        if ( NO == [UserModel online] ) // 未登录
        {
            self.list.total = 1;
            
            BeeUIScrollItem * item = self.list.items[0];
            item.clazz = [C0_ShoppingCartEmptyCell_iPhone class];
            item.size = self.list.size;
            item.rule = BeeUIScrollLayoutRule_Tile;
            
            [self handleEmpty:YES];
            [self handleLogined:NO];
        }
        else // 已登录
        {
            [self handleLogined:YES];
            
            if ( self.cartModel.loaded ) // 已加载
            {
                if ( 0 == self.cartModel.goods.count ) // 已加载，无数据
                {
                    self.list.total = 1;

                    BeeUIScrollItem * item = self.list.items[0];
                    item.clazz = [C0_ShoppingCartEmptyCell_iPhone class];
                    item.size = self.list.size;
                    item.rule = BeeUIScrollLayoutRule_Tile;

                    [self handleEmpty:YES];
                }
                else // 已加载，有数据
                {
                    [self handleEmpty:NO];
                    
                    if ( self.cartModel.goods.count )
                    {
                        self.list.total = 1;
                        self.list.total += self.cartModel.goods.count;
                        
                        int offset = 0;
                        
                        for ( int i = 0; i < self.cartModel.goods.count; i++ )
                        {
                            CART_GOODS * goods = [self.cartModel.goods safeObjectAtIndex:i];
                            
                            for ( NSNumber * rec_id in self.editingState  )
                            {
                                if ( [rec_id isEqualToNumber:goods.rec_id] )
                                {
                                    goods.scrollEditing = YES;
                                }
                            }
                            
                            BeeUIScrollItem * item = [self.list.items safeObjectAtIndex:( i + offset  )];
                            item.clazz = [C0_ShoppingCartCell_iPhone class];
                            //                item.size = CGSizeAuto;
                            item.size = CGSizeMake( self.list.width , 150 );
                            item.data = goods;
                            item.rule = BeeUIScrollLayoutRule_Tile;
                        }
                        
                        offset += self.cartModel.goods.count;
                        
                        if ( self.cartModel.goods.count )
                        {
                            BeeUIScrollItem * footerItem = self.list.items[offset];
                            footerItem.clazz = [C0_ShoppingCartCheckoutCell_iPhone class];
                            footerItem.data = self.cartModel.total;
                            footerItem.size = CGSizeMake( self.list.width, 90 );
                            footerItem.rule = BeeUIScrollLayoutRule_Tile;
                            
                            offset += 1;
                        }
                    }
                }
            }
            else // 未加载
            {
                // do nothing
            }
        }
    };

    self.list.whenHeaderRefresh = ^
    {
        @normalize(self);
        [self.cartModel reload];
    };
    
    [self observeNotification:UserModel.LOGIN];
    [self observeNotification:UserModel.LOGOUT];
    [self observeNotification:UserModel.KICKOUT];
}

ON_DELETE_VIEWS( signal )
{
    [self unobserveAllNotifications];
    
    self.list = nil;
}

ON_WILL_APPEAR( signal )
{
    //    [self reloadData];
    
    if ( nil == self.previousBoard )
    {
        [bee.ui.appBoard showTabbar];
        [self hideBarButton:BeeUINavigationBar.LEFT];
    }
    else
    {
        [bee.ui.appBoard hideTabbar];
        self.navigationBarLeft = [UIImage imageNamed:@"nav_back.png"];
    }
    
    if ( [UserModel online] )
    {
		[self.cartModel reload];
    }
    else
    {
        [self.list reloadData];
    }
}

ON_DID_APPEAR( signal )
{
}

ON_WILL_DISAPPEAR( signal )
{
    if ( nil == self.previousBoard )
    {
        [bee.ui.appBoard hideTabbar];
    }
	
	self.cartModel.loaded = NO;
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

#pragma mark - C0_ShoppingCartCheckoutCell_iPhone

/**
 * 购物车-商品列表-结算，点击事件触发时执行的操作
 */
ON_SIGNAL3( C0_ShoppingCartCheckoutCell_iPhone, checkout, signal )
{
    
    
    if ( NO == self.currentCell.editing )
    {
        [self.addressListModel reload];
    }
}

#pragma mark - C0_ShoppingCartCell_iPhone

ON_SIGNAL2( C0_ShoppingCartCell_iPhone, signal )
{
    CART_GOODS * goods = signal.sourceCell.data;
    
    if (  self.currentCell && self.currentCell != signal.sourceCell  )
    {
        self.currentCell.editing = NO;
        [self.editingState removeObject:goods.rec_id];
    }
    
    self.currentCell = (C0_ShoppingCartCell_iPhone *)signal.sourceCell;
    
    if ( [signal is:C0_ShoppingCartCell_iPhone.CART_EDIT_DONE] )
    {
        [self.editingState removeObject:goods.rec_id];
        
        if ( 0 == self.editingState.count )
        {
            [self setCheckoutEnabled:YES];
        }
        
        BOOL isChanged = ((NSNumber *)signal.object).boolValue;
        
        if ( isChanged )
        {
            [self.cartModel update:goods new_number: self.currentCell.count];
        }
    }
    else if ( [signal is:C0_ShoppingCartCell_iPhone.CART_REMOVE] )
    {
        BeeUIAlertView * alert = [BeeUIAlertView spawn];
        alert.title = __TEXT(@"shopcaritem_remove");
        alert.message = __TEXT(@"delete_confirm");
        [alert addButtonTitle:__TEXT(@"button_no") signal:self.REMOVE_CANCEL];
        [alert addButtonTitle:__TEXT(@"button_yes") signal:self.REMOVE_CONFIRM object:@{@"goods":goods}];
        [alert showInViewController:self];
    }
    else if ( [signal is:C0_ShoppingCartCell_iPhone.CART_EDIT_BEGAN] )
    {
        [self.editingState addObject:goods.rec_id];
        
        [self setCheckoutEnabled:NO];
    }
}

#pragma mark - C0_ShoppingCartBoard_iPhone

/**
 * 购物车-商品列表-移除商品，取消移除时执行该操作
 */
ON_SIGNAL3( C0_ShoppingCartBoard_iPhone, REMOVE_CANCEL, signal )
{
    self.currentCell.editing = YES;
    [self setCheckoutEnabled:NO];
}

/**
 * 购物车-商品列表-移除商品，确定移除时执行该操作
 */
ON_SIGNAL3( C0_ShoppingCartBoard_iPhone, REMOVE_CONFIRM, signal )
{
    CART_GOODS * goods = [(NSDictionary *)signal.object objectForKey:@"goods"];
    
    [self.editingState removeObject:goods.rec_id];
    [self.cartModel remove:goods];
}

#pragma mark -

- (void)setCheckoutEnabled:(BOOL)enabled;
{
    if ( enabled )
    {
        $(_checkoutCell).FIND(@"#checkout").ENABLE();
    }
    else
    {
        $(_checkoutCell).FIND(@"#checkout").DISABLE();
    }
}

- (void)handleLogined:(BOOL)logined
{
    self.list.headerShown = logined;
    [self.list setScrollEnabled:logined];
}

- (void)handleEmpty:(BOOL)isEmpty
{
    if ( isEmpty )
    {
        self.header.alpha = 0.f;
        $(self.list.headerLoader).FIND(@"#background").HIDE();
    }
    else
    {
        self.header.alpha = 1.f;
        $(self.list.headerLoader).FIND(@"#background").SHOW();
    }
}

#pragma mark -

ON_NOTIFICATION3( UserModel, LOGIN, notification )
{
    [self.cartModel reload];
    
    [self handleLogined:YES];
}

ON_NOTIFICATION3( UserModel, LOGOUT, notification )
{
	[self.list reloadData];

    [self handleLogined:NO];
}

ON_NOTIFICATION3( UserModel, KICKOUT, notification )
{
	[self.list reloadData];
    
    [self handleLogined:NO];
}

#pragma mark -

ON_MESSAGE3( API, cart_list, msg )
{
	if ( msg.sending )
	{
        //		if ( NO == self.cartModel.loaded )
        //		{
        //			[self presentLoadingTips:__TEXT(@"tips_loading")];
        //		}
	}
	else
	{
		[self.list setHeaderLoading:NO];
		
		[self dismissTips];
	}
	
	if ( msg.succeed )
	{
		STATUS * status = msg.GET_OUTPUT(@"status");
		
		if ( status && status.succeed.boolValue )
		{
			[self.editingState removeAllObjects];
			[self setCheckoutEnabled:YES];
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

ON_MESSAGE3( API, cart_delete, msg )
{
	if ( msg.sending )
	{
		[self presentLoadingTips:__TEXT(@"tips_removing")];
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
			[self.cartModel reload];
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

ON_MESSAGE3( API, address_list, msg )
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
			if ( self.addressListModel.addresses.count )
			{
				C1_CheckOutBoard_iPhone * board = [C1_CheckOutBoard_iPhone board];
				[self.stack pushBoard:board animated:YES];
			}
			else
			{
				F1_NewAddressBoard_iPhone * board = [F1_NewAddressBoard_iPhone board];
				board.shouldShowMessage = YES;
				[self.stack pushBoard:board animated:YES];
			}
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

ON_MESSAGE3( API, cart_update, msg )
{
	if ( msg.sending )
	{
		[self presentLoadingTips:__TEXT(@"tips_modifying")];
	}
	else
	{
		[self dismissTips];
	}
	
	if ( msg.succeed )
	{
		STATUS * status = msg.GET_OUTPUT( @"status" );
        
		if ( status.succeed.boolValue )
		{
			[self.cartModel reload];
		}
		else
		{
			[self presentFailureTips:__TEXT(@"error_8")];
		}
	}
	else if ( msg.failed )
	{
		[self showErrorTips:msg];
	}
}

@end
