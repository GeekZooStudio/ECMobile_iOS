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

#import "model.h"
#import "C1_CheckOutCell_iPhone.h"
#import "C1_CheckoutOrderCell_iPhone.h"

#pragma mark -

@implementation C1_CheckOutCell_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

- (void)dataDidChanged
{
    if ( self.data )
    {
        FlowModel * flowModel = self.data;
        
        if ( !flowModel.goods_list.count )
            return;
        
        self.order_cell.data = flowModel;
        
        self.consignee_cell.data = flowModel.consignee;
        self.balance_pay_subtitle.data = flowModel.done_payment.pay_name;
        self.balance_bill_subtitle.data = flowModel.done_inv_payee;
        self.balance_shipping_subtitle.data = flowModel.done_shipping.shipping_name;
        
        self.balance_exp_subtitle.data = flowModel.done_integral;
        self.balance_redpocket_subtitle.data = flowModel.done_bonus;
        
        BOOL integralAllow = flowModel.allow_use_integral.boolValue && 
                             MIN( flowModel.your_integral.integerValue,
                             flowModel.order_max_integral.integerValue );
        
        if ( integralAllow )
        {
            if ( flowModel.done_integral )
            {
                self.balance_exp_subtitle.data = 
                    [NSString stringWithFormat:__TEXT(@"use_exp"),
                    flowModel.self.done_integral];
            }
            self.balance_exp.enabled = YES;
            self.balance_exp_title.textColor = [UIColor blackColor];
        }
        else
        {
            self.balance_exp_title.textColor = [UIColor lightGrayColor];
            self.balance_exp.enabled = NO;
        }
        
        BOOL bonusAllow = flowModel.allow_use_bonus.boolValue && flowModel.bonus.count;
        if ( bonusAllow )
        {
            if ( flowModel.done_bonus )
            {
                self.balance_redpocket_subtitle.data = [NSString stringWithFormat:@"%@", 
                    flowModel.data_bonus.bonus_money_formated];
            }
            self.balance_redpocket_title.textColor = [UIColor blackColor];
            self.balance_redpocket.enabled = YES;
        }
        else
        {
            self.balance_redpocket_title.textColor = [UIColor lightGrayColor];
            self.balance_redpocket.enabled = NO;
        }
    }
}

@end
