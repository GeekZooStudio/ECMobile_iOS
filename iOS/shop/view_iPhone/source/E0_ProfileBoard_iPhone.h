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

AS_UI( E0_ProfileBoard_iPhone, profile )

@interface E0_ProfileBoard_iPhone : BaseBoard_iPhone<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

AS_SINGLETON( E0_ProfileBoard_iPhone )

/**
 * 个人中心-头像-修改头像（拍照），点击时触发该事件
 */
AS_SIGNAL( PHOTO_FROM_CAMERA )

/**
 * 个人中心-头像-修改头像（从相册选择），点击时触发该事件
 */
AS_SIGNAL( PHOTO_FROM_LIBRARY )

/**
 * 个人中心-头像-删除头像，点击时触发该事件
 */
AS_SIGNAL( PHOTO_REMOVE )

AS_MODEL( UserModel,			userModel );

AS_OUTLET( BeeUIScrollView, list )

@end
