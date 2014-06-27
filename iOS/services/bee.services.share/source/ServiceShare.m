//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//
//	Copyright (c) 2014-2015, Geek Zoo Studio
//	http://www.bee-framework.com
//
//
//	Permission is hereby granted, free of charge, to any person obtaining a
//	copy of this software and associated documentation files (the "Software"),
//	to deal in the Software without restriction, including without limitation
//	the rights to use, copy, modify, merge, publish, distribute, sublicense,
//	and/or sell copies of the Software, and to permit persons to whom the
//	Software is furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//	IN THE SOFTWARE.
//

#import "ServiceShare.h"
#import "ServiceShare_ActivityBoard.h"
#import "ServiceShare_ActivityWindow.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#pragma mark -

@implementation ServiceShare
{
	NSUInteger				_state;

	ServiceShare_Window *	_window;
	ServiceShare_Post *		_post;

	BeeServiceBlock			_whenAuthBegin;
	BeeServiceBlock			_whenAuthSucceed;
	BeeServiceBlock			_whenAuthFailed;
	BeeServiceBlock			_whenAuthCancelled;

	BeeServiceBlock			_whenShareBegin;
	BeeServiceBlock			_whenShareSucceed;
	BeeServiceBlock			_whenShareFailed;
	BeeServiceBlock			_whenShareCancelled;
}

DEF_SINGLETON( ServiceShare )

DEF_INT( STATE_IDLE,		0 )
DEF_INT( STATE_AUTHORIZING,	1 )
DEF_INT( STATE_SHARING,		2 )

@synthesize state = _state;
@dynamic authorizing;
@dynamic sharing;

@dynamic window;
@synthesize post = _post;

@synthesize whenAuthBegin = _whenAuthBegin;
@synthesize whenAuthSucceed = _whenAuthSucceed;
@synthesize whenAuthFailed = _whenAuthFailed;
@synthesize whenAuthCancelled = _whenAuthCancelled;

@synthesize whenShareBegin = _whenShareBegin;
@synthesize whenShareSucceed = _whenShareSucceed;
@synthesize whenShareFailed = _whenShareFailed;
@synthesize whenShareCancelled = _whenShareCancelled;

@dynamic ACTIVITY_SHOW;
@dynamic ACTIVITY_CANCEL;

- (void)load
{
	self.post = [[[ServiceShare_Post alloc] init] autorelease];
}

- (void)unload
{
	self.post = nil;
	
	self.whenAuthBegin		= nil;
	self.whenAuthSucceed	= nil;
	self.whenAuthFailed		= nil;
	self.whenAuthCancelled	= nil;
	
	self.whenShareBegin		= nil;
	self.whenShareSucceed	= nil;
	self.whenShareFailed	= nil;
	self.whenShareCancelled	= nil;
}

#pragma mark -

- (void)powerOn
{
}

- (void)powerOff
{
	[_window release];
	_window = nil;

	self.whenAuthBegin = nil;
	self.whenAuthSucceed = nil;
	self.whenAuthFailed = nil;
	self.whenAuthCancelled = nil;

	self.whenAuthBegin = nil;
	self.whenAuthSucceed = nil;
	self.whenAuthFailed = nil;
	self.whenAuthCancelled = nil;
}

- (void)serviceWillActive
{
}

- (void)serviceDidActived
{
}

- (void)serviceWillDeactive
{
}

- (void)serviceDidDeactived
{
}

#pragma mark -

- (BOOL)authorizing
{
	return self.state == self.STATE_AUTHORIZING ? YES : NO;
}

- (BOOL)sharing
{
	return self.state == self.STATE_SHARING ? YES : NO;
}

#pragma mark -

- (ServiceShare_Window *)window
{
	if ( nil == _window )
	{
		_window = [[ServiceShare_Window alloc] init];
		_window.hidden = YES;
	}
	
	return _window;
}

- (void)activityShow
{
	[[ServiceShare_ActivityWindow sharedInstance] open];
}

- (void)activityCancel
{
	[[ServiceShare_ActivityWindow sharedInstance] close];
}

#pragma mark -

- (BeeServiceBlock)ACTIVITY_SHOW
{
	BeeServiceBlock block = ^ void ( void )
	{
		[self activityShow];
	};
	
	return [[block copy] autorelease];
}

- (BeeServiceBlock)ACTIVITY_CANCEL
{
	BeeServiceBlock block = ^ void ( void )
	{
		[self activityCancel];
	};
	
	return [[block copy] autorelease];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
