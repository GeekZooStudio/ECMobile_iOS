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

#import "AppTab_iPhone.h"

#pragma mark -

@implementation AppTab_iPhone

SUPPORT_RESOURCE_LOADING( YES )
 
- (void)load
{
	[super load];
	
	$(@"#badge-bg").HIDE();
	$(@"#badge").HIDE();
}

- (void)unload
{
	[super unload];
}

- (void)deselectAll
{
	$(@"#home-bg").HIDE();
	$(@"#cart-bg").HIDE();
	$(@"#user-bg").HIDE();
	$(@"#search-bg").HIDE();

	$(@"#home-button").UNSELECT();
	$(@"#cart-button").UNSELECT();
	$(@"#user-button").UNSELECT();
	$(@"#search-button").UNSELECT();
}

- (void)selectHome
{
	[self deselectAll];

	$(@"#home-bg").SHOW();
	$(@"#home-button").SELECT();

    self.RELAYOUT();
}

- (void)selectSearch
{
	[self deselectAll];

    $(@"#search-bg").SHOW();
	$(@"#search-button").SELECT();

    self.RELAYOUT();
}

- (void)selectCart
{
	[self deselectAll];
	
	$(@"#cart-bg").SHOW();
	$(@"#cart-button").SELECT();

    self.RELAYOUT();
}

- (void)selectUser
{
	[self deselectAll];

	$(@"#user-bg").SHOW();
	$(@"#user-button").SELECT();
	
    self.RELAYOUT();
}

- (void)dataDidChanged
{
	NSNumber * count = self.data;

	if ( count && count.intValue > 0 )
	{
		$(@"#badge-bg").SHOW();
		$(@"#badge").SHOW().DATA( count );
	}
	else
	{
		$(@"#badge-bg").HIDE();
		$(@"#badge").HIDE();
	}
}

@end
