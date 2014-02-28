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

#import "G2_MessageBoard_iPhone.h"
#import "G2_MessageCell_iPhone.h"
#import "B1_ProductListBoard_iPhone.h"
#import "H0_BrowserBoard_iPhone.h"

#import "AppBoard_iPhone.h"

#import "CommonNoResultCell.h"
#import "CommonPullLoader.h"
#import "CommonFootLoader.h"

#pragma mark -

@implementation G2_MessageBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( BeeUIScrollView, list )

- (void)load
{
}

- (void)unload
{
}

ON_CREATE_VIEWS( signal )
{
    self.titleString = __TEXT(@"profile_message");
    [self showNavigationBarAnimated:NO];
    [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav_back.png"]];

    @weakify(self);

    self.list.headerClass = [CommonPullLoader class];
    self.list.headerShown = YES;
    
    self.list.footerClass = [CommonFootLoader class];
    self.list.footerShown = YES;
    
    self.list.lineCount = 1;
    self.list.animationDuration = 0.25f;
    
    self.list.whenReloading = ^
    {
        @normalize(self);

        self.list.total = 0;
        
		for ( int i = 0; i < self.list.total; i++ )
		{
			BeeUIScrollItem * item = self.list.items[i];
			item.clazz = [G2_MessageCell_iPhone class];
			item.size = CGSizeAuto;
			item.data = nil;
			item.rule = BeeUIScrollLayoutRule_Tile;
		}
    };
    self.list.whenHeaderRefresh = ^
    {
		// TODO:
    };
    self.list.whenFooterRefresh = ^
    {
		// TODO:
    };
    self.list.whenReachBottom = ^
    {
		// TODO:
    };
}

ON_DELETE_VIEWS( signal )
{
    self.list = nil;
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
//    [self.list reloadData];
    
    [bee.ui.appBoard hideTabbar];
	
	[self.list reloadData];
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
    [self.stack popBoardAnimated:YES];
}

ON_RIGHT_BUTTON_TOUCHED( signal )
{
}

#pragma mark - G2_MessageCell_iPhone

ON_SIGNAL3( G2_MessageCell_iPhone, mask, signal )
{
	// TODO:
}

@end
