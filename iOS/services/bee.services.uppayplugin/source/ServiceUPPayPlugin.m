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

#import "ServiceUPPayPlugin.h"
#import "AppBoard_iPhone.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

static NSString * const kUPPayModeDistrbution = @"00"; // 正式环境
static NSString * const kUPPayModeDevelopment = @"01"; // 测试环境

#pragma mark -

@implementation ServiceUPPayPlugin

SERVICE_AUTO_LOADING( YES );
SERVICE_AUTO_POWERON( YES );

- (void)load
{
}

- (void)unload
{
}

- (BeeServiceBlock)PAY
{
	BeeServiceBlock block = ^ void ( void )
	{
		BeeUIStack * mainStack = [BeeUIRouter sharedInstance].currentStack;
		BeeUIBoard * board = mainStack.topBoard;

		[UPPayPlugin startPay:self.payData
                         mode:kUPPayModeDistrbution
               viewController:board
                     delegate:self];
	};

	return [[block copy] autorelease];
}

- (void)UPPayPluginResult:(NSString *)result
{
	if ( [result isEqualToString:@"success"] )
	{
		//支付成功
		self.whenSucceed();
	}
	else if ( [result isEqualToString:@"fail"] )
	{
		//支付失败
		self.whenFailed();
	}
	else if( [result isEqualToString:@"cancel"] )
	{
		//取消操作
		self.whenCancel();
	}
}

@end

#endif  // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
