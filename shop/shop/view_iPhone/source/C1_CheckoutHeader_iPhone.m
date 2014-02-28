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

#import "C1_CheckoutHeader_iPhone.h"

#pragma mark -

@implementation C1_CheckoutHeader_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

- (void)dataDidChanged
{
    if ( self.data )
    {
        ADDRESS * address = self.data;
        
        $(@"#address-name").TEXT( address.consignee );
        $(@"#phone").TEXT( address.tel );
        $(@"#location").TEXT( address.region );
        $(@"#address").TEXT( address.address );
    }
}

@end
