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

#import "BaseBoard_iPhone.h"
#import "MobClick.h"

#pragma mark -

@implementation BaseBoard_iPhone

#pragma mark -

- (void)load
{
}

ON_CREATE_VIEWS( signal )
{
	self.view.backgroundColor = [UIImage imageNamed:@"index_body_bg.png"].patternColor;
}

ON_DELETE_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
	[MobClick beginLogPageView:[[self class] description]];
}

ON_WILL_DISAPPEAR( signal )
{
	[MobClick endLogPageView:[[self class] description]];
}

@end
