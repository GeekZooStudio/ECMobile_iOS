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

#import "B1_ProductListGridCell_iPhone.h"

#pragma mark -

@implementation B1_ProductListGridCell_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_SIGNAL( TAPPED )

- (void)load
{
    self.tappable = YES;
    self.tapSignal = self.TAPPED;
}

- (void)unload
{
}

- (void)dataDidChanged
{
	SIMPLE_GOODS * goods = self.data;
	if ( goods )
	{
	    $(@".goods-photo").IMAGE( goods.img.thumbURL );
		$(@".goods-title").TEXT( goods.name );
		$(@".goods-price").TEXT( goods.promote_price.length > 0 ? goods.promote_price : goods.shop_price );
		$(@".goods-subprice").TEXT( goods.market_price );
        //		$(@".goods-sales").TEXT( @"月销量" );
        //		$(@".goods-sales-volume").TEXT( @"1,999" );
	}
}

#pragma mark - 

ON_SIGNAL2( BeeUIImageView, signal )
{
    if ( [signal is:BeeUIImageView.LOAD_FAILED] )
    {
        $(@".goods-photo").IMAGE( [UIImage imageNamed:@"placeholder_image.png"] );
    }
}

@end
