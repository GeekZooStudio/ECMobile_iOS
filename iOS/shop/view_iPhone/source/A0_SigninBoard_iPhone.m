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

#import "A0_SigninBoard_iPhone.h"
#import "A1_SignupBoard_iPhone.h"
#import "AppBoard_iPhone.h"

#pragma mark -

@implementation A0_SigninBoard_iPhone

SUPPORT_RESOURCE_LOADING( YES )
SUPPORT_AUTOMATIC_LAYOUT( YES )

DEF_MODEL( UserModel, userModel )

- (void)load
{
	self.userModel = [UserModel modelWithObserver:self];
}

- (void)unload
{
	SAFE_RELEASE_MODEL( self.userModel );
}

#pragma mark -

ON_CREATE_VIEWS( signal )
{
    self.navigationBarTitle = __TEXT(@"member_signin");
//	[self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav_back.png"]];
    [self showBarButton:BeeUINavigationBar.LEFT title:__TEXT(@"cancel") image:[[UIImage imageNamed:@"nav_right.png"] stretched]];
    [self showBarButton:BeeUINavigationBar.RIGHT title:__TEXT(@"login_login") image:[[UIImage imageNamed:@"nav_right.png"] stretched]];
}

ON_DELETE_VIEWS( signal )
{
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
    [self showNavigationBarAnimated:NO];
}

ON_DID_APPEAR( signal )
{
}

ON_WILL_DISAPPEAR( signal )
{
}

ON_DID_DISAPPEAR( signal )
{
}

#pragma mark -

ON_LEFT_BUTTON_TOUCHED( signal )
{
    [[AppBoard_iPhone sharedInstance] hideLogin];
}

ON_RIGHT_BUTTON_TOUCHED( signal )
{
    [self doLogin];
}

#pragma mark - BeeUITextField

ON_SIGNAL3( BeeUITextField, RETURN, signal )
{
    if ( signal.source == $(@"username").view )
	{
		$(@"password").FOCUS();
	}
    else if ( signal.source == $(@"password").view )
	{
		[self doLogin];
	[self.view endEditing:YES];
}
}

#pragma mark - SigninBoard_iPhone

ON_SIGNAL3( A0_SigninBoard_iPhone, signup, signal )
{
	[self.stack pushBoard:[A1_SignupBoard_iPhone board] animated:YES];
}

#pragma mark -

- (void)doLogin
{
	NSString * userName = $(@"username").text.trim;
	NSString * password = $(@"password").text.trim;
	
	if ( 0 == userName.length || NO == [userName isChineseUserName] )
	{
		[self presentMessageTips:__TEXT(@"wrong_username")];
		return;
	}
    
	if ( userName.length < 2 )
	{
		[self presentMessageTips:__TEXT(@"username_too_short")];
		return;
	}
    
	if ( userName.length > 20 )
	{
		[self presentMessageTips:__TEXT(@"username_too_long")];
		return;
	}
    
	if ( 0 == password.length || NO == [password isPassword] )
	{
		[self presentMessageTips:__TEXT(@"wrong_password")];
		return;
	}
    
	if ( password.length < 6 )
	{
		[self presentMessageTips:__TEXT(@"password_too_short")];
		return;
	}
	
	if ( password.length > 20 )
	{
		[self presentMessageTips:__TEXT(@"password_too_long")];
		return;
	}

	[self.userModel signinWithUser:userName password:password];
}

#pragma mark -

ON_MESSAGE3( API, user_signin, msg )
{
	if ( msg.sending )
	{
		[self presentLoadingTips:__TEXT(@"signing_in")];
	}
	else
	{
		[self dismissTips];
	}

	if ( msg.succeed )
	{
		if ( [UserModel sharedInstance].firstUse )
		{
			[bee.ui.appBoard presentSuccessTips:__TEXT(@"welcome")];
		}
		else
		{
			[bee.ui.appBoard presentSuccessTips:__TEXT(@"welcome_back")];
		}
		
		[bee.ui.appBoard hideLogin];
	}
	else if ( msg.failed )
	{
		[self showErrorTips:msg];
	}
}

@end
