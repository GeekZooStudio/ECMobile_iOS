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

#import "B3_ProductPhotoSlideCell_iPhone.h"

#pragma mark -

@implementation B3_ProductPhotoSlideCell_iPhone

SUPPORT_RESOURCE_LOADING( YES );
SUPPORT_AUTOMATIC_LAYOUT( YES );

- (void)layoutDidFinish
{
    _photo.frame = self.bounds;
    _zoomView.frame = self.bounds;
    [_zoomView setContentSize:self.bounds.size];
    [_zoomView layoutContent];
}

- (void)load
{
    _photo = [[BeeUIImageView alloc] init];
    _photo.indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    _photo.contentMode = UIViewContentModeScaleAspectFit;
    
    _zoomView = [[BeeUIZoomView alloc] init];
    _zoomView.backgroundColor = [UIColor blackColor];
    [_zoomView setContent:_photo animated:NO];
    [self addSubview:_zoomView];
}

- (void)unload
{
	SAFE_RELEASE_SUBVIEW( _photo );
	SAFE_RELEASE_SUBVIEW( _zoomView );
}

- (void)dataDidChanged
{
    PHOTO * photo = self.data;
    
	if ( photo )
	{
        [_photo GET:photo.largeURL
		   useCache:YES
		placeHolder:[UIImage imageNamed:@"placeholder_image.png"]];
	}
}

@end
