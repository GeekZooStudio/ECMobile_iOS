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

#import "CommonPullLoader.h"

#pragma mark -

@implementation CommonPullLoader

+ (void)load
{
	[BeeUIPullLoader setDefaultSize:CGSizeMake(200, 50)];
	[BeeUIPullLoader setDefaultClass:[CommonPullLoader class]];
}

- (void)load
{
	[super load];

	self.FROM_RESOURCE( @"CommonPullLoader.xml" );
	
    $(@"#bg").HIDE();
	$(@"#ind").HIDE();
    $(@"#logo").HIDE();
	$(@"#state").DATA( __TEXT(@"tips_pull_refresh") );
	$(@"#date").DATA( [NSString stringWithFormat:@"%@%@", __TEXT(@"tips_last_update"), [[NSDate date] stringWithDateFormat:__TEXT(@"date_format")]] );
}

- (void)unload
{
	[super unload];
}

- (void)handleUISignal:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
	
	BeeUIImageView *				arrow = (BeeUIImageView *)$(@"#arrow").view;
	BeeUIActivityIndicatorView *	indicator = (BeeUIActivityIndicatorView *)$(@"#ind").view;
	
	if ( [signal is:BeeUIPullLoader.STATE_CHANGED] )
	{
		if ( self.animated )
		{
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationDuration:0.2f];
			[UIView setAnimationBeginsFromCurrentState:YES];
		}
		
		if ( self.pulling )
		{
			arrow.hidden = NO;
			arrow.transform = CGAffineTransformRotate( CGAffineTransformIdentity, (M_PI / 360.0f) * -359.0f );

			$(@"#state").DATA( __TEXT(@"tips_release_refresh") );
			$(@"#date").DATA( [NSString stringWithFormat:@"%@%@", __TEXT(@"tips_last_update"), [[NSDate date] stringWithDateFormat:__TEXT(@"date_format")]] );
		}
		else if ( self.loading )
		{
			[indicator startAnimating];
			
			arrow.hidden = YES;

			$(@"#state").DATA( __TEXT(@"tips_loading") );
			$(@"#date").DATA( [NSString stringWithFormat:@"%@%@", __TEXT(@"tips_last_update"), [[NSDate date] stringWithDateFormat:__TEXT(@"date_format")]] );
		}
		else
		{
			arrow.hidden = NO;
			arrow.transform = CGAffineTransformIdentity;
			
			[indicator stopAnimating];
			
			$(@"#state").DATA( __TEXT(@"tips_pull_refresh") );
			$(@"#date").DATA( [NSString stringWithFormat:@"%@%@", __TEXT(@"tips_last_update"), [[NSDate date] stringWithDateFormat:__TEXT(@"date_format")]] );
		}
		
		if ( self.animated )
		{
			[UIView commitAnimations];
		}
	}
}

@end
