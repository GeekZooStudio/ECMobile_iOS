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

#import "AppBoard_iPhone.h"

#import "CommonNoResultCell.h"
#import "CommonPullLoader.h"
#import "CommonFootLoader.h"

#import "ECMobileManager.h"
#import "ECMobileProtocol.h"

#import "H0_BrowserBoard_iPhone.h"

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
    self.navigationBarTitle = __TEXT(@"profile_message");
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

        self.list.total = [ECMobilePushList sharedInstance].messages.count;
        
        if ( 0 == [ECMobilePushList sharedInstance].messages.count )
        {
            self.list.total = 1;
            
            BeeUIScrollItem * item = self.list.items[0];
            item.clazz = [CommonNoResultCell class];
            item.size = self.list.size;
            item.rule = BeeUIScrollLayoutRule_Tile;
        }
        else
        {
            for ( int i = 0; i < [ECMobilePushList sharedInstance].messages.count; i++ )
            {
                BeeUIScrollItem * item = self.list.items[i];
                item.clazz = [G2_MessageCell_iPhone class];
                item.size = CGSizeAuto;
                item.data = [[ECMobilePushList sharedInstance].messages safeObjectAtIndex:i];
                item.rule = BeeUIScrollLayoutRule_Tile;
            }
        }
    };
    self.list.whenHeaderRefresh = ^
    {
        [[ECMobilePushList sharedInstance] firstPage];
		[[ECMobilePushUnread sharedInstance] update];
    };
    self.list.whenFooterRefresh = ^
    {
        [[ECMobilePushList sharedInstance] nextPage];
    };
    self.list.whenReachBottom = ^
    {
        [[ECMobilePushList sharedInstance] nextPage];
    };

    [self observeNotification:ECMobilePushUnread.UPDATING];
    [self observeNotification:ECMobilePushUnread.UPDATED];
    [self observeNotification:ECMobilePushList.UPDATING];
    [self observeNotification:ECMobilePushList.UPDATED];
}

ON_DELETE_VIEWS( signal )
{
    [self unobserveNotification:ECMobilePushUnread.UPDATING];
    [self unobserveNotification:ECMobilePushUnread.UPDATED];
    [self unobserveNotification:ECMobilePushList.UPDATING];
    [self unobserveNotification:ECMobilePushList.UPDATED];
    
    self.list = nil;
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
//    [self.list reloadData];
    
    [bee.ui.appBoard hideTabbar];
    
    [[ECMobilePushUnread sharedInstance] update];
    [[ECMobilePushList sharedInstance] firstPage];

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
	ECM_MESSAGE * message = signal.sourceCell.data;
	if ( message )
	{
		NSDictionary * dict = [message.custom_data objectFromJSONString];
		if ( dict && [dict isKindOfClass:[NSDictionary class]] )
		{
			NSString * action = [dict objectForKey:@"a"];
			if ( action )
			{
				if ( [action isEqualToString:@"s"] )
				{
					NSString * keyword = [dict objectForKey:@"k"];
					
					B1_ProductListBoard_iPhone * board = [B1_ProductListBoard_iPhone board];
					board.searchByHotModel.filter.keywords = keyword;
					board.searchByCheapestModel.filter.keywords = keyword;
					board.searchByExpensiveModel.filter.keywords = keyword;
					[self.stack pushBoard:board animated:YES];
					return;
				}
				else if ( [action isEqualToString:@"w"] )
				{
					NSString * url = [dict objectForKey:@"u"];
					
					H0_BrowserBoard_iPhone * board = [H0_BrowserBoard_iPhone board];
					board.defaultTitle = @"";
					board.useHTMLTitle = YES;
                    board.urlString = [url URLDecoding];
					[self.stack pushBoard:board animated:YES];
					return;
				}
			}
		}
	}
}

#pragma mark -

ON_NOTIFICATION3( ECMobilePushList, UPDATING, notification )
{
	if ( 0 == [ECMobilePushList sharedInstance].messages.count )
	{
		[self presentLoadingTips:__TEXT(@"tips_loading")];
	}

	[self.list setFooterLoading:([ECMobilePushList sharedInstance].messages.count ? YES : NO)];
}

ON_NOTIFICATION3( ECMobilePushList, UPDATED, notification )
{
	[self dismissTips];
	
	[self.list setHeaderLoading:NO];
	[self.list setFooterLoading:NO];
	[self.list setFooterShown:[ECMobilePushList sharedInstance].more];
	[self.list setFooterMore:[ECMobilePushList sharedInstance].more];
	
	[self.list asyncReloadData];
}

@end
