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

#import "ConfigModel.h"
#import "G0_SettingCell_iPhone.h"

#pragma mark -

@implementation G0_SettingCell_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( BeeUIImageView, setting_smartmode_accessory )
DEF_OUTLET( BeeUIImageView, setting_hqpicture_accessory )
DEF_OUTLET( BeeUIImageView, setting_normal_accessory )
DEF_OUTLET( BeeUISwitch, sina_weibo )
DEF_OUTLET( BeeUISwitch, tencent_weibo )

- (void)dataDidChanged
{
    if ( self.data )
    {
        self.setting_smartmode_accessory.hidden = YES;
        self.setting_hqpicture_accessory.hidden = YES;
        self.setting_normal_accessory.hidden = YES;
        
        [self setLogin:[self.data[@"user_online"] boolValue]];
        [self setPhotoMode:[self.data[@"setting_picture"] integerValue]];
								
        self.sina_weibo.on = [self.data[@"sina_weibo"] boolValue];
        self.tencent_weibo.on = [self.data[@"tencent_weibo"] boolValue];
    }
}

- (void)setLogin:(BOOL)login
{
    if ( !login )
    {
        $(@".logout").HIDE();
    }
    else
    {
        $(@".logout").SHOW();
    }
}

- (void)setPhotoMode:(NSUInteger)mode
{
    switch (mode)
    {
        case 0: // ConfigModel.PHOTO_MODE_AUTO
            self.setting_smartmode_accessory.hidden = NO;
            break;
        case 1: // ConfigModel.PHOTO_MODE_HIGH
            self.setting_hqpicture_accessory.hidden = NO;
            break;
        case 2: // ConfigModel.PHOTO_MODE_LOW
        default:
            self.setting_normal_accessory.hidden = NO;
            break;
    }
}

- (void)layoutDidFinish
{
    
}

@end
