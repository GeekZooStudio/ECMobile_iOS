//
//   ______    ______    ______
//  /\  __ \  /\  ___\  /\  ___\
//  \ \  __<  \ \  __\_ \ \  __\_
//   \ \_____\ \ \_____\ \ \_____\
//    \/_____/  \/_____/  \/_____/
//
//
//  Copyright (c) 2014-2015, Geek Zoo Studio
//  http://www.bee-framework.com
//
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//

#import "ServiceShare_ActivityWindow.h"
#import "ServiceShare_ActivityBoard.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#pragma mark -

#undef	BOARD_HEIGHT
#define BOARD_HEIGHT	(140.0f)

#pragma mark -

@implementation ServiceShare_ActivityWindow
{
	BeeUIButton *	_mask;
}

DEF_SINGLETON( ServiceShare_ActivityWindow )

#pragma mark -

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if ( self )
	{
		self.backgroundColor = [UIColor clearColor];
		self.hidden = YES;
		self.windowLevel = UIWindowLevelNormal + 3.0f;
		
		if ( [BeeSystemInfo isPhoneRetina4] )
		{
			self.frame = CGRectMake(0, 0, 320, 568);
		}
		else
		{
			self.frame = CGRectMake(0, 0, 320, 480);
		}
	}
	return self;
}

- (void)dealloc
{
	self.rootViewController = nil;
	
	[super dealloc];
}

#pragma mark -

- (void)didOpen
{
}

- (void)didClose
{
	self.hidden = YES;
	self.rootViewController = nil;
}

- (void)open
{
    if ( NO == self.hidden )
        return;
	
	if ( nil == _mask )
	{
		_mask = [[BeeUIButton alloc] initWithFrame:[UIScreen mainScreen].bounds];
		_mask.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
		_mask.signal = @"mask";
		[self addSubview:_mask];
	}
	
	self.hidden = NO;
//	self.alpha = 0.0f;

	CGRect viewFrame;
	viewFrame.size.width = self.bounds.size.width;
	viewFrame.size.height = BOARD_HEIGHT;
	viewFrame.origin.x = 0.0f;
	viewFrame.origin.y = self.bounds.size.height;

	self.rootViewController = [ServiceShare_ActivityBoard board];
	self.rootViewController.view.frame = viewFrame;
	
	self.rootViewController.view.layer.shadowOpacity = 0.25f;
	self.rootViewController.view.layer.shadowRadius = 1.5f;
	self.rootViewController.view.layer.shadowOffset = CGSizeMake(0.0f, -2.0f);
	self.rootViewController.view.layer.shadowColor = [UIColor blackColor].CGColor;
	self.rootViewController.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
	
//	[BeeUIApplication sharedInstance].window.alpha = 1.0f;
//	[BeeUIApplication sharedInstance].window.layer.transform = CATransform3DIdentity;
	
	_mask.alpha = 0.0f;

	[UIView beginAnimations:@"openWindow" context:nil];
	[UIView setAnimationDuration:0.25f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDidStopSelector:@selector(didOpen)];

//	self.alpha = 1.0f;
	self.rootViewController.view.frame = CGRectOffset( viewFrame, 0.0f, -viewFrame.size.height );
    
//	CATransform3D transform;
//	transform = CATransform3DIdentity;
//	transform.m34 = -(1.0f / 2500.0f);
//	transform = CATransform3DTranslate( transform, 0, 0, -200.0f );
	
//	[BeeUIApplication sharedInstance].window.alpha = 0.9f;
//	[BeeUIApplication sharedInstance].window.layer.transform = transform;
	
	_mask.alpha = 1.0f;
	
	[UIView commitAnimations];
}

- (void)close
{
	[self closeAnimated:YES];
}

- (void)closeAnimated:(BOOL)animated
{
    if ( self.hidden )
        return;
    
    [self endEditing:YES];

	[UIView beginAnimations:@"closeWindow" context:nil];
	[UIView setAnimationDuration:0.25f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDidStopSelector:@selector(didClose)];

//	self.alpha = 0.0f;
	self.layer.transform = CATransform3DIdentity;

	CGRect viewFrame;
	viewFrame.size.width = self.bounds.size.width;
	viewFrame.size.height = BOARD_HEIGHT;
	viewFrame.origin.x = 0.0f;
	viewFrame.origin.y = self.bounds.size.height;

	self.rootViewController.view.frame = viewFrame;
	
//	[BeeUIApplication sharedInstance].window.alpha = 1.0f;
//	[BeeUIApplication sharedInstance].window.layer.transform = CATransform3DIdentity;
	
	_mask.alpha = 0.0f;

	[UIView commitAnimations];
}

ON_SIGNAL2( mask, signal )
{
	[self closeAnimated:YES];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
