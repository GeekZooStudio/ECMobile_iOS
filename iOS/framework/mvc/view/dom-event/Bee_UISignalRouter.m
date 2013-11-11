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

#import "Bee_UISignalRouter.h"

#import "UIView+Tag.h"
#import "UIView+UIViewController.h"

#pragma mark -

@interface BeeUISignalRouter()
{
	NSMutableDictionary *	_selectorCache;
}
@end

#pragma mark -

@implementation BeeUISignalRouter

DEF_SINGLETON( BeeUISignalRouter )

- (id)init
{
	self = [super init];
	if ( self )
	{
		_selectorCache = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void)dealloc
{
	[_selectorCache removeAllObjects];
	[_selectorCache release];
	
	[super dealloc];
}

- (BOOL)performSignal:(BeeUISignal *)signal target:(id)target selector:(SEL)sel class:(Class)clazz
{
	if ( nil == signal || nil == target || nil == sel || nil == clazz )
		return NO;

#if __BEE_AUTO_SIGNAL_ROUTING__

	Method method = class_getInstanceMethod( clazz, sel );
	if ( method )
	{
		IMP imp = method_getImplementation( method );
		if ( imp )
		{
			imp( target, sel, signal );
			return YES;
		}
	}
	
#else	// #if __BEE_AUTO_SIGNAL_ROUTING__
	
	if ( [target respondsToSelector:sel] )
	{
		[target performSelector:sel withObject:signal];
		return YES;
	}

#endif	//#if __BEE_AUTO_SIGNAL_ROUTING__
	
	return NO;
}

- (void)routes:(BeeUISignal *)signal
{
	NSString *	signalName = signal.name;
	id			signalSource = signal.source;
	id			signalTarget = signal.target;

	if ( nil == signalName || nil == signalSource || nil == signalTarget )
	{
		ERROR( @"Wrong signal parameter" );
		return;
	}
	
	if ( [signalTarget isKindOfClass:[UIView class]] )
	{
//		UIView * nextView = (UIView *)signalTarget;
//		if ( nil == nextView.superview )
		{
			UIViewController * nextController = [signalTarget viewController];
			if ( nextController )
			{
				signalTarget = nextController;
			}
		}
	}

	if ( [signalTarget isKindOfClass:[UIView class]] )
	{
//		UIView * nextView = (UIView *)signalTarget;
//		if ( nil == nextView.superview )
		{
			UIViewController * nextController = [signalTarget viewController];
			if ( nextController )
			{
				signalTarget = nextController;
			}
		}
	}
	
	NSString *	preSelector = nil;
	NSString *	nameSpace = nil;
	NSString *	tagString = nil;
	
	NSString *	cacheName = nil;
	SEL			selector = nil;
	NSString *	selectorName = nil;

	if ( signal.source )
	{
		UIView * sourceView = nil;
		
		if ( [signal.source isKindOfClass:[UIView class]] )
		{
			sourceView = signal.source;
		}
		else if ( [signal.source isKindOfClass:[UIViewController class]] )
		{
			sourceView = ((UIViewController *)signal.source).view;
		}
		
		if ( sourceView )
		{
			nameSpace = sourceView.nameSpace;	// .lowercaseString;
			tagString = sourceView.tagString;	// .lowercaseString;

			if ( nil == nameSpace )
			{
				nameSpace = [[sourceView class] description];
			}
		}
	}
	
	if ( nameSpace|| tagString )
	{
		if ( nameSpace && tagString )
		{
			preSelector = [NSString stringWithFormat:@"%@_%@", nameSpace, tagString];
		}
		else if ( nameSpace )
		{
			preSelector = nameSpace;
		}
		else if ( tagString )
		{
			preSelector = tagString;
		}
		
		preSelector = [preSelector stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
		preSelector = [preSelector stringByReplacingOccurrencesOfString:@":" withString:@"_"];
	}

	NSMutableArray * classArray = [NSMutableArray nonRetainingArray];

#if __BEE_AUTO_SIGNAL_ROUTING__
	
	Class signalTargetClass = [signalTarget class];
	for ( ;; )
	{
		[classArray insertObject:signalTargetClass atIndex:0];
		
		signalTargetClass = class_getSuperclass( signalTargetClass );
		if ( nil == signalTargetClass || signalTargetClass == [UIResponder class] )
			break;
	}
		
#else	// #if __BEE_AUTO_SIGNAL_ROUTING__
	
	[classArray addObject:[signalTarget class]];
	
#endif	// #if __BEE_AUTO_SIGNAL_ROUTING__
		
	for ( Class signalTargetClass in classArray )
	{
		if ( preSelector )
		{
			cacheName = [NSString stringWithFormat:@"%@/%@/%@", signalName, [signalTargetClass description], preSelector];
		}
		else
		{
			cacheName = [NSString stringWithFormat:@"%@/%@", signalName, [signalTargetClass description]];
		}
	
		BOOL handled = NO;
		do
		{
			selectorName = [_selectorCache objectForKey:cacheName];
			if ( selectorName )
			{
				selector = NSSelectorFromString( selectorName );
				handled = [self performSignal:signal target:signalTarget selector:selector class:signalTargetClass];
				if ( handled )
				{
					break;
				}
			}

			if ( preSelector )
			{
				selectorName = [NSString stringWithFormat:@"handleUISignal_%@:", preSelector];
				selector = NSSelectorFromString( selectorName );
				
				handled = [self performSignal:signal target:signalTarget selector:selector class:signalTargetClass];
				if ( handled )
				{
					[_selectorCache setObject:selectorName forKey:cacheName];
					break;
				}
			}
			
			NSArray * array = [signalName componentsSeparatedByString:@"."];
			if ( array && array.count > 1 )
			{
		//		NSString * prefix = (NSString *)[array objectAtIndex:0];
				NSString * clazz = (NSString *)[array objectAtIndex:1];
				NSString * method = (NSString *)[array objectAtIndex:2];
				
				selectorName = [NSString stringWithFormat:@"handleUISignal_%@_%@:", clazz, method];
				selector = NSSelectorFromString( selectorName );

				handled = [self performSignal:signal target:signalTarget selector:selector class:signalTargetClass];
				if ( handled )
				{
					[_selectorCache setObject:selectorName forKey:cacheName];
					break;
				}

				selectorName = [NSString stringWithFormat:@"handleUISignal_%@:", clazz];
				selector = NSSelectorFromString( selectorName );
				
				handled = [self performSignal:signal target:signalTarget selector:selector class:signalTargetClass];
				if ( handled )
				{
					[_selectorCache setObject:selectorName forKey:cacheName];
					break;
				}
				
				selectorName = [NSString stringWithFormat:@"handle%@:", clazz];
				selector = NSSelectorFromString( selectorName );
				
				handled = [self performSignal:signal target:signalTarget selector:selector class:signalTargetClass];
				if ( handled )
				{
					[_selectorCache setObject:selectorName forKey:cacheName];
					break;
				}
			}
			
			selectorName = [NSString stringWithFormat:@"handleUISignal_%@:", signalName];
			selectorName = [selectorName stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
			selectorName = [selectorName stringByReplacingOccurrencesOfString:@"." withString:@"_"];
			selectorName = [selectorName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
			selector = NSSelectorFromString( selectorName );
			
			handled = [self performSignal:signal target:signalTarget selector:selector class:signalTargetClass];
			if ( handled )
			{
				[_selectorCache setObject:selectorName forKey:cacheName];
				break;
			}

			if ( [signalSource isKindOfClass:[UIViewController class]] )
			{
				selectorName = [NSString stringWithFormat:@"handleUISignal_%@:", [[signalSource class] description]];
				selector = NSSelectorFromString( selectorName );
				
				handled = [self performSignal:signal target:signalTarget selector:selector class:signalTargetClass];
				if ( handled )
				{
					[_selectorCache setObject:selectorName forKey:cacheName];
					break;
				}
			}

			if ( [signalSource isKindOfClass:[UIView class]] )
			{
				NSString * tagString = [(UIView *)signalSource tagString];
				if ( tagString && tagString.length )
				{
					selectorName = [NSString stringWithFormat:@"handleUISignal_%@_%@:", [[signalSource class] description], tagString];
					selector = NSSelectorFromString( selectorName );
				}
				else
				{
					selectorName = [NSString stringWithFormat:@"handleUISignal_%@:", [[signalSource class] description]];
					selector = NSSelectorFromString( selectorName );
				}
				
				handled = [self performSignal:signal target:signalTarget selector:selector class:signalTargetClass];
				if ( handled )
				{
					[_selectorCache setObject:selectorName forKey:cacheName];
					break;
				}
			}

			for ( Class rtti = [signalSource class]; nil != rtti && rtti != [UIResponder class]; rtti = class_getSuperclass(rtti) )
			{
				selectorName = [NSString stringWithFormat:@"handle%@:", [rtti description]];
				selector = NSSelectorFromString( selectorName );
				
				handled = [self performSignal:signal target:signalTarget selector:selector class:signalTargetClass];
				if ( handled )
				{
					[_selectorCache setObject:selectorName forKey:cacheName];
					break;
				}
			}
			
			if ( handled )
			{
				break;
			}

			selectorName = @"handleUISignal:";
			selector = NSSelectorFromString( selectorName );
			
			handled = [self performSignal:signal target:signalTarget selector:selector class:signalTargetClass];
			if ( handled )
			{
				[_selectorCache setObject:selectorName forKey:cacheName];
				break;
			}
		}
		while ( 0 );
	}
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
