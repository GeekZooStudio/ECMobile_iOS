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

#import "C1_CheckOutBoard_iPhone.h"
#import "C3_DistributionCell_iPhone.h"
#import "C3_DistributionBoard_iPhone.h"

@implementation C3_DistributionBoard_iPhone

SUPPORT_RESOURCE_LOADING( YES );
SUPPORT_AUTOMATIC_LAYOUT( YES );

DEF_OUTLET( BeeUIScrollView, list )

#pragma mark -

ON_CREATE_VIEWS(signal)
{
    self.navigationBarShown = YES;
    self.navigationBarTitle = __TEXT(@"balance_shipping");
    self.navigationBarLeft  = [UIImage imageNamed:@"nav_back.png"];
    
    self.shipping_id = self.flowModel.done_shipping.shipping_id;
    
    @weakify(self);
    
    self.list.whenReloading = ^{
        
        @normalize(self);
        
        NSArray * datas = self.flowModel.shipping_list;
        
        self.list.total += datas.count;
        
        for ( int i=0; i < datas.count; i++ )
        {
            SHIPPING * shipping = [datas safeObjectAtIndex:i];
            shipping.scrollSelected = self.shipping_id &&
                [shipping.shipping_id isEqualToNumber:self.shipping_id];
            
            BeeUIScrollItem * item = self.list.items[i];
            item.clazz = [C3_DistributionCell_iPhone class];
            item.rule  = BeeUIScrollLayoutRule_Line;
            item.size  = CGSizeAuto;
            item.data  = shipping;
        }
    };
}

ON_LEFT_BUTTON_TOUCHED(signal)
{
    [self.stack popBoardAnimated:YES];
}

ON_DID_APPEAR( signal )
{
	[self.list reloadData];
}

#pragma mark - FormOptionCell2

ON_SIGNAL3( FormOptionCell2, mask, signal )
{
    self.flowModel.done_shipping = signal.sourceCell.data;
    [self.stack popBoardAnimated:YES];
}

@end
