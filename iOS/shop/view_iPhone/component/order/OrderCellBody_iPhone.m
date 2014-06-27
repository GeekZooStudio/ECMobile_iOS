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

#import "OrderCellBody_iPhone.h"

#pragma mark -

@implementation OrderCellBody_iPhone

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
    ORDER_GOODS * goods = self.data;
    
    $(@"#order-goods-count").TEXT( [NSString stringWithFormat:@"X %@", goods.goods_number] );
    $(@"#order-goods-price").TEXT( goods.formated_shop_price );
    $(@"#order-goods-title").TEXT( goods.name );
    $(@"#order-goods-photo").IMAGE( goods.img.thumbURL );
}

@end
