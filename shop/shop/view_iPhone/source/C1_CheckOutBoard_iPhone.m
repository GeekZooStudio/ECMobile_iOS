
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
	
#import "C1_CheckOutBoard_iPhone.h"
#import "C1_CheckOutCell_iPhone.h"
#import "AppBoard_iPhone.h"
#import "OrderCell_iPhone.h"
#import "C4_InvoiceBoard_iPhone.h"
#import "C2_PaymentBoard_iPhone.h"
#import "C3_DistributionBoard_iPhone.h"
#import "C6_RedEnvelopeBoard_iPhone.h"
#import "C5_BonusBoard_iPhone.h"

#import "F0_AddressListBoard_iPhone.h"
#import "H0_BrowserBoard_iPhone.h"
#import "F1_NewAddressBoard_iPhone.h"
#import "H1_PayBoard_iPhone.h"

#import "bee.services.alipay.h"

#pragma mark -

@interface C1_CheckOutBoard_iPhone()
{
    NSUInteger    _lastSlectedBonusIndex;
}
@property (nonatomic, retain) NSArray * avaliableBonus;
@end

#pragma mark -

@implementation C1_CheckOutBoard_iPhone

SUPPORT_RESOURCE_LOADING( YES );
SUPPORT_AUTOMATIC_LAYOUT( YES );

DEF_SIGNAL( ACTION_PAY )
DEF_SIGNAL( ACTION_BACK )

DEF_MODEL( FlowModel, flowModel )

- (void)load
{
    self.flowModel = [FlowModel modelWithObserver:self];
}

- (void)unload
{
	SAFE_RELEASE_MODEL( self.flowModel );
}

#pragma mark -

ON_CREATE_VIEWS(signal)
{
    self.navigationBarShown = YES;
    self.navigationBarTitle = __TEXT(@"checkout");
    self.navigationBarLeft  = [UIImage imageNamed:@"nav_back.png"];
    
    @weakify(self);
    
    self.list.lineCount = 1;
    self.list.reuseEnable = NO;
    self.list.whenReloading = ^
    {
        
        @normalize(self);
        
        self.list.total = 1;
        
        BeeUIScrollItem * item = self.list.items[0];
        item.clazz = [C1_CheckOutCell_iPhone class];
        item.size = CGSizeAuto;
        item.data = self.flowModel;
        item.rule = BeeUIScrollLayoutRule_Line;
    };
}

ON_DELETE_VIEWS(signal)
{
    [self unobserveAllNotifications];
}

ON_WILL_APPEAR(signal)
{
    [bee.ui.appBoard hideTabbar];
    
//    if ( !self.flowModel.loaded )
    {
        [self.flowModel checkOrder];
    }
//    else
//    {
//        [self.list reloadData];
//    }
}

ON_LEFT_BUTTON_TOUCHED( signal )
{
	[self.stack popBoardAnimated:YES];
}

#pragma mark -

ON_SIGNAL3( C1_CheckOutBoard_iPhone, ACTION_PAY, signal )
{
    ORDER_INFO * order_info = self.flowModel.order_info;
    if ( order_info )
    {
        if ( NSOrderedSame == [order_info.pay_code compare:@"alipay" options:NSCaseInsensitiveSearch] )
        {
            ALIAS( bee.services.alipay,	alipay );
            
            if ( alipay.installed )
            {
                @weakify(self);
                
                alipay.order.no		= order_info.order_sn;
                alipay.order.name	= order_info.subject;
                alipay.order.desc	= order_info.desc;
                alipay.order.price	= order_info.order_amount;
                alipay.whenWaiting = ^
                {
                };
                alipay.whenSucceed = ^
                {
                    @normalize(self);
                    
                    [self.previousBoard presentMessageTips:__TEXT(@"pay_succeed")];
                    [self.stack popBoardAnimated:YES];
                };
                alipay.whenFailed = ^
                {
                    @normalize(self);
                    
                    [self presentMessageTips:__TEXT(@"pay_failed")];
                };
                alipay.PAY();
                
                return;
            }
        }
        else if ( NSOrderedSame == [order_info.pay_code compare:@"cod" options:NSCaseInsensitiveSearch] )
        {
            [self.previousBoard presentMessageTips:__TEXT(@"pay_noneed")];
            [self.stack popBoardAnimated:YES];
            return;
        }
    }
    
    H1_PayBoard_iPhone * board = [H1_PayBoard_iPhone board];
    board.title = __TEXT(@"pay");
    board.backBoard = self.previousBoard;
    board.orderID = self.flowModel.order_id;
    [self.stack pushBoard:board animated:YES];
}

ON_SIGNAL3( C1_CheckOutBoard_iPhone, ACTION_BACK, signal )
{
    [self.stack popBoardAnimated:YES];
}

#pragma mark - C1_CheckOutCell_iPhone

/**
 * 购物车-结算-收件人信息，修改收件人地址时触发的操作
 */
ON_SIGNAL3( C1_CheckOutCell_iPhone, consignee, signal )
{
    F0_AddressListBoard_iPhone * board = [F0_AddressListBoard_iPhone board];
    board.shouldGotoManage = NO;
    [self.stack pushBoard:board animated:YES];
}

/**
 * 购物车-结算-支付方式，点击事件触发时执行的操作
 */
ON_SIGNAL3( C1_CheckOutCell_iPhone, balance_pay, signal )
{
    C2_PaymentBoard_iPhone * board = [C2_PaymentBoard_iPhone board];
    board.flowModel = self.flowModel;
    [self.stack pushBoard:board animated:YES];
}

/**
 * 购物车-结算-配送方式，点击事件触发时执行的操作
 */
ON_SIGNAL3( C1_CheckOutCell_iPhone, balance_shipping, signal )
{
    C3_DistributionBoard_iPhone * board = [C3_DistributionBoard_iPhone board];
    board.flowModel = self.flowModel;
    [self.stack pushBoard:board animated:YES];
}

/**
 * 购物车-结算-发票信息，点击事件触发时执行的操作
 */
ON_SIGNAL3( C1_CheckOutCell_iPhone, balance_bill, signal )
{
    C4_InvoiceBoard_iPhone * board = [C4_InvoiceBoard_iPhone board];
    board.flowModel = self.flowModel;
    [self.stack pushBoard:board animated:YES];
}

/**
 * 购物车-结算-红包，点击事件触发时执行的操作
 */
ON_SIGNAL3( C1_CheckOutCell_iPhone, balance_redpocket, signal )
{
    NSMutableArray * titles = [NSMutableArray array];
    
    if ( self.avaliableBonus )
    {
        for ( BONUS * b in self.avaliableBonus )
        {
            [titles addObject:b.bonus_money_formated];
        }
        
        BeeUIPickerView * bonusPicker = [BeeUIPickerView spawn];
        [bonusPicker addTitles:titles forColumn:0];
        [bonusPicker showInViewController:self];
        [bonusPicker selectRow:_lastSlectedBonusIndex inComponent:0 animated:NO];
    }
    else
    {
        [self presentFailureTips:__TEXT(@"not_support_a_red_envelope")];
    }
//
}

/**
 * 购物车-结算-积分，点击事件触发时执行的操作
 */
ON_SIGNAL3( C1_CheckOutCell_iPhone, balance_exp, signal )
{
    C5_BonusBoard_iPhone * board = [C5_BonusBoard_iPhone board];
    board.yourBonus = self.flowModel.your_integral.integerValue;
    board.maxBonus = self.flowModel.order_max_integral.integerValue;
    [self.stack pushBoard:board animated:YES];
}

#pragma mark - C1_CheckoutOrderCellFooter_iPhone

/**
 * 购物车-结算-订单明细-提交订单，点击事件触发时执行的操作
 */
ON_SIGNAL3( C1_CheckoutOrderCellFooter_iPhone, submit, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {        
        if ( !(self.flowModel.done_payment.pay_name
            && self.flowModel.done_payment.pay_name.length) )
        {
            [self presentFailureTips:__TEXT(@"warn_no_pay")];
            return;
        }

        if ( !(self.flowModel.done_shipping.shipping_name
            && self.flowModel.done_shipping.shipping_name.length) )
        {
            [self presentFailureTips:__TEXT(@"warn_no_shipping")];
            return;
        }

		if ( [self.flowModel.done_payment.pay_code isEqualToString:@"cod"] )
		{
			if ( NO == self.flowModel.done_shipping.support_cod.boolValue )
			{
				[self presentFailureTips:__TEXT(@"warn_not_support_cod")];
				return;
			}
		}
		
        [self.flowModel done];
    }
}

#pragma mark - BeeUIPickerView

ON_SIGNAL3( BeeUIPickerView, CONFIRMED, signal )
{
    BeeUIPickerView * picker = signal.source;
    NSUInteger index = [picker selectedRowInColumn:0];
    _lastSlectedBonusIndex = index;
    
//    self.validateModel.bonus = self.avaliableBouns[index];
//    [self.validateModel validateBonus];
    BONUS * bonus = self.avaliableBonus[index];
    
    NSString * picked = [NSString stringWithFormat:@"picked %@", bonus.bonus_money_formated];
    [self presentMessageTips:picked];
    
    self.flowModel.done_bonus = bonus.bonus_id;
    self.flowModel.data_bonus = bonus;
    
    [self.list reloadData];
}

#pragma mark -

ON_MESSAGE3( API, flow_checkOrder, msg )
{
    if ( msg.sending )
    {
        if ( NO == self.flowModel.loaded )
        {
            [self presentLoadingTips:__TEXT(@"tips_loading")];
        }
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
			self.avaliableBonus = self.flowModel.bonus;
			
			[self.list reloadData];
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

ON_MESSAGE3( API, flow_done, msg )
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
			ORDER_INFO * order_info = self.flowModel.order_info;
			
			if ( order_info )
			{
				if ( NSOrderedSame == [order_info.pay_code compare:@"cod" options:NSCaseInsensitiveSearch] )
				{
					[[BeeUIApplication sharedInstance] presentMessageTips:__TEXT(@"pay_noneed")];
					[self.stack popBoardAnimated:YES];
					return;
				}
			}
			
			BeeUIAlertView * alert = [BeeUIAlertView spawn];
			alert.message = __TEXT(@"pay_or_not");
			[alert addButtonTitle:__TEXT(@"button_no") signal:self.ACTION_BACK];
			[alert addButtonTitle:__TEXT(@"button_yes") signal:self.ACTION_PAY];
			[alert showInViewController:self];
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

ON_MESSAGE3( API, validate_bonus, msg )
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
	}
	else if( msg.failed )
	{
		[self showErrorTips:msg];
	}
}

@end
