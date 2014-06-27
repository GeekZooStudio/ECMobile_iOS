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

#import "E1_PendingPaymentCellFooter_iPhone.h"

#pragma mark -

@implementation E1_PendingPaymentCellFooter_iPhone

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
		ORDER * order = self.data;
		
        $(@"#cart-goods-price").TEXT( order.total_fee );
		
		if ( [order.order_info.pay_code isEqualToString:@"cod"] )
		{
			$(@"#pay").HIDE();
		}
		else
		{
			$(@"#pay").SHOW();
		}
    }
    else
    {
        $(@"#cart-goods-price").TEXT(@"0.00");
    }
}

@end
