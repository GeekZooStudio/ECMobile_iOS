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

#import "C2_PaymentCell_iPhone.h"

#pragma mark -

@implementation C2_PaymentCell_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

- (void)dataDidChanged
{
    if ( self.data )
    {
        PAYMENT * payment = self.data;
        self.title.data = payment.pay_name;
//        self.subtitle.data = payment.format_pay_fee;
        self.accessory.hidden = !payment.scrollSelected;
    }
}
@end
