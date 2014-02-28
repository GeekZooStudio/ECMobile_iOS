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

#import "OrderCellInfo_iPhone.h"

#pragma mark -

@implementation OrderCellInfo_iPhone

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
    ORDER * order = self.data;
    
    if ( order )
    {
        self.formated_integral_money = order.formated_integral_money;
        self.formated_bonus = order.formated_bonus;
        self.formated_shipping_fee = order.formated_shipping_fee;
    }
    
    $(@"#ship").TEXT( self.formated_shipping_fee );
    $(@"#bonus").TEXT( [NSString stringWithFormat:@"- %@", self.formated_bonus] );
    $(@"#integral").TEXT( [NSString stringWithFormat:@"- %@", self.formated_integral_money] );
}

@end
