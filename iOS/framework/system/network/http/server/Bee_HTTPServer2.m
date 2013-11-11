//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//
//	Copyright (c) 2013-2014, {Bee} open source community
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

#import "Bee_HTTPServer2.h"

#pragma mark -

DEF_PACKAGE( BeePackage_HTTP, BeeHTTPServer2, server );

#pragma mark -

#undef	DEFAULT_PORT
#define	DEFAULT_PORT	(3000)

#pragma mark -

@interface BeeHTTPServer2()
{
	NSUInteger	_port;
	NSUInteger	_running;
}

@property (nonatomic, retain) BeeSocket * listener;

@end

#pragma mark -

@implementation BeeHTTPServer2

DEF_SINGLETON( BeeHTTPServer2 )

@synthesize port = _port;
@dynamic running;
@synthesize listener = _listener;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.port = DEFAULT_PORT;
		self.running = NO;
		self.listener = nil;
	}
	return self;
}

- (void)dealloc
{
	[self stop];

	self.running = NO;
	self.listener = nil;

	[super dealloc];
}

- (BOOL)running
{
	return _running;
}

- (void)setRunning:(BOOL)flag
{
	if ( flag != _running )
	{
		if ( flag )
		{
			[self start];
		}
		else
		{
			[self stop];
		}
	}
}

- (BOOL)start
{
	if ( self.running )
	{
		ERROR( @"HTTP server already running" );
		return NO;
	}

	BeeSocket * sock = [BeeSocket socket];
	if ( sock )
	{
		[sock addResponder:self];
		
		BOOL succeed = [sock listen:self.port];
		if ( succeed )
		{
			self.listener = sock;
			self.running = YES;
			return YES;
		}
	}
	
	ERROR( @"HTTP server cannot listen on port %d", self.port );
	return NO;
}

- (BOOL)stop
{
	if ( self.running )
	{
		ERROR( @"HTTP server not running" );
		return NO;
	}

	if ( self.listener )
	{
		[self.listener removeAllResponders];
		[self.listener stop];
		self.listener = nil;
	}
	
	self.running = NO;
	return YES;
}

ON_SOCKET( sock )
{
	if ( sock.listenning )
	{
		INFO( @"HTTP server, starting" );
	}
	else if ( sock.acceptable )
	{
		INFO( @"HTTP server, new connection" );

		BeeHTTPConnection2 * connection = [BeeHTTPConnection2 acceptFrom:sock];
		if ( nil == connection )
		{
			ERROR( @"HTTP server cannot accept new connections" );
		}
	}
	else if ( sock.stopping )
	{
		INFO( @"HTTP server, stopping" );
	}
	else if ( sock.stopped )
	{
		INFO( @"HTTP server, stopped" );
	}
}

@end
