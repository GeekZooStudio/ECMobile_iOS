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

#import "FlowModel.h"

#pragma mark -

@implementation FlowModel

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
}

- (void)unload
{
	[self clearCache];
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
	
	self.done_payment = nil;
	self.done_shipping = nil;
	self.done_bonus = nil;
	self.done_integral = nil;
	self.done_inv_content = nil;
	self.done_inv_payee = nil;
	self.done_inv_type = nil;

	self.loaded = NO;
}

#pragma mark -

- (void)checkOrder
{
	if ( NO == [UserModel online] )
		return;

	self.CANCEL_MSG( API.flow_checkOrder );
	self.MSG( API.flow_checkOrder );
}

- (void)done
{
	if ( NO == [UserModel online] )
		return;

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

- (void)reset
{
	self.done_payment = nil;
	self.done_shipping = nil;
	self.done_bonus = nil;
	self.done_integral = nil;
	self.done_inv_content = nil;
	self.done_inv_payee = nil;
	self.done_inv_type = nil;
}

#pragma mark -

ON_MESSAGE3( API, flow_checkOrder, msg )
{
	if ( msg.succeed )
	{
		STATUS * status = msg.GET_OUTPUT( @"status" );
		if ( NO == status.succeed.boolValue )
		{
			msg.failed = YES;
			return;
		}

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

ON_MESSAGE3( API, flow_done, msg )
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

@end
