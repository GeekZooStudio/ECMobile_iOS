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

#import "Bee_HTTPProtocol2.h"

#pragma mark -

@implementation BeeHTTPProtocol2

@synthesize headLine = _headLine;
@synthesize headers = _headers;
@synthesize headValid = _headValid;

@synthesize eol = _eol;
@synthesize eol2 = _eol2;
@synthesize eolValid = _eolValid;

@synthesize body = _body;
@synthesize bodyOffset = _bodyOffset;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.headLine = nil;
		self.headers = nil;
		self.body = nil;
		self.eol = nil;
		self.eol2 = nil;
	}
	return self;
}

- (void)dealloc
{
	[self.headers removeAllObjects];
	
	self.headLine = nil;
	self.headers = nil;
	self.body = nil;
	self.eol = nil;
	self.eol2 = nil;

	[super dealloc];
}

+ (NSString *)statusMessage:(BeeHTTPStatus)status
{
	switch ( status )
	{
		/* 100 */
		case BeeHTTPStatus_CONTINUE:					return @"Continue";
		case BeeHTTPStatus_SWITCHING_PROTOCOLS:			return @"Switching Protocols";
		case BeeHTTPStatus_PROCESSING:					return @"Processing";

		/* 200 */
		case BeeHTTPStatus_OK:							return @"OK";
		case BeeHTTPStatus_CREATED:						return @"Created";
		case BeeHTTPStatus_ACCEPTED:					return @"Accepted";
		case BeeHTTPStatus_NON_AUTH_INFORMATION:		return @"Non-Authoritative Information";
		case BeeHTTPStatus_NO_CONTENT:					return @"No Content";
		case BeeHTTPStatus_RESET_CONTENT:				return @"Reset Content";
		case BeeHTTPStatus_PARTIAL_CONTENT:				return @"Partial Content";
		case BeeHTTPStatus_MULTI_STATUS:				return @"Multi-Status";

		/* 300 */
		case BeeHTTPStatus_SPECIAL_RESPONSE:			return @"Multiple Choices";
		case BeeHTTPStatus_MOVED_PERMANENTLY:			return @"Moved Permanently";
		case BeeHTTPStatus_MOVED_TEMPORARILY:			return @"Found";
		case BeeHTTPStatus_SEE_OTHER:					return @"See Other";
		case BeeHTTPStatus_NOT_MODIFIED:				return @"Not Modified";
		case BeeHTTPStatus_USE_PROXY:					return @"Use Proxy";
		case BeeHTTPStatus_SWITCH_PROXY:				return @"Switch Proxy";
		case BeeHTTPStatus_TEMPORARY_REDIRECT:			return @"Temporary Redirect";

		/* 400 */
		case BeeHTTPStatus_BAD_REQUEST:					return @"Bad Request";
		case BeeHTTPStatus_UNAUTHORIZED:				return @"Unauthorized";
		case BeeHTTPStatus_PAYMENT_REQUIRED:			return @"Payment Required";
		case BeeHTTPStatus_FORBIDDEN:					return @"Forbidden";
		case BeeHTTPStatus_NOT_FOUND:					return @"Not Found";
		case BeeHTTPStatus_NOT_ALLOWED:					return @"Method Not Allowed";
		case BeeHTTPStatus_NOT_ACCEPTABLE:				return @"Not Acceptable";
		case BeeHTTPStatus_PROXY_AUTH_REQUIRED:			return @"Proxy Authentication Required";
		case BeeHTTPStatus_REQUEST_TIMEOUT:				return @"Request Timeout";
		case BeeHTTPStatus_CONFLICT:					return @"Conflict";
		case BeeHTTPStatus_GONE:						return @"Gone";
		case BeeHTTPStatus_LENGTH_REQUIRED:				return @"Length Required";
		case BeeHTTPStatus_PRECONDITION_FAILED:			return @"Precondition Failed";
		case BeeHTTPStatus_REQUEST_ENTITY_TOO_LARGE:	return @"Request Entity Too Large";
		case BeeHTTPStatus_REQUEST_URI_TOO_LARGE:		return @"Request-URI Too Long";
		case BeeHTTPStatus_UNSUPPORTED_MEDIA_TYPE:		return @"Unsupported Media Type";
		case BeeHTTPStatus_RANGE_NOT_SATISFIABLE:		return @"Requested Range Not Satisfiable";
		case BeeHTTPStatus_EXPECTATION_FAILED:			return @"Expectation Failed";
		case BeeHTTPStatus_TOO_MANY_CONNECTIONS:		return @"There are too many connections from your internet address";
		case BeeHTTPStatus_UNPROCESSABLE_ENTITY:		return @"Unprocessable Entity";
		case BeeHTTPStatus_LOCKED:						return @"Locked";
		case BeeHTTPStatus_FAILED_DEPENDENCY:			return @"Failed Dependency";
		case BeeHTTPStatus_UNORDERED_COLLECTION:		return @"Unordered Collection";
		case BeeHTTPStatus_UPGRADE_REQUIRED:			return @"Upgrade Required";
		case BeeHTTPStatus_RETRY_WITH:					return @"Retry With";

		/* 500 */
		case BeeHTTPStatus_INTERNAL_SERVER_ERROR:		return @"Internal Server Error";
		case BeeHTTPStatus_NOT_IMPLEMENTED:				return @"Not Implemented";
		case BeeHTTPStatus_BAD_GATEWAY:					return @"Bad Gateway";
		case BeeHTTPStatus_SERVICE_UNAVAILABLE:			return @"Service Unavailable";
		case BeeHTTPStatus_GATEWAY_TIMEOUT:				return @"Gateway Timeout";
		case BeeHTTPStatus_VERSION_NOT_SUPPORTED:		return @"HTTP Version Not Supported";
		case BeeHTTPStatus_VARIANT_ALSO_NEGOTIATES:		return @"Variant Also Negotiates";
		case BeeHTTPStatus_INSUFFICIENT_STORAGE:		return @"Insufficient Storage";
		case BeeHTTPStatus_LOOP_DETECTED:				return @"Loop Detected";
		case BeeHTTPStatus_BANDWIDTH_LIMIT_EXCEEDED:	return @"Bandwidth Limit Exceeded";
		case BeeHTTPStatus_NOT_EXTENED:					return @"Not Extended";

		/* 600 */
		case BeeHTTPStatus_UNPARSEABLE_HEADERS:			return @"Unparseable Response Headers";

		default: break;
	}

	return @"";
}

- (NSString *)pack
{
	return [self packIncludeBody:YES];
}

- (NSString *)packIncludeBody:(BOOL)flag
{
	NSMutableString * content = [NSMutableString string];

	NSString * endOfLine = self.eol ? self.eol : @"\r\n";
	NSString * headLine = [self packHeadLine];
	if ( nil == headLine || 0 == headLine.length )
		return nil;
	
	[content appendString:headLine];
	[content appendString:endOfLine];
	
	NSMutableArray * keys = [NSMutableArray arrayWithArray:self.headers.allKeys];
	[keys sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
		return [obj1 compare:obj2];
	}];
	
	for ( NSString * key in keys )
	{
		[content appendFormat:@"%@: %@", key, [self.headers objectForKey:key]];
		[content appendString:endOfLine];
	}
	
	[content appendString:endOfLine];
	
	if ( flag )
	{
		NSString * bodyData = [self packBodyData];
		if ( bodyData && bodyData.length )
		{
			[content appendString:bodyData];
		}
	}

	return content;
}

- (NSString *)packHeadLine
{
	return @"";
}

- (NSString *)packBodyData
{
	return self.body;
}

- (BOOL)unpack:(NSString *)text
{
	return [self unpack:text includeBody:YES];
}

- (BOOL)unpack:(NSString *)text includeBody:(BOOL)bodyFlag
{
	#define __STATE_INITIAL		(0)
	#define __STATE_HEADER1		(1)
	#define __STATE_HEADER2		(2)
	#define __STATE_EOL			(3)
	#define __STATE_BODY		(4)
	#define __STATE_ERROR		(5)
	#define __STATE_END			(6)

	NSUInteger			state = __STATE_INITIAL;
	NSCharacterSet *	eolCharset = [NSCharacterSet characterSetWithCharactersInString:@"\r\n"];
	NSCharacterSet *	colCharset = [NSCharacterSet characterSetWithCharactersInString:@":"];
	
	NSUInteger			line = 0;
	NSUInteger			offset = 0;
	
	BOOL				shouldContinue = YES;
	BOOL				succeed = YES;

	while ( shouldContinue )
	{
		if ( offset >= text.length )
		{
			state = __STATE_END;
			break;
		}

		switch ( state )
		{
		case __STATE_INITIAL:
			{
//				INFO( @"Start to parse" );
				
				self.headLine = nil;
				self.headers = [NSMutableDictionary dictionary];
				self.body = [NSMutableString string];
				
				if ( nil == text || 0 == text.length )
				{
					state = __STATE_ERROR;
					break;
				}

				state = __STATE_HEADER1;
			}
			break;

		case __STATE_HEADER1:
		case __STATE_HEADER2:
			{
//				INFO( @"Found header" );
				
				NSString * header = [text substringFromIndex:offset untilCharset:eolCharset];
				if ( nil == header || 0 == header.length )
				{
					state = __STATE_ERROR;
					break;
				}

				if ( __STATE_HEADER1 == state )
				{
					BOOL correct = [self unpackHeadLine:header];
					if ( NO == correct )
					{
						state = __STATE_ERROR;
						break;
					}
					
					self.headLine = header;
					
//					INFO( @"%@", header );
				}
				else
				{
					NSString * key = [text substringFromIndex:offset untilCharset:colCharset];
					if ( key )
					{
						key = key.trim;
					}

					if ( nil == key || 0 == key.length || key.length >= header.length )
					{
						state = __STATE_ERROR;
						break;
					}

					NSString * value = [text substringFromIndex:(offset + key.length + 1) untilCharset:eolCharset];
					if ( value )
					{
						value = value.trim;
					}
					
					if ( nil == value || 0 == value.length )
					{
						state = __STATE_ERROR;
						break;
					}

					if ( nil == self.headers )
					{
						self.headers = [NSMutableDictionary dictionary];
					}
					
					[self.headers setObject:value forKey:key];
					
//					INFO( @"%@: %@", key, value );
				}

				offset += header.length;
				state = __STATE_EOL;
			}
			break;

		case __STATE_EOL:
			{
//				INFO( @"Found EOL" );
				
				if ( offset + 1 >= text.length )
				{
					state = __STATE_END;
					break;
				}

				if ( NO == self.eolValid )
				{
					NSInteger eolLength = 0;

					for ( ; offset + eolLength < text.length; ++eolLength )
					{
						unichar ch = [text characterAtIndex:(offset + eolLength)];
						if ( '\n' != ch && '\r' != ch )
						{
							break;
						}
					}

					if ( 0 == eolLength )
					{
						state = __STATE_ERROR;
						break;
					}

					self.eol = [text substringWithRange:NSMakeRange( offset, eolLength )];
					self.eol2 = [NSString stringWithFormat:@"%@%@", self.eol, self.eol];
					self.eolValid = YES;
				}
				
				if ( nil == self.eol || nil == self.eol2 )
				{
					state = __STATE_ERROR;
					break;					
				}

				if ( offset + self.eol2.length <= text.length )
				{
					NSRange range;
					range.location = offset;
					range.length = self.eol2.length;

					if ( NSOrderedSame == [text compare:self.eol2 options:NSLiteralSearch range:range] )
					{						
						self.headValid = YES;

						offset += self.eol2.length;
						line += 1;
						state = __STATE_BODY;
						break;
					}
				}

				if ( offset + self.eol.length <= text.length )
				{
					NSRange range;
					range.location = offset;
					range.length = self.eol.length;
					
					if ( NSOrderedSame == [text compare:self.eol options:NSLiteralSearch range:range] )
					{
						offset += self.eol.length;
						line += 1;
						state = __STATE_HEADER2;
						break;
					}
				}
				
				state = __STATE_ERROR;
			}
			break;

		case __STATE_BODY:
			{
//				INFO( @"Found body" );

				self.bodyOffset = offset;

				if ( bodyFlag )
				{
					if ( nil == self.body )
					{
						self.body = [NSMutableString string];
					}

					NSString * body = [text substringFromIndex:offset];
					if ( body )
					{
						[self.body appendString:body];
						
//						INFO( @"%@", body );
					}
				}

				offset = text.length;
				state = __STATE_END;
			}
			break;
				
		case __STATE_ERROR:
			{
				ERROR( @"Failed to parse HTTP package at line #%d", line + 1 );

				succeed = NO;
				state = __STATE_END;
			}
			break;

		case __STATE_END:
			{
//				INFO( @"End of parsing" );
				
				shouldContinue = NO;
			}
			break;
	
		default:
			break;
		}
	}

	return succeed;
}

- (BOOL)unpackHeadLine:(NSString *)text
{
	return YES;
}

- (BOOL)unpackBodyData:(NSString *)text
{
	return YES;
}

- (void)appendHead:(NSString *)key value:(NSString *)value
{
	if ( nil == key || 0 == key.length )
		return;
	
	if ( nil == self.headers )
	{
		self.headers = [NSMutableDictionary dictionary];
	}
	
	if ( value && value.length )
	{
		[self.headers setObject:value forKey:key];
	}
	else
	{
		[self.headers removeObjectForKey:key];
	}
}

- (void)appendBody:(id)obj
{
	if ( nil == obj )
		return;
	
	if ( nil == self.body )
	{
		self.body = [NSMutableString string];
	}

	NSString * string = [obj asNSString];

	if ( string && string.length )
	{
		[self.body appendString:string];
	}
}

@end
