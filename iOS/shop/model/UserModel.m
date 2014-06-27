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

#import "UserModel.h"

#import "bee.services.share.sinaweibo.h"
#import "bee.services.share.tencentweibo.h"

#pragma mark -

@implementation UserModel

DEF_SINGLETON( UserModel )

@synthesize session = _session;
@synthesize fields = _fields;
@synthesize user = _user;
@synthesize firstUse = _firstUse;

@dynamic avatar;

DEF_NOTIFICATION( LOGIN )
DEF_NOTIFICATION( LOGOUT )
DEF_NOTIFICATION( KICKOUT )
DEF_NOTIFICATION( UPDATED )

- (void)load
{
	self.firstUse = YES;

	[self loadCache];
}

- (void)unload
{
	[self saveCache];

	self.session = nil;
	self.fields = nil;
	self.user = nil;
}

- (UIImage *)avatar
{
    NSString * avatarPath = [NSString stringWithFormat:@"%@/avatar-u-%@.png", [BeeSandbox libCachePath], self.user.id];
    
    if ( [[NSFileManager defaultManager] fileExistsAtPath:avatarPath] )
    {
        NSData * data = [NSData dataWithContentsOfFile:avatarPath];
        
        if ( data )
        {
            return [UIImage imageWithData:data];
        }
    }

	return nil;
}

- (void)setAvatar:(UIImage *)avatar
{
    NSString * avatarPath = [NSString stringWithFormat:@"%@/avatar-u-%@.png", [BeeSandbox libCachePath], self.user.id];

    
    if ( nil == avatar )
    {
        if ( [[NSFileManager defaultManager] fileExistsAtPath:avatarPath] )
        {
            [[NSFileManager defaultManager] removeItemAtPath:avatarPath error:nil];
        }
    }
    else
    {
        [[avatar dataWithExt:@"png"] writeToFile:avatarPath atomically:YES];
    }
}

#pragma mark -

- (void)loadCache
{
	self.user = [USER readFromUserDefaults:@"UserModel.user"];
	self.fields = [SIGNUP_FIELD readFromUserDefaults:@"UserModel.fields"];
	self.session = [SESSION readFromUserDefaults:@"UserModel.session"];

	if ( self.session )
	{
		[self setOnline:YES];
	}
//	else
//	{
//		[self setOffline:NO];
//	}
}

- (void)saveCache
{
	[USER userDefaultsWrite:[self.user objectToString] forKey:@"UserModel.user"];
	[SESSION userDefaultsWrite:[self.session objectToString] forKey:@"UserModel.session"];
	[SIGNUP_FIELD userDefaultsWrite:[self.fields objectToString] forKey:@"UserModel.fields"];
}

- (void)clearCache
{
	[USER removeFromUserDefaults:@"UserModel.user"];
	[SESSION removeFromUserDefaults:@"UserModel.session"];
	[SIGNUP_FIELD removeFromUserDefaults:@"UserModel.fields"];

	self.session = nil;
	self.fields = nil;
	self.user = nil;

	self.loaded = NO;
}

#pragma mark -

+ (BOOL)online
{
	if ( [UserModel sharedInstance].session )
		return YES;

	return NO;
}

- (void)setOnline:(BOOL)notify
{
	[USER userDefaultsWrite:[self.user objectToString] forKey:@"UserModel.user"];
	[SESSION userDefaultsWrite:[self.session objectToString] forKey:@"UserModel.session"];

	[BeeMessage setHeader:self.session forKey:@"session"];
	[BeeMessage setHeader:self.user forKey:@"user"];

	if ( notify )
	{
		[self postNotification:self.LOGIN];
	}
}

- (void)setOffline:(BOOL)notify
{
	bee.services.share.sinaweibo.CLEAR();
	bee.services.share.tencentweibo.CLEAR();
    
	[USER removeFromUserDefaults:@"UserModel.user"];
	[SESSION removeFromUserDefaults:@"UserModel.session"];

	[BeeMessage removeHeaderForKey:@"session"];
	[BeeMessage removeHeaderForKey:@"user"];

	self.session = nil;
	self.user = nil;
	
	[self clearCookie];
	
	if ( notify )
	{
		[self postNotification:self.LOGOUT];
	}
}

//- (void)openDatabase
//{
//	if ( self.user )
//	{
//		[BeeDatabase openSharedDatabase:[NSString stringWithFormat:@"%@.sqlite", self.user.id]];
//	}
//	else
//	{
//		[BeeDatabase openSharedDatabase:@"default.sqlite"];
//	}
//}

//清除cookies
- (void)clearCookie
{
	NSHTTPCookieStorage * cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	NSArray * cookies = [cookieStorage cookiesForURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/user/signin", [ServerConfig sharedInstance].url] ]];
	
	for ( NSHTTPCookie * cookie in cookies )
	{
		[cookieStorage deleteCookie:cookie];
	}
}

#pragma mark -

- (void)signinWithUser:(NSString *)user
			  password:(NSString *)password
{
	self.CANCEL_MSG( API.user_signin );
	self
	.MSG( API.user_signin )
	.INPUT( @"name", user )
	.INPUT( @"password", password );
}

- (void)signupWithUser:(NSString *)user
			  password:(NSString *)password
				 email:(NSString *)email
				fields:(NSArray *)fields
{
	self.CANCEL_MSG( API.user_signup );
	self
	.MSG( API.user_signup )
	.INPUT( @"name", user )
	.INPUT( @"password", password )
	.INPUT( @"email", email )
	.INPUT( @"field", fields );
}

- (void)signout
{
	self.CANCEL_MSG( API.user_signin );
	self.CANCEL_MSG( API.user_signup );

	[self setOffline:YES];
	
	self.firstUse = NO;
}

- (void)kickout
{
	self.CANCEL_MSG( API.user_signin );
	self.CANCEL_MSG( API.user_signup );
	
	[self setOffline:NO];
	
	self.firstUse = NO;
	
	[self postNotification:self.KICKOUT];
}

- (void)updateFields
{
	self.CANCEL_MSG( API.user_signupFields );
	self.MSG( API.user_signupFields );	
}

- (void)updateProfile
{
	self.CANCEL_MSG( API.user_info );
	self.MSG( API.user_info );
}

#pragma mark -

ON_MESSAGE3( API, user_signin, msg )
{
	if ( msg.succeed )
	{
		STATUS * status = msg.GET_OUTPUT( @"status" );
		if ( NO == status.succeed.boolValue )
		{
			msg.errorCode = status.error_code.intValue;
			msg.errorDesc = status.error_desc;
			msg.failed = YES;
			return;
		}
		
		self.session = msg.GET_OUTPUT( @"data_session" );
		self.user = msg.GET_OUTPUT( @"data_user" );
		self.loaded = YES;
		
		[self setOnline:YES];
	}
}

ON_MESSAGE3( API, user_signup, msg )
{
	if ( msg.succeed )
	{
		STATUS * status = msg.GET_OUTPUT( @"data_status" );
		if ( NO == status.succeed.boolValue )
		{
			msg.errorCode = status.error_code.intValue;
			msg.errorDesc = status.error_desc;
			msg.failed = YES;
			return;
		}

		self.session = msg.GET_OUTPUT( @"data_session" );
		self.user = msg.GET_OUTPUT( @"data_user" );
		self.loaded = YES;
		
		[self setOnline:YES];
	}
}

ON_MESSAGE3( API, user_signupFields, msg )
{
	if ( msg.succeed )
	{
		STATUS * status = msg.GET_OUTPUT( @"status" );
		if ( NO == status.succeed.boolValue )
		{
			msg.failed = YES;
			return;
		}

		self.fields = msg.GET_OUTPUT( @"data" );
		
		[SIGNUP_FIELD userDefaultsWrite:[self.fields objectToString] forKey:@"UserModel.fields"];
	}
}

ON_MESSAGE3( API, user_info, msg )
{
	if ( msg.succeed )
	{
		STATUS * status = msg.GET_OUTPUT( @"status" );
		if ( NO == status.succeed.boolValue )
		{
			msg.failed = YES;
			return;
		}

		self.user = msg.GET_OUTPUT( @"data" );
		[USER userDefaultsWrite:[self.user objectToString] forKey:@"UserModel.user"];

		[self postNotification:self.UPDATED];
	}
}

@end
