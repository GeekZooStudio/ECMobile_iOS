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

#import "Bee_Precompile.h"
#import "Bee_Foundation.h"
#import "Bee_Socket.h"

#import "Bee_HTTPPackage.h"
#import "Bee_HTTPProtocol2.h"
#import "Bee_HTTPRequest2.h"
#import "Bee_HTTPResponse2.h"

#pragma mark -

@class BeeHTTPConnection2;

@interface NSObject(BeeHTTPConnection)
- (void)handleConnection:(BeeHTTPConnection2 *)connection;
@end

#undef	ON_CONNECTION
#define	ON_CONNECTION( conn ) \
		- (void)handleConnection:(BeeHTTPConnection2 *)conn

#pragma mark -

@interface BeeHTTPConnectionPool2 : NSObject

AS_SINGLETON( BeeHTTPConnectionPool2 )

@property (nonatomic, retain) NSMutableArray *		connections;
@property (nonatomic, retain) NSLock *				lock;

- (void)addConnection:(BeeHTTPConnection2 *)conn;
- (void)removeConnection:(BeeHTTPConnection2 *)conn;
- (void)removeAllConnections;

@end

#pragma mark -

@interface BeeHTTPConnection2 : NSObject

AS_INT( STATE_INITING )
AS_INT( STATE_READING )
AS_INT( STATE_PROCESS )
AS_INT( STATE_WRITING )
AS_INT( STATE_CLOSING )
AS_INT( STATE_CLOSED )

@property (nonatomic, assign) id					responder;
@property (nonatomic, readonly) BOOL				initing;
@property (nonatomic, readonly) BOOL				reading;
@property (nonatomic, readonly) BOOL				process;
@property (nonatomic, readonly) BOOL				writing;
@property (nonatomic, readonly) BOOL				closing;
@property (nonatomic, readonly) BOOL				closed;

@property (nonatomic, retain) BeeSocket *			socket;
@property (nonatomic, assign) NSUInteger			state;
@property (nonatomic, retain) BeeHTTPRequest2 *		request;
@property (nonatomic, retain) BeeHTTPResponse2 *	response;

+ (BeeHTTPConnection2 *)acceptFrom:(BeeSocket *)listener;
+ (BeeHTTPConnection2 *)acceptFrom:(BeeSocket *)listener responder:(id)responder;

@end
