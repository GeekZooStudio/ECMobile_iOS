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
 * 购物车-商品列表-编辑界面cell
 */
@interface C0_ShoppingCartEditCell_iPhone : BeeUICell

@property (nonatomic, readonly) NSNumber *      count;
@property (nonatomic, retain) BeeUIButton *     pluss;
@property (nonatomic, retain) BeeUIButton *     minus;
@property (nonatomic, retain) BeeUIButton *     remove;
@property (nonatomic, retain) BeeUITextField *  input;

@end
