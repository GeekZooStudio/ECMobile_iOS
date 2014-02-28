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

#import "AppClosed_iPhone.h"

#pragma mark -

DEF_UI( AppClosed_iPhone, closed )

#pragma mark -

@implementation AppClosed_iPhone

DEF_SINGLETON( AppClosed_iPhone )

SUPPORT_RESOURCE_LOADING( YES )

- (void)load
{
	self.hidden = YES;
}

- (void)unload
{
}

@end
