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

#import "B0_BannerPhotoCell_iPhone.h"
#import "PHOTO+AutoSelection.h"

#pragma mark -

@implementation B0_BannerPhotoCell_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( BeeUIImageView, photo )

- (void)load
{
}

- (void)unload
{
}

- (void)dataDidChanged
{
    BANNER * banner = self.data;
	if ( banner )
	{
        self.photo.data = banner.photo.largeURL;
	}
}

@end
