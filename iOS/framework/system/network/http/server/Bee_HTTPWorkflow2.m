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

#import "Bee_HTTPWorkflow2.h"
#import "Bee_HTTPWorklet2.h"
#import "Bee_HTTPWorkenv2.h"

#pragma mark -

@interface BeeHTTPWorkflow2()
{
	NSMutableDictionary *	__GLOBALS;
	NSMutableDictionary *	__SERVER;
	NSMutableDictionary *	__GET;
	NSMutableDictionary *	__POST;
	NSMutableDictionary *	__FILES;
	NSMutableDictionary *	__COOKIE;
	NSMutableDictionary *	__SESSION;
	NSMutableDictionary *	__REQUEST;
	NSMutableDictionary *	__ENV;
	
	NSMutableString *		__buffer;
}
@end

#pragma mark -

@implementation BeeHTTPWorkflow2

@synthesize connection = _connection;
@synthesize worklets = _worklets;

+ (BeeHTTPWorkflow2 *)workflow
{
	BeeHTTPWorkflow2 * workflow = [[[BeeHTTPWorkflow2 alloc] init] autorelease];
	if ( workflow )
	{
		[workflow.worklets addObject:[BeeHTTPWorklet2 log]];
		[workflow.worklets addObject:[BeeHTTPWorklet2 processRequest]];
		[workflow.worklets addObject:[BeeHTTPWorklet2 processResponse]];
	}
	return workflow;
}

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.connection = nil;
		self.worklets = [NSMutableArray array];

		__GLOBALS	= [[NSMutableDictionary alloc] init];
		__SERVER	= [[NSMutableDictionary alloc] init];
		__GET		= [[NSMutableDictionary alloc] init];
		__POST		= [[NSMutableDictionary alloc] init];
		__FILES		= [[NSMutableDictionary alloc] init];
		__COOKIE	= [[NSMutableDictionary alloc] init];
		__SESSION	= [[NSMutableDictionary alloc] init];
		__REQUEST	= [[NSMutableDictionary alloc] init];
		__ENV		= [[NSMutableDictionary alloc] init];
		__buffer	= [[NSMutableString alloc] init];
	}
	return self;
}

- (void)dealloc
{
	[__GLOBALS release];
	[__SERVER release];
	[__GET release];
	[__POST release];
	[__FILES release];
	[__COOKIE release];
	[__SESSION release];
	[__REQUEST release];
	[__ENV release];
	
	[__buffer release];

	self.connection = nil;
	self.worklets = nil;

	[super dealloc];
}

- (BOOL)processWithConnection:(BeeHTTPConnection2 *)conn
{
	INFO( @"start workflow" );

	[__GLOBALS removeAllObjects];
	[__SERVER removeAllObjects];
	[__GET removeAllObjects];
	[__POST removeAllObjects];
	[__FILES removeAllObjects];
	[__COOKIE removeAllObjects];
	[__SESSION removeAllObjects];
	[__REQUEST removeAllObjects];
	[__ENV removeAllObjects];	
	[__buffer setString:@""];

	_SERVER		= __SERVER;
	_GET		= __GET;
	_POST		= __POST;
	_FILES		= __FILES;
	_COOKIE		= __COOKIE;
	_SESSION	= __SESSION;
	_REQUEST	= __REQUEST;
	_ENV		= __ENV;
	_echoBuffer	= __buffer;

	self.connection = conn;

	BOOL succeed = NO;
	
	for ( BeeHTTPWorklet2 * worklet in self.worklets )
	{
		INFO( @"	-> '%@'", worklet.name );

		succeed = [worklet processWithWorkflow:self];
		if ( NO == succeed )
		{
			break;
		}
	}
	
	INFO( @"end workflow, %@", succeed ? @"OK" : @"FAILED" );

	return succeed;
}

@end
