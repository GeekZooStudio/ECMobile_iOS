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

#import "B2_ProductDetailSlideCell_iPhone.h"

#pragma mark -

@implementation B2_ProductDetailSlideCell_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_SIGNAL( TOUCHED )

- (void)load
{
    self.tappable = YES;
    self.tapSignal = self.TOUCHED;
}

- (void)unload
{
}

- (void)dataDidChanged
{
    if ( self.data )
    {
        PHOTO * photo = self.data;
        
        $(@"#slide-image").IMAGE( photo.thumbURL );
    }
}

ON_SIGNAL2( BeeUIImageView, signal )
{
    if ( [signal is:BeeUIImageView.LOAD_FAILED] )
    {
        $(@"#slide-image").IMAGE( [UIImage imageNamed:@"placeholder_image.png"] );
    }
}

@end
