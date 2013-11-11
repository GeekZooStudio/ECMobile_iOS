/*
 *                                                                          
 *       _/_/_/                      _/        _/_/_/_/_/                     
 *    _/          _/_/      _/_/    _/  _/          _/      _/_/      _/_/    
 *   _/  _/_/  _/_/_/_/  _/_/_/_/  _/_/          _/      _/    _/  _/    _/   
 *  _/    _/  _/        _/        _/  _/      _/        _/    _/  _/    _/    
 *   _/_/_/    _/_/_/    _/_/_/  _/    _/  _/_/_/_/_/    _/_/      _/_/       
 *                                                                          
 *
 *  Copyright 2013-2014, Geek Zoo Studio
 *  http://www.ecmobile.cn/license.html
 *
 *  HQ China:
 *    2319 Est.Tower Van Palace 
 *    No.2 Guandongdian South Street 
 *    Beijing , China
 *
 *  U.S. Office:
 *    One Park Place, Elmira College, NY, 14901, USA
 *
 *  QQ Group:   329673575
 *  BBS:        bbs.ecmobile.cn
 *  Fax:        +86-10-6561-5510
 *  Mail:       info@geek-zoo.com
 */
	
#import "SettingBoard_iPhone.h"
#import "WebViewBoard_iPhone.h"
#import "AppBoard_iPhone.h"

#pragma mark -

@interface SettingBoard_iPhone()
{
    FormElement * _pic1;
    FormElement * _pic2;
    FormElement * _pic3;
    FormElement * _rate;
    FormElement * _about;
    FormElement * _geek_zoo;
    FormElement * _bee;
    FormElement * _exit;
}
@end

@implementation SettingBoard_iPhone

DEF_SIGNAL( SIGN_OUT )

- (void)load
{
	[super load];
    
    [[ConfigModel sharedInstance] addObserver:self];
    
    self.datas = [[[NSMutableArray alloc] init] autorelease];
    self.titles = [[[NSMutableArray alloc] init] autorelease];

    _pic1 = [[FormElement check] retain];
    _pic1.title = __TEXT(@"setting_smartmode");
    _pic2 = [[FormElement check] retain];
    _pic2.title = __TEXT(@"setting_hqpicture");
    _pic3 = [[FormElement check] retain];
    _pic3.title = __TEXT(@"setting_normal");
    NSArray * group1 = @[ _pic1, _pic2, _pic3 ];

    _bee = [[FormElement subtitleCell] retain];
    _bee.title = @"关于BeeFramework";
    _rate = [[FormElement subtitleCell] retain];
    _rate.title = __TEXT(@"setting_rate");
    _about = [[FormElement subtitleCell] retain];
    _about.title = __TEXT(@"setting_tech");
    _geek_zoo = [[FormElement subtitleCell] retain];
    _geek_zoo.title = __TEXT(@"setting_geekzoo");
    NSArray * group3 = @[ _rate, _geek_zoo, _bee, _about ];

    _exit = [[FormElement button] retain];
    _exit.signal = self.SIGN_OUT;
    _exit.title = __TEXT(@"setting_logout");
    _exit.backgroundImage = @"button-red.png";
    _exit.size = CGSizeMake(300, 44);
    NSArray * group5 = @[ _exit ];

    [self.datas addObject:group1];
    [self.titles addObject:__TEXT(@"setting_picture")];
    
    [self.datas addObject:group3];
    [self.titles addObject:__TEXT(@"setting_official")];
 
    [self.datas addObject:group5];
    [self.titles addObject:@""];
    
    self.selectedIndexPathes = [[[NSMutableArray alloc] init] autorelease];
    [self.selectedIndexPathes addObject:[NSIndexPath indexPathForRow:0 inSection:0]];
}

- (void)unload
{
    [[ConfigModel sharedInstance] removeObserver:self];

	[_pic1 release];
	[_pic2 release];
	[_pic3 release];
	[_rate release];
	[_about release];
	[_exit release];
    [_bee release];

    [self.datas removeAllObjects];
    self.datas = nil;
    
    [self.selectedIndexPathes removeAllObjects];
	self.selectedIndexPathes = nil;
    
    [self.titles removeAllObjects];
    self.titles = nil;
    
	[super unload];
}

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        self.titleString = __TEXT(@"setting");
        [self showNavigationBarAnimated:YES];
        [self hideBarButton:BeeUINavigationBar.RIGHT];
		
		[self observeNotification:UserModel.LOGIN];
		[self observeNotification:UserModel.LOGOUT];
		[self observeNotification:UserModel.KICKOUT];
		[self observeNotification:UserModel.UPDATED];
	}
    else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
        [self unobserveAllNotifications];
    }
    else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
    {
		[self.selectedIndexPathes replaceObjectAtIndex:0
											withObject:[NSIndexPath indexPathForRow:[ConfigModel sharedInstance].photoMode
																		  inSection:0]];
    }
    else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
    {
		[[AppBoard_iPhone sharedInstance] setTabbarHidden:YES];
        [[ConfigModel sharedInstance] update];
		
		[self updateState];
    }
}

ON_SIGNAL2( BeeUINavigationBar, signal )
{
	[super handleUISignal:signal];

    if ( [signal is:BeeUINavigationBar.LEFT_TOUCHED] )
    {
        [self.stack popBoardAnimated:YES];
    }
    else if ( [signal is:BeeUINavigationBar.RIGHT_TOUCHED] )
    {
        // TODO
        [self.stack popBoardAnimated:YES];
    }
}

ON_SIGNAL2(  SettingBoard_iPhone, signal )
{
    if ( [signal is:self.SIGN_OUT] )
    {
        [self signout];
    }
}

ON_SIGNAL2( signout_yes, signal )
{
	[super handleUISignal:signal];
    
    [[UserModel sharedInstance] signout];
    
    [[AppBoard_iPhone sharedInstance] showLogin];
}


ON_NOTIFICATION3( UserModel, LOGIN, notification )
{
	[self updateState];
}

ON_NOTIFICATION3( UserModel, LOGOUT, notification )
{
	[self updateState];
}

ON_NOTIFICATION3( UserModel, KICKOUT, notification )
{
	[self updateState];
}

- (void)updateState
{
	if ( [UserModel online] )
	{
		if ( self.datas.count >= 3 )
		{
			[self.datas removeObjectAtIndex:2];
		}
		
		[self.datas addObject:@[_exit]];
	}
	else
	{
		if ( self.datas.count >= 3 )
		{
			[self.datas removeObjectAtIndex:2];
		}
	}
	
	[self reloadData];
}

#pragma mark -

- (void)signout
{
	BeeUIActionSheet * sheet = [BeeUIActionSheet spawn];
	[sheet addButtonTitle:__TEXT(@"signout") signal:@"signout_yes"];
	[sheet addCancelTitle:__TEXT(@"cancel")];
	[sheet showInViewController:self];
}

#pragma mark -

- (void)handleMessage:(BeeMessage *)msg
{
    if ( [msg is:API.config] )
    {
        if ( msg.sending )
        {
//			[self presentLoadingTips:__TEXT(@"tips_loading")];
        }
        else if ( msg.succeed )
        {
//			[self dismissTips];
            [self reloadData];
        }
        else if ( msg.failed )
        {
			[ErrorMsg presentErrorMsg:msg inBoard:self];
        }
    }
}

#pragma mark -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FormElement * element = [[self.datas objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
	if ( 0 == indexPath.section )
    {
        if ( 0 == indexPath.row )
        {
			[ConfigModel sharedInstance].photoMode = ConfigModel.PHOTO_MODE_AUTO;
			[[ConfigModel sharedInstance] saveCache];
			
			[self presentSuccessTips:__TEXT(@"switch_auto_mode")];
        }
        else if ( 1 == indexPath.row )
        {
			[ConfigModel sharedInstance].photoMode = ConfigModel.PHOTO_MODE_HIGH;
			[[ConfigModel sharedInstance] saveCache];
			
			[self presentSuccessTips:__TEXT(@"switch_high_mode")];
        }
        else if ( 2 == indexPath.row )
        {
			[ConfigModel sharedInstance].photoMode = ConfigModel.PHOTO_MODE_LOW;
			[[ConfigModel sharedInstance] saveCache];
			
			[self presentSuccessTips:__TEXT(@"switch_low_mode")];
        }
		
		[self.selectedIndexPathes replaceObjectAtIndex:0
											withObject:[NSIndexPath indexPathForRow:[ConfigModel sharedInstance].photoMode
																		  inSection:0]];
    }
    else
    {
        if ( element == _rate )
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
        else if ( element == _about )
        {
                WebViewBoard_iPhone * board = [WebViewBoard_iPhone board];
                board.defaultTitle = __TEXT(@"setting_tech");
                board.urlString = @"http://www.ecmobile.me/";
                [self.stack pushBoard:board animated:YES];
        }
        else if ( element == _geek_zoo )
        {
            WebViewBoard_iPhone * board = [WebViewBoard_iPhone board];
            board.defaultTitle = __TEXT(@"setting_geekzoo");
            board.urlString = @"http://www.geek-zoo.com/";
            [self.stack pushBoard:board animated:YES];
        }
        else if ( element == _bee )
        {
            WebViewBoard_iPhone * board = [WebViewBoard_iPhone board];
            board.defaultTitle = @"BeeFramework";
            board.urlString = @"http://www.bee-framework.com";
            [self.stack pushBoard:board animated:YES];
        }
    
    }
    
    [self reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FormCell * cell = (FormCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if ( 0 == indexPath.section )
    {
        if ( NSOrderedSame == [indexPath compare:[self.selectedIndexPathes objectAtIndex:indexPath.section]] )
        {
            cell.accessoryView.hidden = NO;
        }
        else
        {
            cell.accessoryView.hidden = YES;
        }
    }
		
    return cell;
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

@end
