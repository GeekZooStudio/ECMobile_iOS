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

#import "UserModel.h"

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
	[super load];
	
	self.firstUse = YES;

	[self loadCache];
}

- (void)unload
{
	[self saveCache];

	self.session = nil;
	self.fields = nil;
	self.user = nil;

	[super unload];
}

- (UIImage *)avatar
{
    NSString * avatarPath = [NSString stringWithFormat:@"%@/avatar.png", [BeeSandbox libCachePath]];
    
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
    NSString * avatarPath = [NSString stringWithFormat:@"%@/avatar.png", [BeeSandbox libCachePath]];
    
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
	self.session = [SESSION objectFromDictionary:[[self userDefaultsRead:@"session"] objectFromJSONString]];
	self.fields = [SIGNUP_FIELD objectsFromArray:[[self userDefaultsRead:@"fields"] objectFromJSONString]];
	self.user = [USER objectFromDictionary:[[self userDefaultsRead:@"user"] objectFromJSONString]];

	if ( self.session )
	{
		[self setOnline:YES];
	}
	else
	{
		[self setOffline:NO];
	}
}

- (void)saveCache
{
	[self userDefaultsWrite:[self.session objectToString] forKey:@"session"];
	[self userDefaultsWrite:[self.fields objectToString] forKey:@"fields"];
	[self userDefaultsWrite:[self.user objectToString] forKey:@"user"];
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
	[self userDefaultsWrite:[self.session objectToString] forKey:@"session"];
	[self userDefaultsWrite:[self.user objectToString] forKey:@"user"];

	[BeeMessage setHeader:self.session forKey:@"session"];
	[BeeMessage setHeader:self.user forKey:@"user"];

//	self.loaded = YES;

//	[self openDatabase];
		
	if ( notify )
	{
		[self postNotification:self.LOGIN];
	}
}

- (void)setOffline:(BOOL)notify
{    
    [self userDefaultsRemove:@"session"];
	[self userDefaultsRemove:@"fields"];
	[self userDefaultsRemove:@"user"];
	
	[BeeMessage removeHeaderForKey:@"session"];
	[BeeMessage removeHeaderForKey:@"user"];

	self.session = nil;
	self.user = nil;

//	[self openDatabase];
	
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

- (void)handleMessage:(BeeMessage *)msg
{
	if ( [msg is:API.user_signin] )
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
	else if ( [msg is:API.user_signup] )
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
	else if ( [msg is:API.user_signupFields] )
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
//			self.loaded = YES;
			
			[self userDefaultsWrite:[self.fields objectToString] forKey:@"fields"];
		}
	}
	else if ( [msg is:API.user_info] )
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
//			self.loaded = YES;

			[self userDefaultsWrite:[self.user objectToString] forKey:@"user"];
			[self postNotification:self.UPDATED];
		}
	}
}

@end
