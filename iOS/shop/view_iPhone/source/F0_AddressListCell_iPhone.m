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

#import "F0_AddressListCell_iPhone.h"

#pragma mark -

@implementation F0_AddressListCell_iPhone

DEF_SIGNAL( TOUCHED )

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

- (void)load
{
    self.tappable = YES;
    self.tapSignal = self.TOUCHED;
}

- (void)dataDidChanged
{
    if ( self.data )
    {
        ADDRESS * address = self.data;
        
        $(@"#name").TEXT( address.consignee );
        $(@"#location").TEXT( address.region );
        $(@"#location-detail").TEXT( address.address );
        
        if ( address.default_address.boolValue )
        {
            $(@"#list-indictor").SHOW();
            $(@"#name").CSS(@"color: #2097C8");
            //            $(@"#location").CSS(@"color: #2097C8");
            //            $(@"#location-detail").CSS(@"color: #2097C8");
        }
        else
        {
            $(@"#list-indictor").HIDE();
            $(@"#name").CSS(@"color: #333");
            //            $(@"#location").CSS(@"color: #333");
            //            $(@"#location-detail").CSS(@"color: #333");
        }
    }
}

@end
