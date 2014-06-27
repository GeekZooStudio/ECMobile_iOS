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
	
#import "E6_ShippingStatusBoard_iPhone.h"

#import "AppBoard_iPhone.h"

#import "CommonNoResultCell.h"
#import "E6_ShippingStatusBody_iPhone.h"
#import "E6_ShippingStatusHeader_iPhone.h"
#import "E6_ShippingStatusInfo_iPhone.h"
#import "E6_ShippingStatusFooter_iPhone.h"

#pragma mark -

@implementation E6_ShippingStatusBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( BeeUIScrollView, list )

DEF_MODEL( ExpressModel, expressModel )

- (void)load
{
	self.expressModel = [ExpressModel modelWithObserver:self];
}

- (void)unload
{
	SAFE_RELEASE_MODEL( self.expressModel );
}

#pragma mark -

ON_CREATE_VIEWS( signal )
{
    self.navigationBarTitle = __TEXT(@"express_logistics");
    
    [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav_back.png"]];
    
    @weakify(self);
    
    self.list.lineCount = 1;
    self.list.animationDuration = 0.25f;
    
    self.list.whenReloading = ^
    {
        @normalize(self);
        
        self.list.total = 1 + self.expressModel.content.count;
        
        if ( self.expressModel.loaded && self.expressModel.content.count == 0)
        {
            BeeUIScrollItem * item = self.list.items[0];
            item.clazz = [CommonNoResultCell class];
            item.size = self.list.size;
            item.rule = BeeUIScrollLayoutRule_Tile;
        }
        else
        {
            if ( self.expressModel.content.count )
            {
                int offset = 0;
                
                BeeUIScrollItem * headerItem = self.list.items[0];
                headerItem.clazz = [E6_ShippingStatusHeader_iPhone class];
                headerItem.data = self.expressModel;
                headerItem.size = CGSizeMake( self.list.width, 83 );
                headerItem.rule = BeeUIScrollLayoutRule_Tile;
                
                offset += 1;
                
                for ( int i = 0; i < self.expressModel.content.count; i++ )
                {
                    BeeUIScrollItem * item = [self.list.items safeObjectAtIndex:( i + offset )];
                    item.data = [self.expressModel.content safeObjectAtIndex:i];
                    if ( i == 0 )
                    {
                        item.clazz = [E6_ShippingStatusInfo_iPhone class];
                        item.size = CGSizeMake( self.list.width, 107 );
                        item.rule = BeeUIScrollLayoutRule_Tile;
                    }
                    else if ( i == self.expressModel.content.count - 1 )
                    {
                        item.clazz = [E6_ShippingStatusFooter_iPhone class];
                        item.size = CGSizeMake( self.list.width, 104 );
                        item.rule = BeeUIScrollLayoutRule_Tile;
                    }
                    else
                    {
                        item.clazz = [E6_ShippingStatusBody_iPhone class];
                        item.size = CGSizeMake( self.list.width , 64 );
                        item.rule = BeeUIScrollLayoutRule_Tile;
                    }
                }
            }
        }
        
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
    if ( NO == self.expressModel.loaded )
    {
        [self.expressModel reload];
    }
    
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

#pragma mark -

ON_MESSAGE3( API, order_express, msg )
{
    if ( msg.sending )
    {
        [self presentLoadingTips:__TEXT(@"tips_loading")];
    }
    else
    {
        [self dismissTips];
    }
    
	if ( msg.succeed )
	{

		[self.list reloadData];
	}
	else if ( msg.failed )
	{
		[self showErrorTips:msg];
	}
}

@end
