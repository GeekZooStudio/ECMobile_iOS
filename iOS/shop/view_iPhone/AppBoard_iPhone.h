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
#import "model.h"

#import "AppTabbar_iPhone.h"

#pragma mark -

AS_UI( AppBoard_iPhone, appBoard )

#pragma mark -

@interface AppBoard_iPhone : BeeUIBoard

AS_SINGLETON( AppBoard_iPhone )

/**
 * 底部菜单-首页，点击时会触发该事件
 */
AS_SIGNAL( TAB_HOME )

/**
 * 底部菜单-搜索，点击时会触发该事件
 */
AS_SIGNAL( TAB_SEARCH )

/**
 * 底部菜单-购物车，点击时会触发该事件
 */
AS_SIGNAL( TAB_CART )

/**
 * 底部菜单-个人中心，点击时会触发该事件
 */
AS_SIGNAL( TAB_USER )

/**
 * 通知消息 - 前往
 */
AS_SIGNAL( NOTIFY_FORWARD )

/**
 * 通知消息 - 忽略
 */
AS_SIGNAL( NOTIFY_IGNORE )

AS_MODEL( ConfigModel,	configModel )
AS_MODEL( UserModel,	userModel )

- (void)showLogin;
- (void)hideLogin;

- (void)showTabbar;
- (void)hideTabbar;

@end
