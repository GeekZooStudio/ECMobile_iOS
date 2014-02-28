//
//  ErrorMsg.m
//  shop
//
//  Created by QFish on 6/28/13.
//  Copyright (c) 2013 geek-zoo studio. All rights reserved.
//

#import "UIViewController+ErrorTips.h"

@implementation UIViewController(ErrorTips)

- (void)showErrorTips:(BeeMessage *)msg
{
    STATUS * status = msg.GET_OUTPUT( @"status" );
	if ( status )
	{
		NSString * errorDesc = status.error_desc;
		if ( errorDesc )
		{
			[self presentFailureTips:errorDesc];
			return;
		}
	}
	
	NSString * errorDesc2 = msg.errorDesc;
    if ( errorDesc2 )
    {
        [self presentFailureTips:errorDesc2];
		return;
    }

	if ( status.error_code )
	{
		NSString * multiLang = [NSString stringWithFormat:@"error_%@", status.error_code];
		NSString * errorDesc3 = __TEXT( multiLang );
		if ( errorDesc3 )
		{
			[self presentFailureTips:errorDesc3];
			return;
		}
	}

	[self presentFailureTips:__TEXT(@"error_network")];
}

@end
