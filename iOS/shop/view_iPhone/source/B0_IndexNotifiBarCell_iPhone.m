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

#import "B0_IndexNotifiBarCell_iPhone.h"

#pragma mark -

@implementation B0_IndexNotifiBarCell_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

- (void)load
{
	self.layer.masksToBounds = NO;
}

- (void)unload
{
}

- (void)dataDidChanged
{
    NSNumber * number = self.data;
    
    if ( number && number.integerValue > 0 )
    {
        $(@"#badge-bg").SHOW();
        $(@"#badge-count").SHOW();
        $(@"#badge-count").TEXT( [NSString stringWithFormat:@"%@", self.data] );
    }
    else
    {
        $(@"#badge-bg").HIDE();
        $(@"#badge-count").HIDE();
    }
}

@end
