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

#import "FlowModel.h"

#pragma mark -

@implementation FlowModel

DEF_SINGLETON( FlowModel )

@synthesize order_id = _order_id;
@synthesize allow_use_bonus = _allow_use_bonus;
@synthesize allow_use_integral = _allow_use_integral;
@synthesize consignee = _consignee;
@synthesize goods_list = _goods_list;
@synthesize inv_content_list = _inv_content_list;
@synthesize inv_type_list = _inv_type_list;
@synthesize order_max_integral = _order_max_integral;
@synthesize payment_list = _payment_list;
@synthesize shipping_list = _shipping_list;
@synthesize your_integral = _your_integral;

@synthesize done_payment = _done_payment;
@synthesize done_shipping = _done_shipping;
@synthesize done_bonus = _done_bonus;
@synthesize done_integral = _done_integral;
@synthesize done_inv_content = _done_inv_content;
@synthesize done_inv_payee = _done_inv_payee;
@synthesize done_inv_type = _done_inv_type;

@synthesize order_info = _order_info;

- (void)load
{
	[super load];
}

- (void)unload
{
	[self clearCache];
	[self clearFields];

	[super unload];
}

#pragma mark -

- (void)loadCache
{
}

- (void)saveCache
{
}

- (void)clearCache
{
	self.allow_use_bonus = nil;
	self.allow_use_integral = nil;
	self.consignee = nil;
	self.goods_list = nil;
	self.inv_content_list = nil;
	self.inv_type_list = nil;
	self.order_max_integral = nil;
	self.payment_list = nil;
	self.shipping_list = nil;
	self.your_integral = nil;
	self.order_info = nil;
}

- (void)clearFields
{
	self.done_payment = nil;
	self.done_shipping = nil;
	self.done_bonus = nil;
	self.done_integral = nil;
	self.done_inv_content = nil;
	self.done_inv_payee = nil;
	self.done_inv_type = nil;
}

- (void)checkOrder
{
	self.CANCEL_MSG( API.flow_checkOrder );
	self.MSG( API.flow_checkOrder );
}

- (void)done
{
	self.CANCEL_MSG( API.flow_done );
	self
	.MSG( API.flow_done )
	.INPUT( @"pay_id", self.done_payment.pay_id )
	.INPUT( @"shipping_id", self.done_shipping.shipping_id )
	.INPUT( @"bonus", self.done_bonus )
	.INPUT( @"integral", self.done_integral )
	.INPUT( @"inv_content", self.done_inv_content )
	.INPUT( @"inv_payee", self.done_inv_payee )
	.INPUT( @"inv_type", self.done_inv_type );
}

#pragma mark -

- (void)handleMessage:(BeeMessage *)msg
{
	if ( [msg is:API.flow_checkOrder] )
	{
		if ( msg.succeed )
		{
			STATUS * status = msg.GET_OUTPUT( @"status" );
			if ( NO == status.succeed.boolValue )
			{
				msg.failed = YES;
				return;
			}

//            msg.OUTPUT( @"status", status );
//            msg.OUTPUT( @"data", data );
//            msg.OUTPUT( @"data_allow_use_bonus", data_allow_use_bonus );
//            msg.OUTPUT( @"data_allow_use_integral", data_allow_use_integral );
//            msg.OUTPUT( @"data_consignee", data_consignee );
//            msg.OUTPUT( @"data_goods_list", data_goods_list );
//            msg.OUTPUT( @"data_inv_content_list", data_inv_content_list );
//            msg.OUTPUT( @"data_inv_type_list", data_inv_type_list );
//            msg.OUTPUT( @"data_order_max_integral", data_order_max_integral );
//            msg.OUTPUT( @"data_payments", data_payment_list );
//            msg.OUTPUT( @"data_shippings", data_shipping_list );
//            msg.OUTPUT( @"data_your_integral", data_your_integral );
            
			self.allow_use_bonus = msg.GET_OUTPUT( @"data_allow_use_bonus" );
			self.allow_use_integral = msg.GET_OUTPUT( @"data_allow_use_integral" );
			self.consignee = msg.GET_OUTPUT( @"data_consignee" );
			self.goods_list = msg.GET_OUTPUT( @"data_goods_list" );
			self.inv_content_list = msg.GET_OUTPUT( @"data_inv_content_list" );
			self.inv_type_list = msg.GET_OUTPUT( @"data_inv_type_list" );
			self.order_max_integral = msg.GET_OUTPUT( @"data_order_max_integral" );
			self.payment_list = msg.GET_OUTPUT( @"data_payment_list" );
			self.shipping_list = msg.GET_OUTPUT( @"data_shipping_list" );
			self.your_integral = msg.GET_OUTPUT( @"data_your_integral" );
            self.bonus = msg.GET_OUTPUT( @"data_bonus" );

			self.loaded = YES;
			
			[self saveCache];
		}
	}
	else if ( [msg is:API.flow_done] )
	{
		if ( msg.succeed )
		{
			STATUS * status = msg.GET_OUTPUT( @"status" );
			if ( NO == status.succeed.boolValue )
			{
				msg.failed = YES;
				return;
			}
            
            self.order_id = msg.GET_OUTPUT( @"data_order_id" );
			self.order_info = msg.GET_OUTPUT( @"order_info" );

			[self saveCache];
		}
	}
}

@end
