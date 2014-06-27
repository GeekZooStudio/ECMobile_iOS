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

#import "C1_CheckoutOrderCellFooter_iPhone.h"

#pragma mark -

@implementation C1_CheckoutOrderCellFooter_iPhone

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
    $(@"#cart-goods-desc").TEXT( __TEXT(@"balance_rental") );
    
    if ( self.data )
    {
        $(@"#cart-goods-price").TEXT( [NSString stringWithFormat:@"%@ %@", self.data, __TEXT(@"yuan")]);
    }
    else
    {
        $(@"#cart-goods-price").TEXT( [NSString stringWithFormat:@"0.00 %@", __TEXT(@"yuan")] );
    }
}

@end
