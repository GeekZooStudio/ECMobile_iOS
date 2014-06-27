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

#import "E1_PendingPaymentCell_iPhone.h"
#import "OrderCell_iPhone.h"
#import "E1_PendingPaymentCellFooter_iPhone.h"

#pragma mark -

@implementation E1_PendingPaymentCell_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( BeeUIScrollView, list )

DEF_SIGNAL( ORDER_CANCEL )
DEF_SIGNAL( ORDER_PAY )

+ (CGSize)estimateUISizeByWidth:(CGFloat)width forData:(id)data
{
    ORDER * order = data;
    
    CGSize size = CGSizeMake( width, [self.class heightByCount:order.goods_list.count] );
    return size;
}

+ (CGFloat)heightByCount:(NSInteger)count
{
    return ( 210 + 90 * count );
}

- (void)layoutDidFinish
{
    if ( self.data )
    {
        self.order = self.data;

        [self.list reloadData];
    }
}

- (void)dataDidChanged
{
    // 此时 self.frame 为 0，不适合在这里 [self.list reloadData]
}

- (void)load
{
    @weakify(self);
    
    self.list.scrollEnabled = NO;
    
    self.list.lineCount = 1;
    self.list.animationDuration = 0.25f;
    
    self.list.whenReloading = ^
    {
        @normalize(self);
        
        self.list.total = 3;
        self.list.total += self.order.goods_list.count;
        
        int offset = 0;
        
        BeeUIScrollItem * headerItem = self.list.items[0];
        headerItem.clazz = [OrderCellHeader_iPhone class];
        headerItem.data = self.order;
        headerItem.size = CGSizeMake( self.list.width, 50 );
        headerItem.rule = BeeUIScrollLayoutRule_Tile;
        
        offset += 1;
        
        for ( int i = 0; i < self.order.goods_list.count; i++ )
        {
            BeeUIScrollItem * item = [self.list.items safeObjectAtIndex:( i + offset  )];
            item.clazz = [OrderCellBody_iPhone class];
            item.size = CGSizeMake( self.list.width , 90 );
            item.data = [self.order.goods_list safeObjectAtIndex:i];
            item.rule = BeeUIScrollLayoutRule_Tile;
        }
        
        offset += self.order.goods_list.count;
        
        BeeUIScrollItem * orderInfoItem = self.list.items[offset];
        orderInfoItem.clazz = [OrderCellInfo_iPhone class];
        orderInfoItem.data = self.order;
        orderInfoItem.size = CGSizeMake( self.list.width, 70 );
        orderInfoItem.rule = BeeUIScrollLayoutRule_Tile;
        
        offset += 1;
        
        BeeUIScrollItem * footerItem = self.list.items[offset];
        footerItem.clazz = [E1_PendingPaymentCellFooter_iPhone class];
        footerItem.data = self.order;
        footerItem.size = CGSizeMake( self.list.width, 90 );
        footerItem.rule = BeeUIScrollLayoutRule_Tile;
        
        offset += 1;
    };
}

- (void)unload
{
	self.list = nil;
}

#pragma mark - E1_PendingPaymentCellFooter_iPhone

/**
 * 个人中心-待付款订单-订单列表-取消订单，点击事件触发时执行的操作
 */
ON_SIGNAL3( E1_PendingPaymentCellFooter_iPhone, cancel, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
        [self sendUISignal:self.ORDER_CANCEL];
    }
}

/**
 * 个人中心-待付款订单-订单列表-付款，点击事件触发时执行的操作
 */
ON_SIGNAL3( E1_PendingPaymentCellFooter_iPhone, pay, signal )
{
	if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
	{
		[self sendUISignal:self.ORDER_PAY];
	}
}

@end
