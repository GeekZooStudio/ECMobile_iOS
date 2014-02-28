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

@class CommonTagList;

@interface GoodsSpecifyBoardCellData : NSObject
@property (nonatomic, retain) NSArray *  tags;
@property (nonatomic, retain) NSArray * selectedTags;
@property (nonatomic, retain) GOOD_SPEC * spec;
@end

#pragma mark -

/**
 * 商品详情-指定商品数量和配置-配置单cell
 */
@interface B2_ProductSpecifyCell_iPhone : BeeUICell

@property (nonatomic, assign) NSInteger   index;

AS_OUTLET( BeeUILabel,		title )
AS_OUTLET( CommonTagList,	taglist )

@end
