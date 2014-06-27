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

#import "controller.h"
#import "model.h"

#import "AppBoard_iPhone.h"
#import "BaseBoard_iPhone.h"
#import "H0_BrowserBoard_iPhone.h"

#import "UIViewController+ErrorTips.h"

#pragma mark -

@interface H1_PayBoard_iPhone : H0_BrowserBoard_iPhone

AS_MODEL( OrderModel, orderModel )

@property (nonatomic, retain) NSNumber *	orderID;

// TODO:CALLBACKURL
@property (nonatomic, retain) NSString * 	wapCallBackURL;

// FIXME:CHENGYUN coding style
@property (nonatomic, retain) ORDER_INFO * 	order_info;

@end
