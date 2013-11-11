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

#import "Bee_HTTPWorkenv2.h"

#pragma mark -

NSMutableDictionary *	_GLOBALS = nil;
NSMutableDictionary *	_SERVER = nil;
NSMutableDictionary *	_GET = nil;
NSMutableDictionary *	_POST = nil;
NSMutableDictionary *	_FILES = nil;
NSMutableDictionary *	_COOKIE = nil;
NSMutableDictionary *	_SESSION = nil;
NSMutableDictionary *	_REQUEST = nil;
NSMutableDictionary *	_ENV = nil;

NSMutableString *		_echoBuffer = nil;

#pragma mark -

void echo( NSString * text, ... )
{
	if ( nil == _echoBuffer )
		return;

	va_list args;
	va_start( args, text );
	
	NSString * content = [[[NSString alloc] initWithFormat:(NSString *)text arguments:args] autorelease];
	if ( content && content.length )
	{
		[_echoBuffer appendString:content];
	}
	
	va_end( args );
}

extern void header( NSString * header )
{
	
}
