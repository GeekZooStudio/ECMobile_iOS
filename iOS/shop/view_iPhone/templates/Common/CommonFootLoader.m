/*
 *                                                                          
 *       _/_/_/                      _/        _/_/_/_/_/                     
 *    _/          _/_/      _/_/    _/  _/          _/      _/_/      _/_/    
 *   _/  _/_/  _/_/_/_/  _/_/_/_/  _/_/          _/      _/    _/  _/    _/   
 *  _/    _/  _/        _/        _/  _/      _/        _/    _/  _/    _/    
 *   _/_/_/    _/_/_/    _/_/_/  _/    _/  _/_/_/_/_/    _/_/      _/_/       
 *                                                                          
 *
 *  Copyright 2013-2014, Geek Zoo Studio
 *  http://www.ecmobile.cn/license.html
 *
 *  HQ China:
 *    2319 Est.Tower Van Palace 
 *    No.2 Guandongdian South Street 
 *    Beijing , China
 *
 *  U.S. Office:
 *    One Park Place, Elmira College, NY, 14901, USA
 *
 *  QQ Group:   329673575
 *  BBS:        bbs.ecmobile.cn
 *  Fax:        +86-10-6561-5510
 *  Mail:       info@geek-zoo.com
 */

#import "CommonFootLoader.h"

#pragma mark -

@implementation CommonFootLoader

+ (void)load
{
	[CommonFootLoader setDefaultSize:CGSizeMake(200, 50)];
	[CommonFootLoader setDefaultClass:[CommonFootLoader class]];
}

- (void)load
{
	[super load];
	
	self.FROM_RESOURCE( @"CommonFootLoader.xml" );
	
    $(@"#bg").HIDE();
	$(@"#ind").HIDE();
	$(@"#state").DATA( __TEXT(@"tips_more") );
}

- (void)unload
{
	[super unload];
}

- (void)handleUISignal:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIFootLoader.STATE_CHANGED] )
	{
		if ( self.animated )
		{
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationDuration:0.2f];
			[UIView setAnimationBeginsFromCurrentState:YES];
		}

		if ( self.loading )
		{
			BeeUIActivityIndicatorView * indicator = (BeeUIActivityIndicatorView *)$(@"#ind").view;
			[indicator startAnimating];
			
			$(@"#state").DATA( __TEXT(@"tips_loading") );
		}
		else
		{
			BeeUIActivityIndicatorView * indicator = (BeeUIActivityIndicatorView *)$(@"#ind").view;
			[indicator stopAnimating];

			if ( self.more )
			{
				$(@"#state").DATA( __TEXT(@"tips_more") );
			}
			else
			{
				$(@"#state").DATA( __TEXT(@"tips_no_more") );
			}
		}
		
		if ( self.animated )
		{
			[UIView commitAnimations];
		}
	}
}

@end
