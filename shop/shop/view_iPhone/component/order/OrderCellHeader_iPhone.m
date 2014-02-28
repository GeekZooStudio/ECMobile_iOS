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

#import "OrderCellHeader_iPhone.h"

#pragma mark -

@implementation OrderCellHeader_iPhone

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
        ORDER * order = self.data;
        
        if ( order.order_time )
        {
            $(@"#order-date-label").SHOW();
            $(@"#order-date").SHOW();
            
            NSDate * date = [order.order_time asNSDate];
            
            $(@"#order-date-label").TEXT( __TEXT(@"tradeitem_time") );
            $(@"#order-date").TEXT( [date stringWithDateFormat:@"yyyy-MM-dd HH:mm"] );
        }
        else
        {
            $(@"#order-date-label").HIDE();
            $(@"#order-date").HIDE();
        }
        
        if ( order.order_sn )
        {
            $(@"#order-number-label").SHOW();
            $(@"#order-number").SHOW();
            
            $(@"#order-number-label").TEXT( __TEXT(@"tradeitem_number") );
            $(@"#order-number").TEXT( order.order_sn );
        }
        else
        {
            $(@"#order-number-label").HIDE();
            $(@"#order-number").HIDE();
        }
    }
}

@end
