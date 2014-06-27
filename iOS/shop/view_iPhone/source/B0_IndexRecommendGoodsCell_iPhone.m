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

#import "B0_IndexRecommendGoodsCell_iPhone.h"
#import "PHOTO+AutoSelection.h"

#pragma mark -

@implementation B0_IndexRecommendGoodsCell_iPhone

SUPPORT_RESOURCE_LOADING( YES )
SUPPORT_AUTOMATIC_LAYOUT( YES )

- (void)load
{
}

- (void)unload
{
}

- (void)dataDidChanged
{
	SIMPLE_GOODS * goods = self.data;
	if ( goods )
	{
//		$(@"#goods-subprice").TEXT( goods.market_price );
	    $(@"#recommend-goods-price").TEXT( [goods.promote_price empty] ? goods.shop_price : goods.promote_price );
		$(@"#recommend-goods-image").IMAGE( goods.img.thumbURL );
	}
}

@end
