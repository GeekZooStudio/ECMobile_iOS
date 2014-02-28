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

#import "F2_EditAddressCell_iPhone.h"

#pragma mark -

@implementation F2_EditAddressCell_iPhone

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
        ADDRESS * address = self.data;

        $(@"#tel").TEXT( address.tel );
        $(@"#name").TEXT( address.consignee );
        $(@"#email").TEXT( address.email );
        $(@"#zipcode").TEXT( address.zipcode );
        $(@"#address").TEXT( address.address );

        NSString * region = address.region;
        if ( region && region.length )
        {
            $(@"#location-label").TEXT( region );
        }
        else
        {
            $(@"#location-label").TEXT( __TEXT(@"please_select") );
        }
    }
}

#pragma mark -

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

@end
