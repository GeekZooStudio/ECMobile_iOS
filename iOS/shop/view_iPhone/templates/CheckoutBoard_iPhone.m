/*
 *                                                                          
 *       _/_/_/                      _/        _/_/_/_/_/                     
 *    _/          _/_/      _/_/    _/  _/          _/      _/_/      _/_/    
 *   _/  _/_/  _/_/_/_/  _/_/_/_/  _/_/          _/      _/    _/  _/    _/   
 *  _/    _/  _/        _/        _/  _/      _/        _/    _/  _/    _/    
 *   _/_/_/    _/_/_/    _/_/_/  _/    _/  _/_/_/_/_/    _/_/      _/_/       
 *                                                                          
 *
 *  Copyright 2013-2014, Geek Zoo Studio
 *  http://www.ecmobile.cn/license.html
 *
 *  HQ China:
 *    2319 Est.Tower Van Palace 
 *    No.2 Guandongdian South Street 
 *    Beijing , China
 *
 *  U.S. Office:
 *    One Park Place, Elmira College, NY, 14901, USA
 *
 *  QQ Group:   329673575
 *  BBS:        bbs.ecmobile.cn
 *  Fax:        +86-10-6561-5510
 *  Mail:       info@geek-zoo.com
 */
	
#import "CheckoutBoard_iPhone.h"
#import "AppBoard_iPhone.h"
#import "OrdersBoard_iPhone.h"
#import "InvoiceBoard_iPhone.h"
#import "PaymentBoard_iPhone.h"
#import "ShippingBoard_iPhone.h"
//#import "SettingBoard_iPhone.h"
#import "IntegralBoard_iPhone.h"
#import "BonusBoard_iPhone.h"
#import "AddressListBoard_iPhone.h"
#import "WebViewBoard_iPhone.h"
#import "AddAddressBoard_iPhone.h"
#import "PayBoard_iPhone.h"

#pragma mark -

@implementation CheckoutOrderCellInfo_iPhone

SUPPORT_RESOURCE_LOADING( YES )

- (void)dataDidChanged
{
    if ( [self.shipping.shipping_fee notEmpty] )
    {
        $(@"#ship").TEXT( [NSString stringWithFormat:@"+ %@", self.shipping.shipping_fee] );
    }
    else
    {
        $(@"#ship").TEXT( [NSString stringWithFormat:@"+ %@0.0%@", __TEXT(@"yuan_unit"), __TEXT(@"yuan")] );
    }
    
    if ( [self.bonus notEmpty] )
    {
        $(@"#bonus").TEXT( [NSString stringWithFormat:@"- %@", self.bonus] );
    }
    else
    {
        $(@"#bonus").TEXT( [NSString stringWithFormat:@"- %@0.0%@", __TEXT(@"yuan_unit"), __TEXT(@"yuan")] );
    }
    
    if ( [self.intergal notEmpty] )
    {
        $(@"#integral").TEXT( [NSString stringWithFormat:@"- %@", self.intergal] );
    }
    else
    {
        $(@"#integral").TEXT( [NSString stringWithFormat:@"- %@0.0%@", __TEXT(@"yuan_unit"), __TEXT(@"yuan")] );
    }
    
}

@end

@implementation CheckoutOrderCellFooter_iPhone

SUPPORT_RESOURCE_LOADING( YES )

- (void)dataDidChanged
{
    $(@"#cart-goods-desc").TEXT( __TEXT(@"balance_rental") );
    
    if ( self.data )
    {
        $(@"#cart-goods-price").TEXT( [NSString stringWithFormat:@"%@ %@", self.data, __TEXT(@"yuan")]);
    }
    else
    {
        $(@"#cart-goods-price").TEXT( [NSString stringWithFormat:@"0.00 %@", __TEXT(@"yuan")] );
    }
}

@end

@implementation CheckoutOrderCellHeader_iPhone

SUPPORT_RESOURCE_LOADING( YES )

@end

@implementation CheckoutOrderCellBody_iPhone

SUPPORT_RESOURCE_LOADING( YES )

- (void)dataDidChanged
{
    if ( self.data )
    {
        CART_GOODS * goods = self.data;
        $(@"#order-goods-count").TEXT( [NSString stringWithFormat:@"X %@", goods.goods_number] );
        $(@"#order-goods-price").TEXT( goods.formated_goods_price );
        $(@"#order-goods-title").TEXT( goods.goods_name );
    }
}

@end

@implementation CheckoutOrderCell_iPhone

+ (CGSize)estimateUISizeByWidth:(CGFloat)width forData:(id)data
{
    NSUInteger count = ((FlowModel *)data).goods_list.count;
    CGSize size = CGSizeMake( width, [self.class heightByCount:count] );
    return size;
}

+ (CGFloat)heightByCount:(NSInteger)count
{
    return ( 175 + 32 * count );
}

- (void)layoutDidFinish
{
    _scroll.frame = CGRectMakeBound(self.width, self.height);;
	[_scroll reloadData];
}

- (void)load
{
    [super load];
    
    _scroll = [[BeeUIScrollView alloc] init];
    _scroll.scrollEnabled = NO;
    _scroll.dataSource = self;
    [self addSubview:_scroll];
    
    _dataCounts = 3;
}

- (void)dataDidChanged
{
    if ( self.data )
    {
        self.flowModel = self.data;
                
        [_scroll reloadData];
		[_scroll setNeedsDisplay];
    }
}


#pragma mark -

- (NSInteger)numberOfLinesInScrollView:(BeeUIScrollView *)scrollView
{
	return 1;
}

- (NSInteger)numberOfViewsInScrollView:(BeeUIScrollView *)scrollView
{
    NSUInteger count = self.flowModel.goods_list.count;

    if ( count )
    {
        count += 3;
    }
	return count;
}

- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index scale:(CGFloat)scale
{
    NSUInteger count = self.flowModel.goods_list.count;
    
    if ( count )
    {
        count += 3;
    }
    
    if ( 0 == index )
    {
        CheckoutOrderCellHeader_iPhone * cell = [scrollView dequeueWithContentClass:[CheckoutOrderCellHeader_iPhone class]];
        return cell;
    }
    else if( (count - 1) == index )
    {
        CheckoutOrderCellFooter_iPhone * cell = [scrollView dequeueWithContentClass:[CheckoutOrderCellFooter_iPhone class]];
        
        cell.data = [self sumprice];
        
        return cell;
    }
    else if( (count - 2) == index )
    {
        CheckoutOrderCellInfo_iPhone * cell = [scrollView dequeueWithContentClass:[CheckoutOrderCellInfo_iPhone class]];
        cell.shipping = self.flowModel.done_shipping;
        cell.bonus = self.flowModel.data_bonus.bonus_money_formated;
        cell.intergal = self.flowModel.data_integral_formated;
        cell.data = nil;
        return cell;
    }
    else
    {
        CheckoutOrderCellBody_iPhone * cell = [scrollView dequeueWithContentClass:[CheckoutOrderCellBody_iPhone class]];
        cell.data = [self.flowModel.goods_list objectAtIndex:index-1];
        return cell;
    }
}

- (CGSize)scrollView:(BeeUIScrollView *)scrollView sizeForIndex:(NSInteger)index
{
    NSUInteger count = self.flowModel.goods_list.count;
    
    if ( count )
    {
        count += 3;
    }
    
    CGSize size = CGSizeZero;
    
    if ( 0 == index )
    {
        size = CGSizeMake(320, 32);
    }
    else if( (count - 1) == index )
    {
        size = CGSizeMake(320, 90);
    }
    else if( (count - 2) == index )
    {
        size = CGSizeMake(320, 79);
    }
    else
    {
        size = CGSizeMake(320, 30);
    }
    
	return size;
}

- (NSNumber *)sumprice
{
    CGFloat sumprice = 0;
    
    for ( CART_GOODS * goods in self.flowModel.goods_list )
    {
        sumprice += goods.goods_price.floatValue * goods.goods_number.integerValue;
    }
    
    sumprice += self.flowModel.done_shipping.shipping_fee.floatValue;
    sumprice -= self.flowModel.data_integral.floatValue;
    sumprice -= self.flowModel.data_bonus.type_money.floatValue;
    
    return @(sumprice);
}

@end

#pragma mark -

@implementation CheckoutHeader_iPhone

SUPPORT_RESOURCE_LOADING( YES )

- (void)layoutDidFinish
{
    
}

- (void)load
{
    [super load];
    
}

- (void)dataDidChanged
{
    if ( self.data )
    {
        ADDRESS * address = self.data;
        
        $(@"#address-name").TEXT( address.consignee );
        $(@"#phone").TEXT( address.tel );
        $(@"#location").TEXT( [RegionModel regionFromAddress:address] );
        $(@"#address").TEXT( address.address );
    }
}

+ (CGSize)estimateUISizeByWidth:(CGFloat)width forData:(id)data
{
    return [super estimateUISizeByWidth:width forData:data];
}

@end

#pragma mark -

@interface CheckoutBoard_iPhone()
{
    NSUInteger    _lastSlectedBonusIndex;
}
@property (nonatomic, retain) NSArray * avaliableBonus;
@end

@implementation CheckoutBoard_iPhone

DEF_SIGNAL( ACTION_PAY )
DEF_SIGNAL( ACTION_BACK )

- (void)load
{
	[super load];
        
    self.datas = [[[NSMutableArray alloc] init] autorelease];
    
    _address  = [FormElement customWithClass:[CheckoutHeader_iPhone class]];
    
    _payment  = [FormElement subtitleWithTitle:__TEXT(@"balance_pay")];
    _payment.isNecessary = YES;
    
    _shipping = [FormElement subtitleWithTitle:__TEXT(@"balance_shipping")];
    _shipping.isNecessary = YES;
    
    _invoice  = [FormElement subtitleWithTitle:__TEXT(@"balance_bill")];
    
//    _orders   = [FormElement subtitleWithTitle:__TEXT(@"balance_list")];
    
    _bonus    = [FormElement subtitleWithTitle:__TEXT(@"balance_redpocket")];
    
    _integral = [FormElement subtitleWithTitle:__TEXT(@"balance_exp")];

    _details  = [FormElement customWithClass:[CheckoutOrderCell_iPhone class]];
    
    NSArray * group1 = @[ _address ];
    [self.datas addObject:group1];

    NSArray * group2 = @[ _payment, _shipping, _invoice ];
    [self.datas addObject:group2];

    NSArray * group3 = @[ _bonus, _integral ];
    [self.datas addObject:group3];
    
    NSArray * group4 = @[ _details ];
    [self.datas addObject:group4];
    
    self.flowModel = [[[FlowModel alloc] init] autorelease];
    [self.flowModel addObserver:self];
}

- (void)unload
{
    [self.datas removeAllObjects];
    self.datas = nil;
    
    [self.flowModel removeObserver:self];
    self.flowModel = nil;

	[super unload];
}

#pragma mark -

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        self.titleString = __TEXT(@"checkout");
        [self showNavigationBarAnimated:NO];
        [self hideBarButton:BeeUINavigationBar.RIGHT];
        [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav-back.png"]];

        [[CurrentAddressModel sharedInstance] clearCache];

        _lastSlectedBonusIndex = 0;
		
    }
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
		[self unobserveAllNotifications];
	}
	else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{
	}
    else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
    {
    }
    else if ( [signal is:BeeUIBoard.FREE_DATAS] )
    {
    }
    else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
    {
        [[AppBoard_iPhone sharedInstance] setTabbarHidden:YES];

        [self.flowModel checkOrder];
    }
    else if ( [signal is:BeeUIBoard.DID_APPEAR] )
    {
        
    }
}

ON_SIGNAL2( BeeUINavigationBar, signal )
{
	[super handleUISignal:signal];

    if ( [signal is:BeeUINavigationBar.LEFT_TOUCHED] )
    {
        [self.stack popBoardAnimated:YES];
    }
    else if ( [signal is:BeeUINavigationBar.RIGHT_TOUCHED] )
    {
        
    }
}

ON_SIGNAL2( CheckoutBoard_iPhone , signal )
{
    if ( [signal is:self.ACTION_PAY] )
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

		PayBoard_iPhone * board = [PayBoard_iPhone board];
		board.title = __TEXT(@"pay");
		board.isFromCheckoutBoard = YES;
		board.orderID = self.flowModel.order_id;
		[self.stack pushBoard:board animated:YES];
    }
    else if ( [signal is:self.ACTION_BACK] )
    {
//        if ( self.previousBoard )
//        {
//            [self.stack popToBoard:self.previousBoard animated:YES];
//        }
//        else
//        {
            [self.stack popBoardAnimated:YES];
//        }
    }
}

ON_SIGNAL3( CheckoutHeader_iPhone, select_address, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
        AddressListBoard_iPhone * board = [AddressListBoard_iPhone board];
        board.shouldGotoManage = NO;
        [self.stack pushBoard:board animated:YES];
    }
}

ON_SIGNAL3( CheckoutOrderCellFooter_iPhone, submit, signal )
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

ON_SIGNAL3( BeeUIPickerView, CONFIRMED, signal )
{
    BeeUIPickerView * picker = signal.source;
    NSUInteger index = [picker selectedRowInColumn:0];
    NSString * picked = [NSString stringWithFormat:@"picked %@", self.avaliableBonus[index]];
    [self presentMessageTips:picked];
    
    _lastSlectedBonusIndex = index;
    
//    self.validateModel.bonus = self.avaliableBouns[index];
//    [self.validateModel validateBonus];
    BONUS * bonus = self.avaliableBonus[index];
    
    self.flowModel.done_bonus = bonus.bonus_id;
    self.flowModel.data_bonus = bonus;
    
    [self reloadData];
}

#pragma mark -

- (void)reloadData
{
    if ( ![CurrentAddressModel sharedInstance].address )
    {
        if ( self.flowModel.consignee )
        {
            [CurrentAddressModel sharedInstance].defaultAddress = self.flowModel.consignee;
            [CurrentAddressModel sharedInstance].address = self.flowModel.consignee;
        }
    }
	
    _address.data = [CurrentAddressModel sharedInstance].address;
    _invoice.subtitle = self.flowModel.done_inv_payee;
    _payment.subtitle = self.flowModel.done_payment.pay_name;
    _shipping.subtitle = self.flowModel.done_shipping.shipping_name;
    _orders.subtitle = [NSString stringWithFormat:@"%d%@", self.flowModel.goods_list.count, __TEXT(@"no_of_items")];
    
    BOOL integralAllow = self.flowModel.allow_use_integral.boolValue && MIN( self.flowModel.your_integral.integerValue, self.flowModel.order_max_integral.integerValue );
    
    if ( integralAllow )
    {
        if ( self.flowModel.done_integral )
        {
            _integral.subtitle = [NSString stringWithFormat:__TEXT(@"use_exp"), self.flowModel.done_integral];
        }
        _integral.enable = YES;
    }
    else
    {
        _integral.enable = NO;
    }
    
    BOOL bonusAllow = self.flowModel.allow_use_bonus.boolValue && self.flowModel.bonus.count;
    
    if ( bonusAllow )
    {
        if ( self.flowModel.done_bonus )
        {
            _bonus.subtitle = [NSString stringWithFormat:@"%@", self.flowModel.data_bonus.bonus_money_formated];
        }
        _bonus.enable = YES;
    }
    else
    {
        _bonus.enable = NO;
    }
    
    _details.data = self.flowModel;

    self.avaliableBonus = self.flowModel.bonus;
    
    [self.table reloadData];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FormElement * element = [[self.datas objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    if ( element == _payment )
    {
        PaymentBoard_iPhone * board = [PaymentBoard_iPhone board];
        board.payment_list = self.flowModel.payment_list;
        [self.stack pushBoard:board animated:YES];
    }
    else if ( element == _shipping )
    {
        ShippingBoard_iPhone * board = [ShippingBoard_iPhone board];
        board.shipping_list = self.flowModel.shipping_list;
        [self.stack pushBoard:board animated:YES];
    }
    else if ( element == _invoice )
    {
        InvoiceBoard_iPhone * board = [InvoiceBoard_iPhone board];
        board.inv_content_list = self.flowModel.inv_content_list;
        board.inv_type_list = self.flowModel.inv_type_list;
        [self.stack pushBoard:board animated:YES];
    }
    else if ( element == _integral )
    {
        if ( _integral.enable )
        {
            IntegralBoard_iPhone * board = [IntegralBoard_iPhone board];
            board.your_integral = self.flowModel.your_integral;
            board.order_max_integral = self.flowModel.order_max_integral;
            [self.stack pushBoard:board animated:YES];
        }
        else
        {
            [self presentFailureTips:__TEXT(@"not_support_score_exchange")];
        }
    }
    else if ( element == _bonus )
    {
        if ( _bonus.enable )
        {
//            BonusBoard_iPhone * board = [BonusBoard_iPhone board];
//            board.allow_use_bonus = self.flowModel.allow_use_bonus;
//            [self.stack pushBoard:board animated:YES];
            
            NSMutableArray * titles = [NSMutableArray array];
            
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
    }
}

#pragma mark -

- (void)handleMessage:(BeeMessage *)msg
{
    [super handleMessage:msg];
    
    if ( msg.sending )
    {
        [self presentLoadingTips:__TEXT(@"tips_loading")];
    }
    else
    {
        [self dismissTips];
    }
    
    if ( [msg is:API.flow_checkOrder] )
    {    
        if ( msg.succeed )
        {
            [self reloadData];
        }
        else if ( msg.failed )
        {
            [self presentFailureTips:__TEXT(@"error_network")];
        }
    }
    else if ( [msg is:API.flow_done] )
    {
        if ( msg.succeed )
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
//			alert.title = @"提交订单成功";
            alert.message = __TEXT(@"pay_or_not");
            [alert addButtonTitle:__TEXT(@"button_no") signal:self.ACTION_BACK];
            [alert addButtonTitle:__TEXT(@"button_yes") signal:self.ACTION_PAY];
            [alert showInViewController:self];
        }
        else if ( msg.failed )
        {
            
        }
    }
    else if ( [msg is:API.validate_bonus] )
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
//            [self presentFailureTips:@"验证失败"];
			[ErrorMsg presentErrorMsg:msg inBoard:self];
        }
    }
}

#pragma mark -

ON_NOTIFICATION3( ServiceAlipay, WAITING, notification )
{
}

ON_NOTIFICATION3( ServiceAlipay, SUCCEED, notification )
{
	[[BeeUIApplication sharedInstance] presentMessageTips:__TEXT(@"pay_succeed")];
	
	[self.stack popBoardAnimated:YES];
}

ON_NOTIFICATION3( ServiceAlipay, FAILED, notification )
{
	[[BeeUIApplication sharedInstance] presentMessageTips:__TEXT(@"pay_failed")];
	
	[self.stack popBoardAnimated:YES];
}

@end
