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

#import "Bee.h"
#import "BaseBoard_iPhone.h"
#import "F3_RegionPickBoard_iPhone.h"
#import "AppBoard_iPhone.h"

#import "F3_RegionPickCell_iPhone.h"

@implementation F3_RegionPickBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_MODEL( RegionModel, regionModel )

- (void)load
{
    self.regionModel = [[[RegionModel alloc] init] autorelease];
    [self.regionModel addObserver:self];
}

- (void)unload
{
    [self.regionModel removeObserver:self];
    self.regionModel = nil;
    
    self.whenRegionChanged = nil;
}

ON_CREATE_VIEWS(signal)
{
    self.navigationBarShown =YES;
    self.navigationBarTitle = __TEXT(@"select_address");
    self.navigationBarLeft  = [UIImage imageNamed:@"nav_back.png"];

    @weakify(self);
    
    self.list.whenReloading = ^{
        
        @normalize(self);
        
        NSArray * datas = self.regions;
        
        self.list.total += datas.count;
        
        for ( int i=0; i < datas.count; i++ )
        {
            BeeUIScrollItem * item = self.list.items[i];
            item.clazz = [F3_RegionPickCell_iPhone class];
            item.rule  = BeeUIScrollLayoutRule_Line;
            item.size  = CGSizeAuto;
            item.data  = [datas safeObjectAtIndex:i];;
        }
    };
    
    if ( !self.address )
    {
        self.address = [[[ADDRESS alloc] init] autorelease];
    }
    
    // in case of action before next pushing
    self.leftBarButton.userInteractionEnabled = NO;
    self.list.userInteractionEnabled = NO;
}

ON_DID_APPEAR(signal)
{
    self.leftBarButton.userInteractionEnabled = YES;
    self.list.userInteractionEnabled = YES;

    [self.list reloadData];
}

ON_LEFT_BUTTON_TOUCHED(signal)
{
    [self.stack popBoardAnimated:YES];
}

#pragma mark -

ON_SIGNAL3( FormPlainOptionCell, mask, signal )
{
    REGION * region = signal.sourceCell.data;
    
    if ( region )
    {
        [self.address setRegion:region level:self.level];
        self.regionModel.parent_id = region.id;
        [self.regionModel reload];
    }
}

#pragma mark -

ON_MESSAGE3( API, region, msg )
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
		STATUS * status = msg.GET_OUTPUT( @"status" );
		
		if ( status.succeed.boolValue )
		{
			if ( self.regionModel.regions.count )
			{
				F3_RegionPickBoard_iPhone * board = [[[F3_RegionPickBoard_iPhone alloc] init] autorelease];
				board.level = self.level + 1;
				board.address = self.address;
				board.regions = self.regionModel.regions;
				board.rootBoard = self.rootBoard;
				board.whenRegionChanged = self.whenRegionChanged;

				[self.stack pushBoard:board animated:YES];
			}
			else 
			{
				if ( self.whenRegionChanged )
				{
					self.whenRegionChanged( self.address );
				}

				[self.stack popToBoard:self.rootBoard animated:YES];
			}
		}
		else
		{
			[self showErrorTips:msg];
		}
	}
    else if ( msg.failed )
    {
        [self showErrorTips:msg];
    }
}

@end
