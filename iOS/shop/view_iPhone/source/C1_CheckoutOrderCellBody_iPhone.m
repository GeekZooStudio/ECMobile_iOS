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

#import "C1_CheckoutOrderCellBody_iPhone.h"

#pragma mark -

@implementation C1_CheckoutOrderCellBody_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

- (void)load
{
}

- (void)unload
{
}

- (void)dataDidChanged
{
    if ( self.data )
    {
        CART_GOODS * goods = self.data;
        $(@"#order-goods-count").TEXT( [NSString stringWithFormat:@"X %@", goods.goods_number] );
        $(@"#order-goods-price").TEXT( goods.formated_goods_price );
        $(@"#order-goods-title").TEXT( goods.goods_name );
    }
}

@end
