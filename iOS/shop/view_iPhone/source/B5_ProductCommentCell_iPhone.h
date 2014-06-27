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
 * 商品详情-商品评论列表中cell
 */
@interface B5_ProductCommentCell_iPhone : BeeUICell

AS_OUTLET( BeeUIImageView, background )
AS_OUTLET( BeeUILabel, creator )
AS_OUTLET( BeeUILabel, date )
AS_OUTLET( BeeUILabel, content );

@end
