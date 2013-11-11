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
	
#import "ProfileBoard_iPhone.h"
#import "AppBoard_iPhone.h"
#import "AddressListBoard_iPhone.h"
#import "SettingBoard_iPhone.h"
#import "AwaitPayBoard_iPhone.h"
#import "AwaitShipBoard_iPhone.h"
#import "ShippedBoard_iPhone.h"
#import "FinishedBoard_iPhone.h"
#import "CollectionBoard_iPhone.h"
#import "NotificationBoard_iPhone.h"
#import "HelpCell_iPhone.h"
#import "HelpBoard_iPhone.h"
#import "Placeholder.h"

#pragma mark -

@implementation ProfileCell_iPhone

SUPPORT_RESOURCE_LOADING( YES )

- (void)load
{
    [super load];
}

- (void)dataDidChanged
{
    if ( self.data )
    {
        UserModel * userModel = self.data;
        
		if ( [UserModel online] )
		{
			$(@"#name").TEXT(userModel.user.name);
		}
		else
		{
			$(@"#name").TEXT(__TEXT(@"click_to_login"));
		}

		if ( 0 == userModel.user.collection_num.intValue )
		{
			$(@"#fav-count").TEXT( __TEXT(@"no_product") );
		}
		else
		{
			$(@"#fav-count").TEXT( [NSString stringWithFormat:@"%@%@", userModel.user.collection_num, __TEXT(@"no_of_items")] );
		}
		      
		NSNumber * num1 = [[userModel.user.order_num objectAtPath:@"await_pay"] asNSNumber];
		if ( num1 && num1.intValue )
		{
			$(@"#await_pay-bg").SHOW();
			$(@"#await_pay").SHOW().DATA( num1 );
		}
		else
		{
			$(@"#await_pay-bg").HIDE();
			$(@"#await_pay").HIDE();
		}

		NSNumber * num2 = [[userModel.user.order_num objectAtPath:@"await_ship"] asNSNumber];
		if ( num2 && num2.intValue )
		{
			$(@"#await_ship-bg").SHOW();
			$(@"#await_ship").SHOW().DATA( num2 );
		}
		else
		{
			$(@"#await_ship-bg").HIDE();
			$(@"#await_ship").HIDE();
		}
		
		NSNumber * num3 = [[userModel.user.order_num objectAtPath:@"shipped"] asNSNumber];
		if ( num3 && num3.intValue )
		{
			$(@"#shipped-bg").SHOW();
			$(@"#shipped").SHOW().DATA( num3 );
		}
		else
		{
			$(@"#shipped-bg").HIDE();
			$(@"#shipped").HIDE();
		}
		
		NSNumber * num4 = [[userModel.user.order_num objectAtPath:@"finished"] asNSNumber];
		if ( num4 && num4.intValue )
		{
			$(@"#finished-bg").SHOW();
			$(@"#finished").SHOW().DATA( num4 );
		}
		else
		{
			$(@"#finished-bg").HIDE();
			$(@"#finished").HIDE();
		}
		
		if ( [UserModel online] )
		{
			if ( [UserModel sharedInstance].avatar )
			{
				$(@"#header-avatar").IMAGE( [UserModel sharedInstance].avatar );
			}
			else
			{
				$(@"#header-avatar").IMAGE( [Placeholder avatar] );
			}
			
			$(@"#header-carema").SHOW();
			$(@"#carema").SHOW();
			$(@"#signin").HIDE();

            if ( userModel.user.rank_level.integerValue == RANK_LEVEL_NORMAL )
            {
                $(@"#header-level-icon").HIDE();
            }
            else
            {
                $(@"#header-level-icon").SHOW();
                $(@"#header-level-icon").DATA( @"profile-vip-icon.png" );
            }
                
            $(@"#header-level-name").SHOW();
            $(@"#header-level-name").DATA( userModel.user.rank_name );
		}
		else
		{
			// [[AppBoard_iPhone sharedInstance] showLogin];
			
			$(@"#header-avatar").IMAGE( [Placeholder avatar] );
			$(@"#header-carema").HIDE();
			$(@"#carema").HIDE();
			$(@"#signin").SHOW();
            $(@"#header-level-icon").HIDE();
            $(@"#header-level-name").HIDE();
		}
    }
}

@end

#pragma mark -

@interface ProfileBoard_iPhone()
{
	BeeUIScrollView *		_scroll;
    ProfileCell_iPhone *	_profile;
}
@end

#pragma mark -

@implementation ProfileBoard_iPhone

DEF_SIGNAL( PHOTO_FROM_CAMERA )
DEF_SIGNAL( PHOTO_FROM_LIBRARY )
DEF_SIGNAL( PHOTO_REMOVE )

- (void)load
{
    [super load];
    
    [[UserModel sharedInstance] addObserver:self];
    
	self.helpModel = [[[HelpModel alloc] init] autorelease];
	[self.helpModel addObserver:self];
}

- (void)unload
{
    [self.helpModel removeObserver:self];
    self.helpModel = nil;
    
    [[UserModel sharedInstance] removeObserver:self];

    [super unload];
}

#pragma mark -

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        self.titleString = __TEXT(@"profile_personal");
        
		_scroll = [[BeeUIScrollView alloc] init];
		_scroll.dataSource = self;
		[self.view addSubview:_scroll];
        
        [self showNavigationBarAnimated:NO];
        
        [self showBarButton:BeeUINavigationBar.RIGHT
                      image:[UIImage imageNamed:@"nav-right.png"]
					  image:[UIImage imageNamed:@"profile-refresh-site-icon.png"]];
        
        _profile = [[ProfileCell_iPhone alloc] initWithFrame:CGRectZero];
        [_scroll showHeaderLoader:YES animated:YES];
		
		[self observeNotification:UserModel.LOGIN];
		[self observeNotification:UserModel.LOGOUT];
		[self observeNotification:UserModel.KICKOUT];
		[self observeNotification:UserModel.UPDATED];
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
		[self unobserveAllNotifications];
		
		SAFE_RELEASE_SUBVIEW( _scroll );
	}
	else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{
        [_scroll setBaseInsets:UIEdgeInsetsMake(0, 0, [AppBoard_iPhone sharedInstance].tabbar.height, 0)];
		_scroll.frame = self.viewBound;
	}
    else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
    {
        [self.helpModel loadCache];
    }
    else if ( [signal is:BeeUIBoard.FREE_DATAS] )
    {
    }
    else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
    {
        [[AppBoard_iPhone sharedInstance] setTabbarHidden:NO];
    }
    else if ( [signal is:BeeUIBoard.DID_APPEAR] )
    {
		[self updateState];
        
        if ( NO == self.helpModel.loaded )
		{
			[self.helpModel fetchFromServer];
		}
    }
    else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
    {
        [[AppBoard_iPhone sharedInstance] setTabbarHidden:YES];
    }
    else if ( [signal is:BeeUIBoard.DID_DISAPPEAR] )
    {
    }
}

ON_SIGNAL2( BeeUINavigationBar, signal )
{
	[super handleUISignal:signal];
    
    if ( [signal is:BeeUINavigationBar.LEFT_TOUCHED] )
    {
    }
    else if ( [signal is:BeeUINavigationBar.RIGHT_TOUCHED] )
    {
        [self.stack pushBoard:[SettingBoard_iPhone board] animated:YES];
    }
}

ON_SIGNAL2( BeeUIScrollView, signal )
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIScrollView.HEADER_REFRESH] )
	{
        [[UserModel sharedInstance] updateProfile];
		
        if ( NO == self.helpModel.loaded )
		{
			[self.helpModel fetchFromServer];
		}
        
		[[CartModel sharedInstance] fetchFromServer];
	}
	else if ( [signal is:BeeUIScrollView.REACH_BOTTOM] )
	{
	}
}

ON_SIGNAL2( ProfileBoard_iPhone, signal )
{
    if ( [signal is:self.PHOTO_FROM_CAMERA] )
    {
        //Take Photo with Camera
        @try {
            if ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] )
            {
                UIImagePickerController *cameraVC = [[UIImagePickerController alloc] init];
                [cameraVC setSourceType:UIImagePickerControllerSourceTypeCamera];
                [cameraVC.navigationBar setBarStyle:UIBarStyleBlack];
                [cameraVC setDelegate:self];
                [cameraVC setAllowsEditing:YES];
                [self presentModalViewController:cameraVC animated:YES];
                [cameraVC release];
                
            }else {
                CC(@"Camera is not available.");
            }
        }
        @catch (NSException *exception) {
            CC(@"Camera is not available.");
        }
    }
    else if ( [signal is:self.PHOTO_FROM_LIBRARY] )
    {
        //Show Photo Library
        @try {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
                UIImagePickerController *imgPickerVC = [[UIImagePickerController alloc] init];
                [imgPickerVC setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                [imgPickerVC.navigationBar setBarStyle:UIBarStyleBlack];
                [imgPickerVC setDelegate:self];
                [imgPickerVC setAllowsEditing:YES];
                [self presentModalViewController:imgPickerVC animated:YES];
                [imgPickerVC release];
            }else {
                CC(@"Album is not available.");
            }
        }
        @catch (NSException *exception) {
            //Error
            CC(@"Album is not available.");
        }
    }
	else if ( [signal is:self.PHOTO_REMOVE] )
	{
        $(_profile).FIND(@"#header-avatar").DATA( [Placeholder image] );

        [[UserModel sharedInstance] setAvatar:nil];
        
		[self dismissModalViewControllerAnimated:YES];
	}
}

ON_SIGNAL3( ProfileCell_iPhone, signin, signal )
{
	if ( NO == [UserModel online] )
	{
		[[AppBoard_iPhone sharedInstance] showLogin];
		return;
	}	
}

ON_SIGNAL3( ProfileCell_iPhone, collection, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
		if ( NO == [UserModel online] )
		{
			[[AppBoard_iPhone sharedInstance] showLogin];
			return;
		}
		
        [self.stack pushBoard:[CollectionBoard_iPhone board] animated:YES];
    }
}

ON_SIGNAL3( ProfileCell_iPhone, notification, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
		if ( NO == [UserModel online] )
		{
			[[AppBoard_iPhone sharedInstance] showLogin];
			return;
		}

        [self.stack pushBoard:[NotificationBoard_iPhone board] animated:YES];
    }
}

ON_SIGNAL3( ProfileCell_iPhone, manage, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
		if ( NO == [UserModel online] )
		{
			[[AppBoard_iPhone sharedInstance] showLogin];
			return;
		}

        [self.stack pushBoard:[AddressListBoard_iPhone board] animated:YES];
    }
}

ON_SIGNAL3( ProfileCell_iPhone, order_await_pay, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
		if ( NO == [UserModel online] )
		{
			[[AppBoard_iPhone sharedInstance] showLogin];
			return;
		}

        [self.stack pushBoard:[AwaitPayBoard_iPhone board] animated:YES];
    }
}

ON_SIGNAL3( ProfileCell_iPhone, order_await_ship, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
		if ( NO == [UserModel online] )
		{
			[[AppBoard_iPhone sharedInstance] showLogin];
			return;
		}

        [self.stack pushBoard:[AwaitShipBoard_iPhone board] animated:YES];
    }
}

ON_SIGNAL3( ProfileCell_iPhone, order_shipped, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
		if ( NO == [UserModel online] )
		{
			[[AppBoard_iPhone sharedInstance] showLogin];
			return;
		}

        [self.stack pushBoard:[ShippedBoard_iPhone board] animated:YES];
    }
}

ON_SIGNAL3( ProfileCell_iPhone, order_finished, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
		if ( NO == [UserModel online] )
		{
			[[AppBoard_iPhone sharedInstance] showLogin];
			return;
		}

        [self.stack pushBoard:[FinishedBoard_iPhone board] animated:YES];
    }
}

ON_SIGNAL3( ProfileCell_iPhone, carema, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
	{
		if ( NO == [UserModel online] )
		{
			[[AppBoard_iPhone sharedInstance] showLogin];
			return;
		}

		if ( [UserModel sharedInstance].avatar )
		{
			BeeUIActionSheet * confirm = [BeeUIActionSheet spawn];
			[confirm addDestructiveTitle:__TEXT(@"delete_photo") signal:self.PHOTO_REMOVE];
			[confirm addCancelTitle:__TEXT(@"button_cancel")];
			[confirm showInViewController:self];
		}
		else
		{
			BeeUIActionSheet * confirm = [BeeUIActionSheet spawn];
			
			if ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] )
            {
				[confirm addButtonTitle:__TEXT(@"from_camera") signal:self.PHOTO_FROM_CAMERA];
			}
			if ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] )
			{
				[confirm addButtonTitle:__TEXT(@"from_album") signal:self.PHOTO_FROM_LIBRARY];
			}

			[confirm addCancelTitle:__TEXT(@"button_cancel")];
			[confirm showInViewController:self];
		}
	}
}

ON_SIGNAL2( HelpCell_iPhone, signal )
{
	[super handleUISignal:signal];
	
    ARTICLE_GROUP * articleGroup = signal.sourceCell.data;
	if ( articleGroup )
	{
		HelpBoard_iPhone * board = [HelpBoard_iPhone board];
		board.articleGroup = articleGroup;
		[self.stack pushBoard:board animated:YES];
	}
}

ON_NOTIFICATION3( PushModel, UPDATED, notification )
{
	[_scroll asyncReloadData];
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

ON_NOTIFICATION3( UserModel, UPDATED, notification )
{
}

- (void)updateState
{
	if ( [UserModel online] )
	{
		[[CartModel sharedInstance] fetchFromServer];
		
		if ( ![UserModel sharedInstance].loaded )
		{
			[[UserModel sharedInstance] updateProfile];
		}
		
		[_scroll showHeaderLoader:YES animated:NO];
	}
	else
	{
//		[[AppBoard_iPhone sharedInstance] showLogin];
		
		[_scroll showHeaderLoader:NO animated:NO];
	}
	
	[_scroll reloadData];
}

#pragma mark -

- (void)handleMessage:(BeeMessage *)msg
{
    [super handleMessage:msg];

    if ( [msg is:API.user_info] )
    {
//        if ( ![UserModel sharedInstance].loaded )
        {
            [_scroll setHeaderLoading:msg.sending];
        }

        if ( msg.succeed )
        {
            [_scroll asyncReloadData];
        }
    }
    else if ( [msg is:API.shopHelp] )
	{
		if ( msg.sending )
		{
			if ( NO == self.helpModel.loaded )
			{
//				[self presentLoadingTips:__TEXT(@"tips_loading")];
			}
			else
			{
				[_scroll setHeaderLoading:YES];
			}
		}
		else
		{
			[_scroll setHeaderLoading:NO];
			
			[self dismissTips];
		}
		
		if ( msg.succeed )
		{
			[_scroll asyncReloadData];
		}
		else if ( msg.failed )
		{
            //            [self presentFailureTips:@"加载失败,请稍后再试"];
			[ErrorMsg presentErrorMsg:msg inBoard:self];
		}
    }
}

#pragma mark -

- (NSInteger)numberOfViewsInScrollView:(BeeUIScrollView *)scrollView
{
    NSUInteger row = 0;
    
	row += 1;
	row += self.helpModel.articleGroups.count;
    
	return row;
}

- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index scale:(CGFloat)scale
{
    NSUInteger section = 0;
	
	section += 1;
	if ( index < section )
	{
        _profile.data = [UserModel sharedInstance];
        return _profile;
	}
    
	section += self.helpModel.articleGroups.count;
	if ( index < section )
	{
		BeeUICell * cell = [scrollView dequeueWithContentClass:[HelpCell_iPhone class]];
        cell.data = [self.helpModel.articleGroups safeObjectAtIndex:(self.helpModel.articleGroups.count - (section - index))];
		return cell;
	}
    
    return nil;
}

- (CGSize)scrollView:(BeeUIScrollView *)scrollView sizeForIndex:(NSInteger)index
{
    NSUInteger section = 0;
	
	section += 1;
	if ( index < section )
	{
        return [ProfileCell_iPhone estimateUISizeByWidth:scrollView.width forData:[UserModel sharedInstance]];
	}
    
	section += self.helpModel.articleGroups.count;
	if ( index < section )
	{
		id data = [self.helpModel.articleGroups safeObjectAtIndex:(self.helpModel.articleGroups.count - (section - index))];
		return [HelpCell_iPhone estimateUISizeByWidth:scrollView.width forData:data];
	}
    
    return CGSizeZero;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIImage * image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
	if ( image )
	{
        $(_profile).FIND(@"#header-avatar").IMAGE( image );

        [[UserModel sharedInstance] setAvatar:image];
	}
    
    [self dismissModalViewControllerAnimated:YES];
}

@end
