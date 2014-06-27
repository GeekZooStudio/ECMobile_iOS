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

#import "ServiceShare_ActivityBoard.h"
#import "ServiceShare_ActivityWindow.h"
#import "ServiceShare_Post.h"

#import "bee.services.share.h"
#import "bee.services.share.weixin.h"
#import "bee.services.share.sinaweibo.h"
#import "bee.services.share.tencentweibo.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#pragma mark -

@implementation ServiceShare_ActivityBoard

DEF_OUTLET( BeeUIButton, weixin_friend );
DEF_OUTLET( BeeUIButton, weixin_timeline );
DEF_OUTLET( BeeUIButton, sina_weibo );
DEF_OUTLET( BeeUIButton, tencent_weibo );

#pragma mark -

- (void)load
{
}

- (void)unload
{
}

#pragma mark -

ON_CREATE_VIEWS( signal )
{
}

ON_DELETE_VIEWS( signal )
{
}

#pragma mark -

ON_SIGNAL2( weixin_friend, signal )
{
	ALIAS( bee.services.share.weixin, weixin );
	
	[weixin.post copyFrom:[ServiceShare sharedInstance].post];
	weixin.SHARE_TO_FRIEND();

	[[ServiceShare_ActivityWindow sharedInstance] closeAnimated:NO];
}

ON_SIGNAL2( weixin_timeline, signal )
{
	ALIAS( bee.services.share.weixin, weixin );

	[weixin.post copyFrom:[ServiceShare sharedInstance].post];

	if ( nil == weixin.post.title && weixin.post.text )
	{
		weixin.post.title = weixin.post.text;
		weixin.post.text = nil;
	}
	
	weixin.SHARE_TO_TIMELINE();

	[[ServiceShare_ActivityWindow sharedInstance] closeAnimated:NO];
}

ON_SIGNAL2( sina_weibo, signal )
{
	ALIAS( bee.services.share.sinaweibo, sinaweibo );

	[sinaweibo.post copyFrom:[ServiceShare sharedInstance].post];
	sinaweibo.SHARE();
	
	[[ServiceShare_ActivityWindow sharedInstance] closeAnimated:NO];
}

ON_SIGNAL2( tencent_weibo, signal )
{
	ALIAS( bee.services.share.tencentweibo, tencentweibo );
	
	[tencentweibo.post copyFrom:[ServiceShare sharedInstance].post];
	tencentweibo.SHARE();

	[[ServiceShare_ActivityWindow sharedInstance] closeAnimated:NO];
}

ON_SIGNAL2( cancel, signal )
{
	[[ServiceShare_ActivityWindow sharedInstance] closeAnimated:YES];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
