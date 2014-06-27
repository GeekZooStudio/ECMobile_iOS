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

#import "B2_ProductDetailCell_iPhone.h"
#import "B2_ProductDetailSlideCell_iPhone.h"

#pragma mark -

@interface B2_ProductDetailCell_iPhone()
{
    NSArray * _pictures;
}

@end

@implementation B2_ProductDetailCell_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( BeeUIScrollView, list )

- (void)load
{
    @weakify(self);
    
    self.list.animationDuration = 0.25f;
    
    self.list.whenReloading = ^
    {
        @normalize(self);
        
        self.list.total = _pictures.count;
        
        for ( BeeUIScrollItem * item in self.list.items )
        {
            item.clazz = [B2_ProductDetailSlideCell_iPhone class];
            item.size = CGSizeMake( 174, self.list.height );
            item.data = [_pictures safeObjectAtIndex:item.index];
            item.rule = BeeUIScrollLayoutRule_Tile;
        }
    };
}

- (void)unload
{
}

- (void)layoutDidFinish
{
    if ( _pictures.count )
    {
        [self.list reloadData];
    }
}

- (void)dataDidChanged
{
    GoodsInfoModel * goodsModel = [self.data objectForKey:@"goodsModel"];
    
    if ( goodsModel )
    {
        // name
        $(@"#goods-title").TEXT( goodsModel.goods.goods_name );
        
        // price
        if ( goodsModel.goods.promote_price.length && goodsModel.goods.promote_price.integerValue )
        {
            $(@"#goods-price").TEXT( goodsModel.goods.formated_promote_price );
        }
        else
        {
            $(@"#goods-price").TEXT( goodsModel.goods.shop_price );
        }
        
		$(@"#goods-subprice").TEXT( goodsModel.goods.market_price );
        
        // pictures
        if ( goodsModel.goods.pictures && goodsModel.goods.pictures.count > 0 )
        {
            _pictures = goodsModel.goods.pictures;
        }
        else
        {
            $(@"#list").HIDE();
        }
        
		// info
		NSMutableString * goodsInfo = [NSMutableString string];
        NSString * infoStr = [NSString stringWithFormat:@"%@: %@\n", __TEXT(@"shipping_fee"), goodsModel.goods.is_shipping.boolValue ?  __TEXT(@"shipping_fee_free") : __TEXT(@"shipping_fee_notfree")];
		[goodsInfo appendString:infoStr];
        
        infoStr = [NSString stringWithFormat:@"%@: %@\n", __TEXT(@"remain"), goodsModel.goods.goods_number];
		[goodsInfo appendString:infoStr];
        
        infoStr = [NSString stringWithFormat:@"%@: %@\n", __TEXT(@"shop_price"), goodsModel.goods.shop_price];
		[goodsInfo appendString:infoStr];
        
        infoStr = [NSString stringWithFormat:@"%@: %@\n", __TEXT(@"market_price"), goodsModel.goods.market_price];
		[goodsInfo appendString:infoStr];
        
		for ( GOOD_RANK_PRICE * price in goodsModel.goods.rank_prices )
		{
            infoStr = [NSString stringWithFormat:@"%@: %@\n", price.rank_name, price.price];
            [goodsInfo appendString:infoStr];
		}
        
        $(@"#goods-info").TEXT( goodsInfo );
        
        if ( goodsModel.goods.promote_end_date )
        {
            NSDate * endDate = [goodsModel.goods.promote_end_date asNSDate];
            
            if ( NSOrderedDescending == [endDate compare:[NSDate date]] )
            {
                $(@"#countdown").SHOW();
                $(@"#countdown").DATA( endDate );
            }
            else
            {
                $(@"#countdown").HIDE();
            }
        }
        else
        {
            $(@"#countdown").HIDE();
        }
        
        // 数量默认显示 1
        // 多选：请选择
        // 必选的：有一个值，默认选择；多个值，请选择
        
        NSArray * specs = [self.data objectForKey:@"specs"];
        NSNumber * count = [self.data objectForKey:@"count"];
        NSNumber * specfied = [self.data objectForKey:@"specfied"];
        
        if ( specfied.boolValue )
        {
            NSString * string = [self stringWithSpecs:specs count:count];
            
            $(@"#specification-title").DATA(string);
        }
        else
        {
            $(@"#specification-title").DATA(__TEXT(@"specs_tips"));
        }
    }
}

//- (void)updateSpec:(NSArray *)specs count:(NSNumber *)count
- (NSString *)stringWithSpecs:(NSArray *)specs count:(NSNumber *)count
{
    NSMutableString * string = [NSMutableString string];
    
    for ( GOOD_SPEC_VALUE * spec_value in specs )
    {
        [string appendFormat:@"%@: %@\n", spec_value.spec.name, spec_value.value.label];
    }
    
    [string appendFormat:@"%@: %@", __TEXT(@"amount"), count];
    
    return string;
}

@end
