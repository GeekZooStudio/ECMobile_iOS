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

#import "C2_PaymentCell_iPhone.h"
#import "C2_PaymentBoard_iPhone.h"
#import "C1_CheckOutBoard_iPhone.h"

@implementation C2_PaymentBoard_iPhone

SUPPORT_RESOURCE_LOADING( YES );
SUPPORT_AUTOMATIC_LAYOUT( YES );

DEF_OUTLET( BeeUIScrollView, list )

#pragma mark -

ON_CREATE_VIEWS(signal)
{
    self.navigationBarShown = YES;
    self.navigationBarTitle = __TEXT(@"balance_pay");
    self.navigationBarLeft  = [UIImage imageNamed:@"nav_back.png"];
    
    @weakify(self);
    
    self.pay_id = self.flowModel.done_payment.pay_id;
    
    self.list.whenReloading = ^{
        
        @normalize(self);
        
        NSArray * datas = self.flowModel.payment_list;
        
        self.list.total += datas.count;
        
        for ( int i=0; i < datas.count; i++ )
        {
            PAYMENT * payment = [datas safeObjectAtIndex:i];
            payment.scrollSelected = self.pay_id &&
                [payment.pay_id isEqualToNumber:self.pay_id];
            
            BeeUIScrollItem * item = self.list.items[i];
            item.clazz = [C2_PaymentCell_iPhone class];
            item.rule  = BeeUIScrollLayoutRule_Line;
            item.size  = CGSizeAuto;
            item.data  = payment;
        }
    };
}

ON_LEFT_BUTTON_TOUCHED( signal )
{
    [self.stack popBoardAnimated:YES];
}

ON_DID_APPEAR( signal )
{
	[self.list reloadData];
}

#pragma mark - FormPlainOptionCell

ON_SIGNAL3( FormPlainOptionCell, mask, signal )
{
    self.flowModel.done_payment = signal.sourceCell.data;
    [self.stack popBoardAnimated:YES];
}

@end
