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
//  Powered by BeeFramework
//
	
#import "B6_ProductDescBoard_iPhone.h"

#pragma mark -

@implementation B6_ProductDescBoard_iPhone

SUPPORT_RESOURCE_LOADING( YES );
SUPPORT_AUTOMATIC_LAYOUT( YES );

DEF_MODEL( GoodsPageModel, goodsPageModel )

#pragma mark -

- (void)load
{
    self.isToolbarHiden = YES;
	self.goodsPageModel = [GoodsPageModel modelWithObserver:self];
}

- (void)unload
{
    SAFE_RELEASE_MODEL( self.goodsPageModel );
}

#pragma mark -

ON_CREATE_VIEWS( signal )
{
    [self showNavigationBarAnimated:YES];
    
    self.navigationBarTitle = __TEXT(@"gooddetail_description");
    self.webView.scalesPageToFit = YES;
    
    [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav_back.png"]];
}

ON_DELETE_VIEWS( signal )
{
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
    [self.goodsPageModel reload];
}

ON_DID_APPEAR( signal )
{
}

ON_WILL_DISAPPEAR( signal )
{
}

ON_DID_DISAPPEAR( signal )
{
}

#pragma mark - 

ON_LEFT_BUTTON_TOUCHED( signal )
{
}

ON_RIGHT_BUTTON_TOUCHED( signal )
{
}

#pragma mark -

ON_MESSAGE3( API, goods_desc, msg )
{
	if ( msg.succeed )
	{
		self.htmlString = self.goodsPageModel.html;
		
		[self refresh];
	}
	else if ( msg.failed )
	{
		[self showErrorTips:msg];
	}
}

@end
