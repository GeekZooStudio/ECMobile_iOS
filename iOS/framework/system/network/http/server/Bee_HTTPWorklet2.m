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

#import "Bee_HTTPWorklet2.h"
#import "Bee_HTTPWorkflow2.h"
#import "Bee_HTTPWorkenv2.h"
#import "Bee_HTTPRouter2.h"

#import "Bee_Reachability.h"

#pragma mark -

@implementation BeeHTTPWorklet2

@synthesize name = _name;
@synthesize process = _process;

+ (BeeHTTPWorklet2 *)worklet
{
	return [[[BeeHTTPWorklet2 alloc] init] autorelease];
}

+ (BeeHTTPWorklet2 *)worklet:(BeeHTTPWorklet2Block)block
{
	return [self worklet:nil process:block];
}

+ (BeeHTTPWorklet2 *)worklet:(NSString *)name process:(BeeHTTPWorklet2Block)block
{
	BeeHTTPWorklet2 * worklet = [[[BeeHTTPWorklet2 alloc] init] autorelease];
	if ( worklet )
	{
		worklet.name = name;
		worklet.process = block;
	}
	return worklet;
}

+ (BeeHTTPWorklet2 *)log
{
	return [self worklet:@(__PRETTY_FUNCTION__) process:^BOOL(BeeHTTPWorkflow2 *workflow)
	{
		return YES;
	}];
}

+ (BeeHTTPWorklet2 *)processRequest
{
	return [self worklet:@(__PRETTY_FUNCTION__) process:^BOOL(BeeHTTPWorkflow2 *workflow)
	{
		BeeHTTPConnection2 * conn = workflow.connection;
		
		if ( nil == conn )
		{
			conn.response.status = BeeHTTPStatus_INTERNAL_SERVER_ERROR;
			conn.response.Server = @"bhttpd/1.0 (OSX)";
			conn.response.Date = [[NSDate date] description];
			return NO;
		}
		
		if ( 0 == conn.socket.readableSize )
		{
			conn.response.status = BeeHTTPStatus_INTERNAL_SERVER_ERROR;
			conn.response.Server = @"bhttpd/1.0 (OSX)";
			conn.response.Date = [[NSDate date] description];
			return NO;
		}
		
		if ( NO == conn.request.headValid )
		{
			BOOL succeed = [conn.request unpack:conn.socket.readableString includeBody:NO];
			if ( NO == succeed )
			{
				conn.response.status = BeeHTTPStatus_INTERNAL_SERVER_ERROR;
				return NO;
			}
		}

		_SERVER[@"PHP_SELF"]				= @"";
		_SERVER[@"argv"]					= @"";
		_SERVER[@"argc"]					= @0;
		_SERVER[@"GATEWAY_INTERFACE"]		= @"";	// @"CGI/1.1";

		_SERVER[@"SERVER_ADDR"]				= [BeeReachability localIP];
		_SERVER[@"SERVER_NAME"]				= @"";
		_SERVER[@"SERVER_SOFTWARE"]			= @"";

		_SERVER[@"REQUEST_TIME"]			= [[NSDate date] description];
		_SERVER[@"REQUEST_TIME_FLOAT"]		= @([[NSDate date] timeIntervalSince1970]);
		_SERVER[@"QUERY_STRING"]			= @"";	// TODO: QUERY_STRING
		_SERVER[@"DOCUMENT_ROOT"]			= [BeeSandbox docPath];
		_SERVER[@"HTTP_ACCEPT"]				= conn.request.Accept ? conn.request.Accept : @"";
		_SERVER[@"HTTP_ACCEPT_CHARSET"]		= conn.request.AcceptCharset ? conn.request.AcceptCharset : @"";
		_SERVER[@"HTTP_ACCEPT_ENCODING"]	= conn.request.AcceptEncoding ? conn.request.AcceptEncoding : @"";
		_SERVER[@"HTTP_ACCEPT_LANGUAGE"]	= conn.request.AcceptLanguage ? conn.request.AcceptLanguage : @"";
		_SERVER[@"HTTP_CONNECTION"]			= conn.request.Connection ? conn.request.Connection : @"";
		_SERVER[@"HTTP_HOST"]				= conn.request.Host ? conn.request.Host : @"";
		_SERVER[@"HTTP_REFERER"]			= conn.request.Referer ? conn.request.Referer : @"";
		_SERVER[@"HTTP_USER_AGENT"]			= conn.request.UserAgent ? conn.request.UserAgent : @"";
		_SERVER[@"HTTPS"]					= [conn.request.Host hasPrefix:@"https"] ? @"on" : @"off";
		_SERVER[@"REMOTE_ADDR"]				= @"";	// TODO: REMOTE_ADDR
		_SERVER[@"REMOTE_HOST"]				= @"";	// TODO: REMOTE_HOST
		_SERVER[@"REMOTE_PORT"]				= @"";	// TODO: REMOTE_PORT
		_SERVER[@"REMOTE_USER"]				= @"";	// TODO: REMOTE_USER
		_SERVER[@"REDIRECT_REMOTE_USER"]	= @"";	// TODO: REDIRECT_REMOTE_USER
		_SERVER[@"SCRIPT_FILENAME"]			= @"";	// TODO: SCRIPT_FILENAME

		_SERVER[@"SERVER_ADMIN"]			= @"";	// TODO: SERVER_ADMIN
		_SERVER[@"SERVER_PORT"]				= @"";	// TODO: SERVER_PORT
		_SERVER[@"SERVER_SIGNATURE"]		= @"";	// TODO: SERVER_SIGNATURE
		_SERVER[@"PATH_TRANSLATED"]			= @"";	// TODO: PATH_TRANSLATED
		_SERVER[@"SCRIPT_NAME"]				= @(__FILE__);	// TODO: SCRIPT_NAME
	
		_SERVER[@"REQUEST_URI"]				= conn.request.resource;

		_SERVER[@"PHP_AUTH_DIGEST"]			= @"";	// TODO: PHP_AUTH_DIGEST
		_SERVER[@"PHP_AUTH_USER"]			= @"";	// TODO: PHP_AUTH_USER
		_SERVER[@"PHP_AUTH_PW"]				= @"";	// TODO: PHP_AUTH_PW
		_SERVER[@"AUTH_TYPE"]				= @"";	// TODO: AUTH_TYPE
		_SERVER[@"PATH_INFO"]				= @"";	// TODO: PATH_INFO
		_SERVER[@"ORIG_PATH_INFO"]			= @"";	// TODO: ORIG_PATH_INFO

		if ( BeeHTTPVersion_11 == conn.request.version )
		{
			_SERVER[@"SERVER_PROTOCOL"] = @"HTTP/1.1";
		}
		else if ( BeeHTTPVersion_10 == conn.request.version )
		{
			_SERVER[@"SERVER_PROTOCOL"] = @"HTTP/1.0";
		}
		else if ( BeeHTTPVersion_9 == conn.request.version )
		{
			_SERVER[@"SERVER_PROTOCOL"] = @"HTTP/0.9";
		}
		else
		{
			conn.response.status = BeeHTTPStatus_INTERNAL_SERVER_ERROR;
			return NO;
		}
		
		if ( BeeHTTPMethod_GET == conn.request.method )
		{
			_SERVER[@"REQUEST_METHOD"] = @"GET";
			
			// TODO: GET
		}
		else if ( BeeHTTPMethod_POST == conn.request.method )
		{
			_SERVER[@"REQUEST_METHOD"] = @"POST";
			
			// TODO: POST
		}
		else if ( BeeHTTPMethod_HEAD == conn.request.method )
		{
			_SERVER[@"REQUEST_METHOD"] = @"HEAD";
		}
		else if ( BeeHTTPMethod_PUT == conn.request.method )
		{
			_SERVER[@"REQUEST_METHOD"] = @"PUT";
		}
		else if ( BeeHTTPMethod_DELETE == conn.request.method )
		{
			_SERVER[@"REQUEST_METHOD"] = @"DELETE";
		}
		else
		{
			conn.response.status = BeeHTTPStatus_INTERNAL_SERVER_ERROR;
			return NO;
		}

		// TODO: _FILES
		// TODO: _REQUEST
		// TODO: _SESSION
		// TODO: _ENV
		// TODO: _COOKIE
		
		// TODO:
		
		return YES;
	}];
}

+ (BeeHTTPWorklet2 *)processResponse
{
	return [self worklet:@(__PRETTY_FUNCTION__) process:^BOOL(BeeHTTPWorkflow2 *workflow)
	{
		BeeHTTPConnection2 * conn = workflow.connection;

		if ( nil == conn.response )
		{
			conn.response = conn.request.response;

			if ( nil == conn.response )
			{
				conn.response.status = BeeHTTPStatus_INTERNAL_SERVER_ERROR;
				return NO;
			}
		}

		[[BeeHTTPRouter2 sharedInstance] route:conn.request.resource];

		if ( _echoBuffer && _echoBuffer.length )
		{
			[conn.response appendBody:_echoBuffer];
		}
		
//		if ( nil == conn.response.ContentType )
//		{
//			conn.response.ContentType = @"text/html";
//		}

		if ( BeeHTTPMethod_GET == conn.request.method )
		{
			// TODO:
		}
		else if ( BeeHTTPMethod_POST == conn.request.method )
		{
			conn.response.ContentLength = [NSString stringWithFormat:@"%lu", conn.response.body.length];
		}
		else if ( BeeHTTPMethod_HEAD == conn.request.method )
		{
			// TODO:
		}
		else if ( BeeHTTPMethod_PUT == conn.request.method )
		{
			// TODO:
		}
		else if ( BeeHTTPMethod_DELETE == conn.request.method )
		{
			// TODO:
		}
		
		return YES;
	}];
}

- (BOOL)processWithWorkflow:(BeeHTTPWorkflow2 *)flow
{
	if ( self.process )
	{
		return self.process( flow );
	}
	else
	{
		return YES;	
	}
}

@end
