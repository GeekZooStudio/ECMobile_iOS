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

#import "Bee_HTTPConnection2.h"
#import "Bee_HTTPWorkflow2.h"

#pragma mark -

@implementation NSObject(BeeHTTPConnection)

- (void)handleConnection:(BeeHTTPConnection2 *)connection
{
}

@end

#pragma mark -

@implementation BeeHTTPConnectionPool2

DEF_SINGLETON( BeeHTTPConnectionPool2 )

@synthesize connections = _connections;
@synthesize lock = _lock;

- (id)init
{
	self = [super init];
	if ( self )
	{
		_connections = [[NSMutableArray alloc] init];
		_lock = [[NSLock alloc] init];
	}
	return self;
}

- (void)dealloc
{
	[_connections removeAllObjects];
	[_connections release];
	
	[_lock release];
	
	[super dealloc];
}

- (void)addConnection:(BeeHTTPConnection2 *)conn
{
	[_lock lock];
	[_connections addObject:conn];
	[_lock unlock];
}

- (void)removeConnection:(BeeHTTPConnection2 *)conn
{
	[_lock lock];
	[_connections removeObject:conn];
	[_lock unlock];
	
	[conn autorelease];
}

- (void)removeAllConnections
{
	[_lock lock];
	[_connections removeAllObjects];
	[_lock unlock];
}

@end

#pragma mark -

@implementation BeeHTTPConnection2

DEF_INT( STATE_INITING,		0 )
DEF_INT( STATE_READING,		1 )
DEF_INT( STATE_PROCESS,		2 )
DEF_INT( STATE_WRITING,		3 )
DEF_INT( STATE_CLOSING,		4 )
DEF_INT( STATE_CLOSED,		5 )

@synthesize responder = _responder;
@dynamic initing;
@dynamic reading;
@dynamic process;
@dynamic writing;
@dynamic closing;
@dynamic closed;

@synthesize state = _state;
@synthesize socket = _socket;
@synthesize request = _request;
@synthesize response = _response;

+ (BeeHTTPConnection2 *)acceptFrom:(BeeSocket *)listener
{
	return [self acceptFrom:listener responder:nil];
}

+ (BeeHTTPConnection2 *)acceptFrom:(BeeSocket *)listener responder:(id)responder
{
	if ( nil == listener )
	{
		return [[[BeeHTTPConnection2 alloc] init] autorelease];
	}
	
	BeeHTTPConnection2 * conn = [[[BeeHTTPConnection2 alloc] init] autorelease];
	if ( nil == conn )
	{
		[listener refuse];
		return nil;
	}

	BeeSocket * socket = [listener accept];
	if ( nil == socket )
	{
		[listener refuse];
		return nil;
	}

	socket.autoConsume = YES;
	socket.autoHeartbeat = NO;
	socket.autoReconnect = NO;
	[socket addResponder:conn];

	conn.socket = socket;
	conn.responder = responder;	
	return conn;
}

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.socket = nil;
		self.state = BeeHTTPConnection2.STATE_INITING;
		self.request = [BeeHTTPRequest2 request];
		self.response = nil;
	}
	return self;
}

- (void)dealloc
{
	self.socket = nil;
	self.request = nil;
	self.response = nil;

	[super dealloc];
}

- (BOOL)initing
{
	return (BeeHTTPConnection2.STATE_INITING == self.state) ? YES : NO;
}

- (BOOL)reading
{
	return (BeeHTTPConnection2.STATE_READING == self.state) ? YES : NO;
}

- (BOOL)process
{
	return (BeeHTTPConnection2.STATE_PROCESS == self.state) ? YES : NO;
}

- (BOOL)writing
{
	return (BeeHTTPConnection2.STATE_WRITING == self.state) ? YES : NO;
}

- (BOOL)closing
{
	return (BeeHTTPConnection2.STATE_CLOSING == self.state) ? YES : NO;
}

- (BOOL)closed
{
	return (BeeHTTPConnection2.STATE_CLOSED == self.state) ? YES : NO;
}

- (void)changeState:(NSUInteger)state
{
	if ( state != self.state )
	{
		self.state = state;
		
		if ( self.responder && [self.responder respondsToSelector:@selector(handleConnection:)] )
		{
			[self.responder performSelector:@selector(handleConnection:) withObject:self];
		}
	}
}

ON_SOCKET( sock )
{
	if ( sock != self.socket )
	{
		ERROR( @"Invalid socket file handle" );

		// TODO: 
		return;
	}

	if ( sock.accepting )
	{
		[[BeeHTTPConnectionPool2 sharedInstance] addConnection:self];
	}
	else if ( sock.accepted )
	{
		[self changeState:BeeHTTPConnection2.STATE_READING];
	}
	else if ( sock.readable )
	{
		if ( BeeHTTPConnection2.STATE_READING == self.state )
		{
			BOOL done = [self.request checkIntegrity];
			if ( done )
			{
				[self changeState:BeeHTTPConnection2.STATE_PROCESS];
				
				[[BeeHTTPWorkflow2 workflow] processWithConnection:self];
				
				[self changeState:BeeHTTPConnection2.STATE_WRITING];
				
				[self.socket send:[self.response packIncludeBody:YES]];
				[self.socket disconnect];
			}
		}
	}
	else if ( sock.writable )
	{
	}
	else if ( sock.disconnecting )
	{
		[self changeState:BeeHTTPConnection2.STATE_CLOSING];
	}
	else if ( sock.disconnected )
	{
		[self changeState:BeeHTTPConnection2.STATE_CLOSED];
		
		[[BeeHTTPConnectionPool2 sharedInstance] removeConnection:self];
	}
}

@end
