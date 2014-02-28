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
#import "BaseBoard_iPhone.h"

#import "controller.h"
#import "model.h"

#import "FormCell.h"

#import "UIViewController+ErrorTips.h"

@interface F3_RegionPickBoard_iPhone : BaseBoard_iPhone

AS_OUTLET( BeeUIScrollView, list )

AS_MODEL( RegionModel, regionModel )

@property (nonatomic, retain) BeeUIBoard * rootBoard;
@property (nonatomic, retain) NSMutableArray * regions;

@property (nonatomic, assign) NSInteger level;
@property (nonatomic, retain) ADDRESS * address;

@property (nonatomic, copy) void (^whenRegionChanged)(ADDRESS * address);

@end