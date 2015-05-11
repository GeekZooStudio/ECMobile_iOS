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

#import "C1_CheckoutOrderCell_iPhone.h"
#import "C1_CheckoutOrderCellHeader_iPhone.h"
#import "C1_CheckoutOrderCellInfo_iPhone.h"
#import "C1_CheckoutOrderCellBody_iPhone.h"
#import "C1_CheckoutOrderCellFooter_iPhone.h"

#pragma mark -

@implementation C1_CheckoutOrderCell_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( BeeUIScrollView, list )

- (CGSize)estimateUISizeByWidth:(CGFloat)width
{
    NSUInteger count = ((FlowModel *)self.data).goods_list.count;
    CGFloat height = 184 + 32 * count; // 184 = 30 + 79 + 75
    CGSize size = CGSizeMake( width, height );
    return size;
}

- (void)layoutDidFinish
{
    if ( self.data )
    {

        [self.list reloadData];
    }
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
        
        FlowModel *	model = self.data;
        
        self.list.total = 3;
        self.list.total += model.goods_list.count;
        
        int offset = 0;
        
        BeeUIScrollItem * headerItem = self.list.items[0];
        headerItem.clazz = [C1_CheckoutOrderCellHeader_iPhone class];
        headerItem.data = model;
        headerItem.size = CGSizeMake( self.list.width, 32 );
        headerItem.rule = BeeUIScrollLayoutRule_Tile;
        
        offset += 1;
        
        for ( int i = 0; i < model.goods_list.count; i++ )
        {
            BeeUIScrollItem * item = [self.list.items safeObjectAtIndex:( i + offset  )];
            item.clazz = [C1_CheckoutOrderCellBody_iPhone class];
            item.size = CGSizeMake( self.list.width , 30 );
            item.data = [model.goods_list safeObjectAtIndex:i];
            item.rule = BeeUIScrollLayoutRule_Tile;
        }
        
        offset += model.goods_list.count;
        
        BeeUIScrollItem * orderInfoItem = self.list.items[offset];
        orderInfoItem.clazz = [C1_CheckoutOrderCellInfo_iPhone class];
        orderInfoItem.data = model;
        orderInfoItem.size = CGSizeMake( self.list.width, 79 );
        orderInfoItem.rule = BeeUIScrollLayoutRule_Tile;
        
        offset += 1;
        
        BeeUIScrollItem * footerItem = self.list.items[offset];
        footerItem.clazz = [C1_CheckoutOrderCellFooter_iPhone class];
        footerItem.data = [self sumprice];
        footerItem.size = CGSizeMake( self.list.width, 75 );
        footerItem.rule = BeeUIScrollLayoutRule_Tile;
        
        offset += 1;
    };
}

- (NSNumber *)sumprice
{
	FlowModel *	model = self.data;
    CGFloat sumprice = 0;
    
    for ( CART_GOODS * goods in model.goods_list )
    {
        sumprice += goods.goods_price.doubleValue * goods.goods_number.integerValue;
    }
    
    sumprice += model.done_shipping.shipping_fee.doubleValue;
    sumprice -= model.data_integral.doubleValue;
    sumprice -= model.data_bonus.type_money.doubleValue;
    
    return @(sumprice);
}

@end
