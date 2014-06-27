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
#import "CommonTagList.h"

#pragma mark -

/**
 * 商品列表-筛选列表cell
 */
@interface D2_FilterCell_iPhone : BeeUICell

AS_OUTLET( BeeUILabel,		title )
AS_OUTLET( CommonTagList,	taglist )
AS_OUTLET( BeeUIImageView,	indictor )

@property (nonatomic, assign) BOOL expaned;

@end
