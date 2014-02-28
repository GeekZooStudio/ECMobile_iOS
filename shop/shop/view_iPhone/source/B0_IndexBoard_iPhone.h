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

#import "model.h"
#import "controller.h"

#import "UIViewController+ErrorTips.h"

#pragma mark -

@interface B0_IndexBoard_iPhone : BaseBoard_iPhone

AS_MODEL( BannerModel,		bannerModel );
AS_MODEL( CategoryModel,	categoryModel );

AS_OUTLET( BeeUIScrollView, list )

@end
