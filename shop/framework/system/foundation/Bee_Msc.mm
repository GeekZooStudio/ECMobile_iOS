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

#import "Bee_Msc.h"
#import "Bee_SystemInfo.h"
#import "Bee_UnitTest.h"
#import "NSArray+BeeExtension.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

DEF_PACKAGE( BeePackage_System, BeeMsc, msc );

#pragma mark -

@implementation BeeMsc
{
	NSFileHandle *	_file;
}

DEF_SINGLETON( BeeMsc )

+ (BOOL)autoLoad
{
	[BeeMsc sharedInstance];
	
	return YES;
}

- (id)init
{
	self = [super init];
	if ( self )
	{
	#if __BEE_DEVELOPMENT__
		
		NSString *		filePath = [NSString stringWithFormat:@"%@/msc_%@.log", [BeeSandbox docPath], [[NSDate date] stringWithDateFormat:@"yyyyMMdd_hhmmss"]];
		NSFileManager * fileManager = [NSFileManager defaultManager];
		
		BOOL succeed = [fileManager createFileAtPath:filePath contents:nil attributes:nil];
		if ( NO == succeed || NO == [fileManager fileExistsAtPath:filePath] )
		{
			ERROR( @"failed to create file '%@'", filePath );
			return self;
		}
		
		_file = [[NSFileHandle fileHandleForWritingAtPath:filePath] retain];
		if ( nil == _file )
		{
			ERROR( @"failed to open file '%@'", filePath );
			return self;
		}

		filePath = [filePath stringByReplacingOccurrencesOfString:@" " withString:@"\\ "];

		fprintf( stderr, "MSC:  %s\n", [filePath stringByDeletingLastPathComponent].UTF8String );
		fprintf( stderr, "MSC:  %s\n", filePath.UTF8String );
		fprintf( stderr, "\n" );
	#endif	// #if __BEE_DEVELOPMENT__
	}
	return self;
}

- (void)dealloc
{
	[_file closeFile];
	[_file release];

	[super dealloc];
}

- (void)message:(NSString *)name from:(NSString *)from to:(NSString *)to
{
#if __BEE_DEVELOPMENT__
	if ( _file )
	{
		NSString * text = [NSString stringWithFormat:@"%@|%@|%@\n", name, from, to];
		if ( text )
		{
			[_file seekToEndOfFile];
			[_file writeData:[text asNSData]];
		}
	}
#endif	// #if __BEE_DEVELOPMENT__
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

TEST_CASE( BeeMsc )
{
}
TEST_CASE_END

#endif	// #if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__
