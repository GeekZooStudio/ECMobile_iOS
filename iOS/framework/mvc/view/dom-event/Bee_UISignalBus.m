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

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Bee_UISignalBus.h"
#import "Bee_UISignalRouter.h"
#import "BeeUISignal+SourceView.h"
#import "UIView+Tag.h"

#pragma mark -

@interface BeeUISignalBus()
+ (void)checkForeign:(BeeUISignal *)signal;
+ (void)checkForeign:(BeeUISignal *)signal forTarget:(id)target;
@end

#pragma mark -

@implementation BeeUISignalBus

+ (void)checkForeign:(BeeUISignal *)signal
{
	if ( signal.name )
	{
		NSArray * nameComponents = [signal.name componentsSeparatedByString:@"."];
		if ( nameComponents.count > 2 && [[nameComponents objectAtIndex:0] isEqualToString:@"signal"] )
		{
			NSString * sourceName = [[signal.source class] description];
			NSString * namePrefix = [nameComponents objectAtIndex:1];
			
			if ( [sourceName isEqualToString:namePrefix] )
			{
				signal.foreign = NO;
			}
			else
			{
				signal.prefix = namePrefix;
				signal.foreign = YES;
				signal.foreignSource = signal.source;
			}
		}
		else
		{
			signal.foreign = NO;
		}
	}
}

+ (void)checkForeign:(BeeUISignal *)signal forTarget:(id)target
{
	if ( signal.foreign )
	{
		if ( signal.source == signal.foreignSource )
		{
			NSString * targetName = [[target class] description];
			
			if ( [targetName isEqualToString:signal.prefix] )
			{
				signal.source = target;
			}
//			else
//			{
//				Class targetClass = NSClassFromString( targetName );
//				Class sourceClass = NSClassFromString( signal.prefix );
//
//				if ( sourceClass == targetClass || [targetClass isSubclassOfClass:sourceClass] )
//				{
//					signal.source = target;
//				}
//			}
		}
	}
}

+ (BOOL)send:(BeeUISignal *)signal
{
	if ( signal.dead )
	{
		ERROR( @"signal '%@', already dead", signal.name );
		return NO;
	}

//	[signal log:signal.source];
//	[signal log:signal.target];

	[self checkForeign:signal];

	if ( [signal.target isKindOfClass:[UIView class]] || [signal.target isKindOfClass:[UIViewController class]] )
	{
		signal.sending = YES;

		[[BeeUISignalRouter sharedInstance] routes:signal];
	}
	else
	{
		signal.arrived = YES;
	}

	if ( signal.arrived )
	{
		if ( signal.sourceView.tagString )
		{
			INFO( @"'%@' > '#%@' > %@ > Done", signal.prettyName, signal.sourceView.tagString, [signal.jumpPath join:@" > "] );
		}
		else
		{
			INFO( @"'%@' > %@ > Done", signal.prettyName, [signal.jumpPath join:@" > "] );
		}
	}
	else if ( signal.dead )
	{
		if ( signal.sourceView.tagString )
		{
			INFO( @"'%@' > '#%@' > %@ > Kill", signal.prettyName, signal.sourceView.tagString, [signal.jumpPath join:@" > "] );
		}
		else
		{
			INFO( @"'%@' (%@) > %@ > Kill", signal.prettyName, [signal.jumpPath join:@" > "] );
		}
	}

	return signal.arrived;
}

+ (BOOL)forward:(BeeUISignal *)signal
{
	return [self forward:signal to:nil];
}

+ (BOOL)forward:(BeeUISignal *)signal to:(id)target
{
	if ( signal.dead )
	{
		ERROR( @"signal '%@', already dead", signal.name );
		return NO;
	}

	if ( nil == signal.target )
	{
		ERROR( @"signal '%@', no target", signal.name );
		return NO;
	}

	if ( nil == target )
	{
		if ( [signal.target isKindOfClass:[UIView class]] )
		{
			target = ((UIView *)signal.target).superview;
		}
	}

	[signal log:signal.target];

	if ( nil == target )
	{
		signal.arrived = YES;
		return YES;
	}

	[self checkForeign:signal forTarget:target];
		
	if ( [target isKindOfClass:[UIView class]] || [target isKindOfClass:[UIViewController class]] )
	{
		signal.target = target;		
		signal.sending = YES;

		[[BeeUISignalRouter sharedInstance] routes:signal];
	}
	else
	{
		signal.arrived = YES;
	}

	return signal.arrived;
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
