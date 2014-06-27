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

#import "SettingModel.h"

#pragma mark -

@implementation SettingModel

DEF_SINGLETON( SettingModel )

DEF_INT( PHOTO_MODE_AUTO,	0 )
DEF_INT( PHOTO_MODE_HIGH,	1 )
DEF_INT( PHOTO_MODE_LOW,	2 )

@synthesize photoMode = _photoMode;

- (void)load
{
	[self loadCache];
}

- (void)unload
{
	[self saveCache];
}

#pragma mark -

- (void)loadCache
{
	self.photoMode = [[self userDefaultsRead:@"SettingModel.photoMode"] integerValue];
}

- (void)saveCache
{
	[self userDefaultsWrite:@(self.photoMode) forKey:@"SettingModel.photoMode"];
}

- (void)clearCache
{
	self.photoMode = self.PHOTO_MODE_AUTO;

	self.loaded = NO;
}

@end
