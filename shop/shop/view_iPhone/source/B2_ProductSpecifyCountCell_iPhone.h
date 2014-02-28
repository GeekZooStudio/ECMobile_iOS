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

#import "Bee.h"

#pragma mark -

/**
 * 商品详情-指定商品数量和配置-指定数量cell
 */
@interface B2_ProductSpecifyCountCell_iPhone : BeeUICell

@property (nonatomic, assign) NSUInteger        max;
@property (nonatomic, readonly) NSNumber *      count;
@property (nonatomic, retain) BeeUILabel *      label;
@property (nonatomic, retain) BeeUIButton *     pluss;
@property (nonatomic, retain) BeeUIButton *     minus;
@property (nonatomic, retain) BeeUITextField *  input;

/**
 * 商品详情-指定商品数量和配置，商品数量改变时触发该事件
 */
AS_SIGNAL( COUNT_CHANGED )

@end
