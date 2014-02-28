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

#import "C1_CheckoutOrderCellInfo_iPhone.h"

#pragma mark -

@implementation C1_CheckoutOrderCellInfo_iPhone

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
        FlowModel * model = self.data;
        
        if ( [model.done_shipping.shipping_fee notEmpty] )
        {
            $(@"#ship").TEXT( [NSString stringWithFormat:@"+ %@", model.done_shipping.shipping_fee] );
        }
        else
        {
            $(@"#ship").TEXT( [NSString stringWithFormat:@"+ %@0.0%@", __TEXT(@"yuan_unit"), __TEXT(@"yuan")] );
        }
        
        if ( [model.data_bonus.bonus_money_formated notEmpty] )
        {
            $(@"#bonus").TEXT( [NSString stringWithFormat:@"- %@", model.data_bonus.bonus_money_formated] );
        }
        else
        {
            $(@"#bonus").TEXT( [NSString stringWithFormat:@"- %@0.0%@", __TEXT(@"yuan_unit"), __TEXT(@"yuan")] );
        }
        
        if ( [model.data_integral_formated notEmpty] )
        {
            $(@"#integral").TEXT( [NSString stringWithFormat:@"- %@", model.data_integral_formated] );
        }
        else
        {
            $(@"#integral").TEXT( [NSString stringWithFormat:@"- %@0.0%@", __TEXT(@"yuan_unit"), __TEXT(@"yuan")] );
        }
    }
}

@end
