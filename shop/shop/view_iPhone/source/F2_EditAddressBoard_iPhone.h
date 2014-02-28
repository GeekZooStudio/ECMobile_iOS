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

#import "UIViewController+ErrorTips.h"

#pragma mark -

/**
 * 收货地址管理-修改收货地址board
 */
@interface F2_EditAddressBoard_iPhone : BaseBoard_iPhone

AS_OUTLET( BeeUIScrollView, list )

AS_MODEL( AddressListModel, addressListModel )
AS_MODEL( RegionModel,		regionModel );

/**
 * 收货地址管理-修改收货地址-删除地址，确认删除地址时触发该事件
 */
AS_SIGNAL( DELETE_CONFIRM )

@property (nonatomic, retain) ADDRESS * address;

@end