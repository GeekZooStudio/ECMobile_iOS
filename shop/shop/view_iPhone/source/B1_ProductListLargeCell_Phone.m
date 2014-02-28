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

#import "B1_ProductListLargeCell_Phone.h"

#pragma mark -

@implementation B1_ProductListLargeCell_Phone

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
	    $(@".goods-photo-large").IMAGE( goods.img.largeURL );
		$(@".goods-title-large").TEXT( goods.name );
		
		if ( goods.promote_price && goods.promote_price.length > 0 )
		{
			$(@".goods-price-large").TEXT( [NSString stringWithFormat:@"%@: %@", __TEXT(@"formerprice"), goods.promote_price] );
		}
		else
		{
			$(@".goods-price-large").TEXT( [NSString stringWithFormat:@"%@: %@", __TEXT(@"store_price"), goods.shop_price] );
		}
        
		$(@".goods-subprice-large").TEXT( [NSString stringWithFormat:@"%@: %@", __TEXT(@"market_price"), goods.market_price] );
        //		$(@".goods-sales-large").TEXT( @"月销量" );
        //		$(@".goods-sales-volume-large").TEXT( @"1,999" );
	}
}

#pragma mark -

ON_SIGNAL2( BeeUIImageView, signal )
{
    if ( [signal is:BeeUIImageView.LOAD_FAILED] )
    {
        // find the images and set the placeholder
        $(@".goods-photo-large").IMAGE( [UIImage imageNamed:@"placeholder_image.png"] );
    }
}

@end
