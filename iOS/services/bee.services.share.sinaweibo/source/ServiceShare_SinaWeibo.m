//
//   ______    ______    ______
//  /\  __ \  /\  ___\  /\  ___\
//  \ \  __<  \ \  __\_ \ \  __\_
//   \ \_____\ \ \_____\ \ \_____\
//    \/_____/  \/_____/  \/_____/
//
//
//  Copyright (c) 2014-2015, Geek Zoo Studio
//  http://www.bee-framework.com
//
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//

#import "ServiceShare_SinaWeibo.h"
#import "ServiceShare_SinaWeibo_API.h"
#import "ServiceShare_SinaWeibo_AuthorizeBoard.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#pragma mark -

@interface ServiceShare_SinaWeibo()
{
	BOOL							_shouldShare;
	ServiceShare_SinaWeibo_Config *	_config;
	
	NSString *		_authCode;
	NSString *		_accessToken;
	NSNumber *		_expiresIn;
	NSString *		_remindIn;
	NSString *		_uid;

	NSString *		_errorCode;
	NSString *		_errorDesc;
	NSString *		_errorURI;
}

- (void)authorize;
- (void)share;
- (void)cancel;

- (void)clearKey;
- (void)clearPost;
- (void)clearError;
- (void)clearCookie;

@end

#pragma mark -

@implementation ServiceShare_SinaWeibo

SERVICE_AUTO_LOADING( YES )
SERVICE_AUTO_POWERON( YES )

DEF_SINGLETON( ServiceShare_SinaWeibo )

@synthesize config = _config;

@synthesize authCode = _authCode;
@synthesize accessToken = _accessToken;
@synthesize expiresIn = _expiresIn;
@synthesize remindIn = _remindIn;
@synthesize uid = _uid;

@dynamic ready;
@synthesize errorCode = _errorCode;
@synthesize errorDesc = _errorDesc;
@synthesize errorURI = _errorURI;

@dynamic AUTHORIZE;
@dynamic SHARE;
@dynamic CANCEL;
@dynamic CLEAR;

- (void)load
{
//	[super load];
	
	self.state = self.STATE_IDLE;
	self.config = [[[ServiceShare_SinaWeibo_Config alloc] init] autorelease];
	
	self.whenAuthBegin		= [ServiceShare sharedInstance].whenAuthBegin;
	self.whenAuthSucceed	= [ServiceShare sharedInstance].whenAuthSucceed;
	self.whenAuthFailed		= [ServiceShare sharedInstance].whenAuthFailed;
	self.whenAuthCancelled	= [ServiceShare sharedInstance].whenAuthCancelled;
	
	self.whenShareBegin		= [ServiceShare sharedInstance].whenShareBegin;
	self.whenShareSucceed	= [ServiceShare sharedInstance].whenShareSucceed;
	self.whenShareFailed	= [ServiceShare sharedInstance].whenShareFailed;
	self.whenShareCancelled	= [ServiceShare sharedInstance].whenShareCancelled;
}

- (void)unload
{
	self.config = nil;
	
//	[super unload];
}

#pragma mark -

- (void)powerOn
{
	[super powerOn];
	
	[self loadCache];
}

- (void)powerOff
{
	[self saveCache];

	[self clearKey];
	[self clearPost];
	[self clearError];
	
	[super powerOff];
}

- (void)serviceWillActive
{
	[super serviceWillActive];
}

- (void)serviceDidActived
{
	[super serviceDidActived];
}

- (void)serviceWillDeactive
{
	[super serviceWillDeactive];
}

- (void)serviceDidDeactived
{
	[super serviceDidDeactived];
}

#pragma mark -

- (BeeServiceBlock)AUTHORIZE
{
	BeeServiceBlock block = ^ void ( void )
	{
		_shouldShare = NO;
		
		[self authorize];
	};
	
	return [[block copy] autorelease];
}

- (BeeServiceBlock)SHARE
{
	BeeServiceBlock block = ^ void ( void )
	{
		_shouldShare = YES;
		
		[self share];
	};
	
	return [[block copy] autorelease];
}

- (BeeServiceBlock)CANCEL
{
	BeeServiceBlock block = ^ void ( void )
	{
		_shouldShare = YES;
		
		[self cancel];
	};
	
	return [[block copy] autorelease];
}

- (BeeServiceBlock)CLEAR
{
	BeeServiceBlock block = ^ void ( void )
	{
		_shouldShare = NO;
		
		[self deleteCache];
	};
	
	return [[block copy] autorelease];
}

#pragma mark -

- (BOOL)ready
{
	if ( self.config.appKey && self.config.appSecret && self.config.redirectURI )
	{
		return YES;
	}

	return NO;
}

- (BOOL)isAuthorized
{
    return self.isExpired && self.accessToken && self.uid;
}

- (BOOL)isExpired
{
    if ( self.expiresIn )
    {
        NSDate * now = [NSDate date];
        NSDate * exp = [self.expiresIn asNSDate];

        return ( [now compare:exp] == NSOrderedAscending );
    }
	
    return NO;
}

- (void)authorize
{
	if ( self.isAuthorized )
		return;

	[self clearCookie];
	[self clearKey];
	[self clearError];

	[self notifyAuthBegin];
}

- (void)share
{
	if ( NO == self.isAuthorized )
	{
		[self authorize];
		return;
	}

	[self notifyShareBegin];
	
	NSString * text = nil;

	if ( self.post.text.length && self.post.url.length )
	{
		text = [NSString stringWithFormat:@"%@ %@", self.post.text, self.post.url];
        
        if ( text.length > 140 )
        {
            NSString * postText = [self.post.text substringToIndex:(139 - self.post.url.length)];
            
            text = [NSString stringWithFormat:@"%@ %@", postText, self.post.url];
        }
	}
	else if ( self.post.text.length )
	{
		text = self.post.text;
	}
	else if ( self.post.url.length )
	{
		text = self.post.url;
	}
	
	if ( text.length > 140 )
	{
		text = [text substringToIndex:140];
	}

	if ( self.post.photo )
	{
		if ( [self.post.photo isKindOfClass:[UIImage class]] )
		{
			SINAWEIBO_STATUSES_UPLOAD * api = [SINAWEIBO_STATUSES_UPLOAD apiWithResponder:self];
			api.text = text;
			api.photo = self.post.photo;
			api.seconds = 45.0f;
			[api send];
		}
		else if ( [self.post.photo isKindOfClass:[NSString class]] )
		{
			SINAWEIBO_STATUSES_UPLOAD_URL_TEXT * api = [SINAWEIBO_STATUSES_UPLOAD_URL_TEXT apiWithResponder:self];
			api.text = text;
			api.photoURL = self.post.photo;
			api.seconds = 45.0f;
			[api send];
		}
		else
		{
			[self notifyShareFailed];
		}
	}
	else if ( text && text.length )
	{
		SINAWEIBO_STATUSES_UPDATE * api = [SINAWEIBO_STATUSES_UPDATE apiWithResponder:self];
		api.text = text;
		api.seconds = 20.0f;
		[api send];
	}
	else
	{
		[self notifyShareFailed];
	}
}

- (void)cancel
{
	if ( self.sharing )
	{
		[self notifyShareCancelled];
	}
	else if ( self.authorizing )
	{
		[self notifyAuthCancelled];
	}

	self.state = self.STATE_IDLE;

	[self cancelMessages];

	[self clearCookie];
	[self clearError];
	[self clearPost];

	[self.window close];
}

- (void)clearCookie
{
	NSHTTPCookieStorage * cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	NSArray * cookies = [cookieStorage cookiesForURL:[NSURL URLWithString:self.config.authorizeURL]];
	
	for ( NSHTTPCookie * cookie in cookies )
	{
		[cookieStorage deleteCookie:cookie];
	}
}

- (void)clearPost
{
	[self.post clear];
	
	self.whenShareCancelled = nil;
	self.whenShareSucceed = nil;
	self.whenShareFailed = nil;
}

- (void)clearKey
{
	self.authCode = nil;
	self.accessToken = nil;
	self.expiresIn = nil;
	self.remindIn = nil;
	self.uid = nil;
}

- (void)clearError
{
	self.errorCode = nil;
	self.errorDesc = nil;
	self.errorURI = nil;
}

#pragma mark -

- (void)notifyAuthBegin
{
	self.state = self.STATE_AUTHORIZING;

	ServiceShare_SinaWeibo_AuthorizeBoard * board = [ServiceShare_SinaWeibo_AuthorizeBoard board];
	
	board.whenClose = ^
	{
		[self notifyAuthCancelled];
	};
	
	CGRect newFrame = CGRectZero;
	
    if ( [BeeSystemInfo isPhoneRetina4] )
    {
        newFrame = CGRectMake(0, 0, 320, 568);
    }
    else
    {
        newFrame = CGRectMake(0, 0, 320, 480);
    }
        
	self.window.rootViewController = [BeeUIStack stackWithFirstBoard:board];
	self.window.rootViewController.view.frame = newFrame;
	[self.window open];
	
	if ( self.whenAuthBegin )
	{
		self.whenAuthBegin();
	}
	else if ( [ServiceShare sharedInstance].whenAuthBegin )
	{
		[ServiceShare sharedInstance].whenAuthBegin();
	}
}

- (void)notifyAuthVerify
{
	if ( nil == self.authCode )
	{
		[self notifyAuthFailed];
		return;
	}

	SINAWEIBO_OAUTH2_ACCESS_TOKEN * api = [SINAWEIBO_OAUTH2_ACCESS_TOKEN apiWithResponder:self];
	api.code = self.authCode;
	api.seconds = 20.0f;
	[api send];
}

- (void)notifyAuthSucceed
{
	[SINAWEIBO_OAUTH2_ACCESS_TOKEN cancel];

	[self saveCache];
	[self.window close];

	if ( _shouldShare )
	{
		[self share];
	}
	else
	{
		[self clearPost];
		[self clearError];
		
		if ( self.whenAuthSucceed )
		{
			self.whenAuthSucceed();
		}
		else if ( [ServiceShare sharedInstance].whenAuthSucceed )
		{
			[ServiceShare sharedInstance].whenAuthSucceed();
		}

		self.state = self.STATE_IDLE;
	}
}

- (void)notifyAuthFailed
{
	[SINAWEIBO_OAUTH2_ACCESS_TOKEN cancel];
	
	ERROR( @"Failed to authorize, errorCode = %@, errorDesc = %@", self.errorCode, self.errorDesc );

	[self deleteCache];
	[self.window close];

	[self clearPost];

	if ( self.whenAuthFailed )
	{
		self.whenAuthFailed();
	}
	else if ( [ServiceShare sharedInstance].whenAuthFailed )
	{
		[ServiceShare sharedInstance].whenAuthFailed();
	}

	self.state = self.STATE_IDLE;
}

- (void)notifyAuthCancelled
{
	[SINAWEIBO_OAUTH2_ACCESS_TOKEN cancel];

	[self deleteCache];
	[self.window close];
	
	[self clearPost];

	if ( self.whenAuthCancelled )
	{
		self.whenAuthCancelled();
	}
	else if ( [ServiceShare sharedInstance].whenAuthCancelled )
	{
		[ServiceShare sharedInstance].whenAuthCancelled();
	}

	self.state = self.STATE_IDLE;
}

#pragma mark -

- (void)notifyShareBegin
{
	self.state = self.STATE_SHARING;

	if ( self.whenShareBegin )
	{
		self.whenShareBegin();
	}
	else if ( [ServiceShare sharedInstance].whenShareBegin )
	{
		[ServiceShare sharedInstance].whenShareBegin();
	}
}

- (void)notifyShareSucceed
{
	[self clearPost];
	
	if ( self.whenShareSucceed )
	{
		self.whenShareSucceed();
	}
	else if ( [ServiceShare sharedInstance].whenShareSucceed )
	{
		[ServiceShare sharedInstance].whenShareSucceed();
	}

	self.state = self.STATE_IDLE;
}

- (void)notifyShareFailed
{
	ERROR( @"Failed to share, errorCode = %@, errorDesc = %@", self.errorCode, self.errorDesc );

	[self clearPost];
	
	if ( self.whenShareFailed )
	{
		self.whenShareFailed();
	}
	else if ( [ServiceShare sharedInstance].whenShareFailed )
	{
		[ServiceShare sharedInstance].whenShareFailed();
	}

	self.state = self.STATE_IDLE;
}

- (void)notifyShareCancelled
{
	[self clearPost];
	
	if ( self.whenShareCancelled )
	{
		self.whenShareCancelled();
	}
	else if ( [ServiceShare sharedInstance].whenShareCancelled )
	{
		[ServiceShare sharedInstance].whenShareCancelled();
	}

	self.state = self.STATE_IDLE;
}

#pragma mark -

- (void)saveCache
{
	[self userDefaultsWrite:self.accessToken forKey:@"accessToken"];
	[self userDefaultsWrite:[self.expiresIn asNSString] forKey:@"expiresIn"];
	[self userDefaultsWrite:self.remindIn forKey:@"remindIn"];
	[self userDefaultsWrite:self.uid forKey:@"uid"];
}

- (void)loadCache
{
	self.accessToken = [self userDefaultsRead:@"accessToken"];
	self.expiresIn = [[self userDefaultsRead:@"expiresIn"] asNSNumber];
	self.remindIn = [self userDefaultsRead:@"remindIn"];
	self.uid = [self userDefaultsRead:@"uid"];
}

- (void)deleteCache
{
	[self userDefaultsRemove:@"accessToken"];
	[self userDefaultsRemove:@"expiresIn"];
	[self userDefaultsRemove:@"remindIn"];
	[self userDefaultsRemove:@"uid"];

	[self clearKey];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
