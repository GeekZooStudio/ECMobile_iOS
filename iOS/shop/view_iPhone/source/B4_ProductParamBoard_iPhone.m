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

#import "AppBoard_iPhone.h"
#import "B4_ProductParamBoard_iPhone.h"
#import "B4_ProductParamCell_iPhone.h"
#import "CommonNoResultCell.h"

#pragma mark - B4_ProductParamBoard_iPhone

@implementation B4_ProductParamBoard_iPhone

ON_CREATE_VIEWS( signal )
{
    self.navigationBarShown = YES;
    self.navigationBarTitle = __TEXT(@"gooddetail_parameter");
    self.navigationBarLeft  = [UIImage imageNamed:@"nav_back.png"];
    
    @weakify(self);
    
    self.list.whenReloading = ^{
        
        @normalize(self);
        
        NSArray * datas = self.goods.properties;
        
        self.list.total += datas.count;
        
		if ( datas.count == 0 )
		{
			self.list.total = 1;
			
			BeeUIScrollItem * item = self.list.items[0];
            item.clazz = [CommonNoResultCell class];
            item.size = self.list.size;
            item.rule = BeeUIScrollLayoutRule_Tile;
		}
		else
		{
			for ( int i=0; i < datas.count; i++ )
			{
				BeeUIScrollItem * item = self.list.items[i];
				item.clazz = [B4_ProductParamCell_iPhone class];
				item.data  = [datas safeObjectAtIndex:i];
				item.rule  = BeeUIScrollLayoutRule_Line;
				item.size  = CGSizeAuto;
			}
		}
    };
}

ON_WILL_APPEAR( signal )
{

	[self.list reloadData];
	
    [bee.ui.appBoard hideLogin];
}

#pragma mark -

ON_LEFT_BUTTON_TOUCHED( signal )
{
    [self.stack popBoardAnimated:YES];
}

ON_RIGHT_BUTTON_TOUCHED( signal )
{
}

@end
