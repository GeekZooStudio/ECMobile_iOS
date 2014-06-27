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
//  Powered by BeeFramework
//
	
#import "Bee.h"
#import "model.h"
#import "BaseBoard_iPhone.h"

#pragma mark -

/**
 * 商品详情-指定商品数量和配置对应的board
 */
@interface B2_ProductSpecifyBoard_iPhone : BeeUIBoard

AS_OUTLET( BeeUIButton, mask )
AS_OUTLET( BeeUIImageView, background )
AS_OUTLET( BeeUIScrollView, list )

@property (nonatomic, retain) GOODS *           goods;
@property (nonatomic, retain) NSMutableArray *  specs;
@property (nonatomic, retain) NSNumber *        count;
@property (nonatomic, retain) NSMutableArray *  taglistData;

@property (nonatomic, copy) void (^whenCanceled)();
@property (nonatomic, copy) void (^whenSpecified)( NSArray * specs, NSNumber * count );

- (void)setSpecsFromArray:(NSArray *)specs;

@end