//
//                       __
//                      /\ \   _
//    ____    ____   ___\ \ \_/ \           _____    ___     ___
//   / _  \  / __ \ / __ \ \    <     __   /\__  \  / __ \  / __ \
//  /\ \_\ \/\  __//\  __/\ \ \\ \   /\_\  \/_/  / /\ \_\ \/\ \_\ \
//  \ \____ \ \____\ \____\\ \_\\_\  \/_/   /\____\\ \____/\ \____/
//   \/____\ \/____/\/____/ \/_//_/         \/____/ \/___/  \/___/
//     /\____/
//     \/___/
//
//	Powered by BeeFramework
//

#import "AppTabbar_iPhone.h"
#import "model.h"

#pragma mark -

DEF_UI( AppTabbar_iPhone, tabbar )

#pragma mark -

@implementation AppTabbar_iPhone

DEF_SINGLETON( AppTabbar_iPhone )

SUPPORT_RESOURCE_LOADING( YES )

- (void)load
{
	[self observeNotification:UserModel.LOGIN];
	[self observeNotification:UserModel.LOGOUT];
	[self observeNotification:UserModel.KICKOUT];
	[self observeNotification:CartModel.UPDATED];

	$(@"#badge-bg").HIDE();
	$(@"#badge").HIDE();
	
	[self selectHome];
}

- (void)unload
{
	[self unobserveAllNotifications];
}

#pragma mark -

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

#pragma mark -

ON_NOTIFICATION3( UserModel, KICKOUT, notification )
{
	self.data = @(0);
}

ON_NOTIFICATION3( UserModel, LOGOUT, notification )
{
	self.data = @(0);
}

ON_NOTIFICATION3( UserModel, LOGIN, notification )
{
	NSUInteger count = 0;
	
	for ( CART_GOODS * goods in [CartModel sharedInstance].goods )
	{
		count += goods.goods_number.intValue;
	}
	
	self.data = @(count);
}

ON_NOTIFICATION3( CartModel, UPDATED, notification )
{
	NSUInteger count = 0;
	
	for ( CART_GOODS * goods in [CartModel sharedInstance].goods )
	{
		count += goods.goods_number.intValue;
	}
	
	self.data = @(count);
}

#pragma mark -

- (void)dataDidChanged
{
	NSNumber * count = self.data;

	if ( count && count.intValue > 0 )
	{
		$(@"#badge-bg").SHOW();
		$(@"#badge").SHOW().BIND_DATA( count );
	}
	else
	{
		$(@"#badge-bg").HIDE();
		$(@"#badge").HIDE();
	}
}

@end
