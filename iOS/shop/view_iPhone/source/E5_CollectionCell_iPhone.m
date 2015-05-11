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

#import "E5_CollectionCell_iPhone.h"

#pragma mark -

@implementation E5_CollectionCell_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_SIGNAL( TAPPED )
DEF_SIGNAL( REMOVE )

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
	COLLECT_GOODS * goods = self.data;
    
    BOOL isEditing = goods.isEditing;
    
	if ( goods )
	{
	    $(@".goods-photo").IMAGE( goods.img.thumbURL );
		$(@".goods-title").TEXT( goods.name );
		$(@".goods-price").TEXT( goods.shop_price );
		$(@".goods-subprice").TEXT( goods.market_price );
        
        if ( isEditing )
        {
            $(@"#delete").SHOW();
        }
        else
        {
            $(@"#delete").HIDE();
        }
	}
}

#pragma mark -ß

/**
 * 个人中心-我的收藏-商品取消按钮，点击事件触发时执行的操作
 */
ON_SIGNAL3( E5_CollectionCell_iPhone, delete, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
        [self sendUISignal:self.REMOVE];
    }
}

@end
