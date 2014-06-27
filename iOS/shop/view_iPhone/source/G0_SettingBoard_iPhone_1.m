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

#import "G0_SettingBoard_iPhone.h"
#import "H0_BrowserBoard_iPhone.h"
#import "AppBoard_iPhone.h"

#import "G0_SettingCell_iPhone.h"
#import "ECMobilePushConfig.h"

#import "bee.services.share.sinaweibo.h"
#import "bee.services.share.tencentweibo.h"

#import "ECMobileManager.h"
#import "ECMobileAppConfig.h"

#import "UMFeedback.h"
#import "UMFeedbackViewController.h"

#pragma mark -

@interface G0_SettingBoard_iPhone()
@property (nonatomic, retain) G0_SettingCell_iPhone * settingCell;
@end

@implementation G0_SettingBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_SIGNAL( SIGNOUT )

#pragma mark -

- (void)load
{
    [[ConfigModel sharedInstance] addObserver:self];
}

- (void)unload
{
    [[ConfigModel sharedInstance] removeObserver:self];
}

ON_CREATE_VIEWS(signal)
{
    self.navigationBarShown = YES;
    self.navigationBarTitle = __TEXT(@"setting");
    self.navigationBarLeft  = [UIImage imageNamed:@"nav_back.png"];

    [self observeNotification:UserModel.LOGIN];
    [self observeNotification:UserModel.LOGOUT];
    [self observeNotification:UserModel.KICKOUT];
    [self observeNotification:UserModel.UPDATED];
	
	[self observeNotification:ECMobilePushConfig.UPDATING];
	[self observeNotification:ECMobilePushConfig.UPDATED];
    
//    @weakify(self);
    
//    self.list.lineCount = 1;
//    self.list.reuseEnable = NO;
//    self.list.whenReloading = ^{
//        
//        @normalize(self);
//        
//        NSDictionary * setting =
//        @{ @"setting_picture":		@([SettingModel sharedInstance].photoMode),
//		   @"push_notification":    @([ECMobilePushConfig sharedInstance].on),
//           @"sina_weibo":			@(bee.services.share.sinaweibo.isAuthorized),
//           @"tencent_weibo":		@(bee.services.share.tencentweibo.isAuthorized),
//           @"user_online":			@([UserModel online]) };
//
//        self.list.total = 1;
//        
//        BeeUIScrollItem * item = self.list.items[0];
//        item.clazz = [G0_SettingCell_iPhone class];
//        item.size = CGSizeAuto;
//        item.data = setting;
//        item.rule = BeeUIScrollLayoutRule_Line;
//    };
}

ON_DELETE_VIEWS(signal)
{
    self.list = nil;
    [self unobserveAllNotifications];
}

ON_WILL_APPEAR(signal)
{
    [bee.ui.appBoard hideTabbar];

    [[ConfigModel sharedInstance] reload];

    [self reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSLog( @"1-%ld", time(nil) );
    self.settingCell = [[G0_SettingCell_iPhone alloc] initWithFrame:CGRectAuto];
    NSLog( @"2-%ld", time(nil) );
    self.settingCell.FROM_RESOURCE(@"G0_SettingCell_iPhone.xml");
    NSLog( @"3-%ld", time(nil) );
    CGSize size = [self.settingCell estimateUISizeByWidth:self.width];
    NSLog( @"4-%ld", time(nil) );
    self.settingCell.frame = CGRectMake(0, 0, 320, size.height);
    NSLog( @"5-%ld", time(nil) );
    self.list.contentSize = size;
    NSLog( @"6-%ld", time(nil) );
    [self.list addSubview:self.settingCell];
    
    NSLog(@"%@", self.settingCell );
}

ON_LEFT_BUTTON_TOUCHED( signal )
{
	[self.stack popBoardAnimated:YES];
}

- (void)reloadData
{
    NSDictionary * setting =
    @{ @"setting_picture":		@([SettingModel sharedInstance].photoMode),
       @"push_notification":    @([ECMobilePushConfig sharedInstance].on),
       @"sina_weibo":			@(bee.services.share.sinaweibo.isAuthorized),
       @"tencent_weibo":		@(bee.services.share.tencentweibo.isAuthorized),
       @"user_online":			@([UserModel online]) };
    
//    item.clazz = [G0_SettingCell_iPhone class];
//    item.size = CGSizeAuto;
//    item.data = setting;
}

#pragma mark - G0_SettingCell_iPhone

ON_SIGNAL3( G0_SettingCell_iPhone, setting_smartmode, signal )
{
    [SettingModel sharedInstance].photoMode = SettingModel.PHOTO_MODE_AUTO;
    [[SettingModel sharedInstance] saveCache];

    [self presentSuccessTips:__TEXT(@"switch_auto_mode")];

    [self reloadData];
}

ON_SIGNAL3( G0_SettingCell_iPhone, setting_hqpicture, signal )
{
    [SettingModel sharedInstance].photoMode = SettingModel.PHOTO_MODE_HIGH;
    [[SettingModel sharedInstance] saveCache];

    [self presentSuccessTips:__TEXT(@"switch_high_mode")];

    [self reloadData];
}

ON_SIGNAL3( G0_SettingCell_iPhone, setting_normal, signal )
{
    [SettingModel sharedInstance].photoMode = SettingModel.PHOTO_MODE_LOW;
    [[SettingModel sharedInstance] saveCache];

    [self presentSuccessTips:__TEXT(@"switch_low_mode")];

    [self reloadData];
}

ON_SIGNAL3( G0_SettingCell_iPhone, setting_feedback, signal )
{
	if ( [ECMobileAppConfig sharedInstance].umengKey )
	{
		UMFeedbackViewController * vc = [[UMFeedbackViewController alloc] initWithNibName:@"UMFeedbackViewController" bundle:nil];
		vc.appkey = [ECMobileAppConfig sharedInstance].umengKey;
		
		UINavigationController * nav = [[[UINavigationController alloc] initWithRootViewController:vc] autorelease];
		[self presentModalViewController:nav animated:YES];
	}
	else
	{
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.ecmobile.me"]];
	}
}

ON_SIGNAL3( G0_SettingCell_iPhone, setting_rate, signal )
{
    NSString *	link = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=551560576";
    NSURL *		url = [NSURL URLWithString:link];

    if ( [[UIApplication sharedApplication] canOpenURL:url] )
    {
        [[UIApplication sharedApplication] openURL:url];
    }
    else
    {
        [self presentFailureTips:__TEXT(@"cannot_open")];
    }
}

ON_SIGNAL3( G0_SettingCell_iPhone, setting_service, signal )
{
    [self openTelephone:[ConfigModel sharedInstance].config.service_phone];
}

ON_SIGNAL3( G0_SettingCell_iPhone, setting_website, signal )
{
    H0_BrowserBoard_iPhone * board = [H0_BrowserBoard_iPhone board];
    board.defaultTitle = __TEXT(@"setting_website");
    board.urlString = [ConfigModel sharedInstance].config.site_url;
    [self.stack pushBoard:board animated:YES];
}

ON_SIGNAL3( G0_SettingCell_iPhone, setting_geekzoo, signal )
{
    H0_BrowserBoard_iPhone * board = [H0_BrowserBoard_iPhone board];
    board.defaultTitle = __TEXT(@"setting_geekzoo");
    board.urlString = @"http://www.geek-zoo.com/";
    [self.stack pushBoard:board animated:YES];
}

ON_SIGNAL3( G0_SettingCell_iPhone, push_notification, signal )
{
	BeeUISwitch * switchr = (BeeUISwitch *)signal.sourceView;
    
	if ( switchr.on )
	{
		[[ECMobilePushConfig sharedInstance] turnOn];
	}
	else
	{
		[[ECMobilePushConfig sharedInstance] turnOff];
	}
}

ON_SIGNAL3( G0_SettingCell_iPhone, sina_weibo, signal )
{
	ALIAS( bee.services.share.sinaweibo, sweibo );
	
	BeeUISwitch * switchr = (BeeUISwitch *)signal.sourceView;
	if ( switchr.on )
	{
        if ( sweibo.ready )
        {
            @weakify(self);
            
            sweibo.whenAuthSucceed = ^
            {
                @normalize(self);
                switchr.on = YES;
                
                [self presentSuccessTips:__TEXT(@"auth_succeed")];
            };
            sweibo.whenAuthFailed = ^
            {
                @normalize(self);
                switchr.on = NO;
                
                [self presentSuccessTips:__TEXT(@"auth_failed")];
            };
            sweibo.whenAuthCancelled = ^
            {
                switchr.on = NO;
            };
            
            sweibo.AUTHORIZE();
        }
        else
        {
            switchr.on = NO;
        }
	}
	else
	{
		sweibo.CLEAR();
	}
}

ON_SIGNAL3( G0_SettingCell_iPhone, tencent_weibo, signal )
{
	ALIAS( bee.services.share.tencentweibo, tweibo );

	BeeUISwitch * switchr = (BeeUISwitch *)signal.sourceView;
    
	if ( switchr.on )
	{
        if ( tweibo.ready )
        {
            @weakify(self);
            
            tweibo.whenAuthSucceed = ^
            {
                @normalize(self);
                switchr.on = YES;
                
                [self presentSuccessTips:__TEXT(@"auth_succeed")];
            };
            tweibo.whenAuthFailed = ^
            {
                @normalize(self);
                switchr.on = NO;
                
                [self presentSuccessTips:__TEXT(@"auth_failed")];
            };
            tweibo.whenAuthCancelled = ^
            {
                switchr.on = NO;
            };
            
            tweibo.AUTHORIZE();
        }
        else
        {
            switchr.on = NO;
        }
	}
	else
	{
		tweibo.CLEAR();
	}
}

ON_SIGNAL3( G0_SettingCell_iPhone, setting_logout, signal )
{
    [self signout];
}

#pragma mark - G0_SettingBoard_iPhone

ON_SIGNAL3( G0_SettingBoard_iPhone, SIGNOUT, signal )
{
    [[UserModel sharedInstance] signout];
    
    [bee.ui.appBoard showLogin];
}

#pragma mark -

- (void)signout
{
	BeeUIActionSheet * sheet = [BeeUIActionSheet spawn];
	[sheet addButtonTitle:__TEXT(@"signout") signal:self.SIGNOUT];
	[sheet addCancelTitle:__TEXT(@"cancel")];
	[sheet showInViewController:self];
}

- (void)openTelephone:(NSString *)telephone
{
    if ( telephone )
    {
        NSString * str = [[telephone componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@", str]];
        
        if ( [[UIApplication sharedApplication] canOpenURL:url] )
        {
            [[UIApplication sharedApplication] openURL:url];
        }
        else
        {
            [self presentFailureTips:[NSString stringWithFormat:@"%@\n%@", __TEXT(@"cannot_call"), telephone]];
        }
    }
    else
    {
        [self presentFailureTips:__TEXT(@"cannot_call")];
    }
}

#pragma mark -

ON_NOTIFICATION3( UserModel, LOGIN, notification )
{

	[self reloadData];
    self.RELAYOUT();
}

ON_NOTIFICATION3( UserModel, LOGOUT, notification )
{

	[self reloadData];
    self.RELAYOUT();
}

ON_NOTIFICATION3( UserModel, KICKOUT, notification )
{

	[self reloadData];
    self.RELAYOUT();
}

ON_NOTIFICATION3( ECMobilePushConfig, UPDATING, notification )
{
//	[self reloadData];
}

ON_NOTIFICATION3( ECMobilePushConfig, UPDATED, notification )
{

	[self reloadData];
}

#pragma mark -

ON_MESSAGE3( API, config, msg )
{
	if ( msg.failed )
	{
		[self showErrorTips:msg];
	}
}

@end
