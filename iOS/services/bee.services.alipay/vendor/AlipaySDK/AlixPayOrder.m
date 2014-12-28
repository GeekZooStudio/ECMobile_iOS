//
//  AlixPayOrder.m
//  AliPay
//
//  Created by WenBi on 11-5-18.
//  Copyright 2011 Alipay. All rights reserved.
//

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "AlixPayOrder.h"

#pragma mark -
#pragma mark AlixPayOrder
@implementation AlixPayOrder

@synthesize partner = _partner;
@synthesize seller = _seller;
@synthesize tradeNO = _tradeNO;
@synthesize productName = _productName;
@synthesize productDescription = _productDescription;
@synthesize amount = _amount;
@synthesize notifyURL = _notifyURL;
@synthesize extraParams = _extraParams;
@synthesize service = _service;
@synthesize paymentType = _paymentType;
@synthesize inputCharset = _inputCharset;
@synthesize itBPay = _itBPay;
@synthesize showUrl = _showUrl;

- (void)dealloc {
	self.partner = nil;
	self.seller = nil;
	self.tradeNO = nil;
	self.productName = nil;
	self.productDescription = nil;
	self.amount = nil;
	self.notifyURL = nil;
	[self.extraParams release];
	self.service = nil;
	self.paymentType = nil;
	self.inputCharset = nil;
	self.itBPay = nil;
	self.showUrl = nil;
	[super dealloc];
}

//拼接订单字符串函数,运行外部商户自行优化
- (NSString *)description {
	NSMutableString * discription = [NSMutableString string];
	[discription appendFormat:@"partner=\"%@\"", self.partner ? self.partner : @""];
	[discription appendFormat:@"&seller=\"%@\"", self.seller ? self.seller : @""];
	[discription appendFormat:@"&out_trade_no=\"%@\"", self.tradeNO ? self.tradeNO : @""];
	[discription appendFormat:@"&subject=\"%@\"", self.productName ? self.productName : @""];
	[discription appendFormat:@"&body=\"%@\"", self.productDescription ? self.productDescription : @""];
	[discription appendFormat:@"&total_fee=\"%@\"", self.amount ? self.amount : @""];
	[discription appendFormat:@"&notify_url=\"%@\"", self.notifyURL ? self.notifyURL : @""];
	for (NSString * key in [self.extraParams allKeys]) {
		[discription appendFormat:@"&%@=\"%@\"", key, [self.extraParams objectForKey:key]];
	}
	return discription;

//	NSMutableString * discription = [NSMutableString string];
//	if (self.partner) {
//		[discription appendFormat:@"partner=\"%@\"", self.partner];
//	}
//	
//	if (self.seller) {
//		[discription appendFormat:@"&seller_id=\"%@\"", self.seller];
//	}
//	if (self.tradeNO) {
//		[discription appendFormat:@"&out_trade_no=\"%@\"", self.tradeNO];
//	}
//	if (self.productName) {
//		[discription appendFormat:@"&subject=\"%@\"", self.productName];
//	}
//	
//	if (self.productDescription) {
//		[discription appendFormat:@"&body=\"%@\"", self.productDescription];
//	}
//	if (self.amount) {
//		[discription appendFormat:@"&total_fee=\"%@\"", self.amount];
//	}
//	if (self.notifyURL) {
//		[discription appendFormat:@"&notify_url=\"%@\"", self.notifyURL];
//	}
//
//	if (self.service) {
//		[discription appendFormat:@"&service=\"%@\"",self.service ? self.service : @""];//mobile.securitypay.pay
//	}
//	if (self.paymentType) {
//		[discription appendFormat:@"&payment_type=\"%@\"",self.paymentType ? self.paymentType : @""];//1
//	}
//	
//	if (self.inputCharset) {
//		[discription appendFormat:@"&_input_charset=\"%@\"",self.inputCharset ? self.inputCharset : @""];//utf-8
//	}
//	if (self.itBPay) {
//		[discription appendFormat:@"&it_b_pay=\"%@\"",self.itBPay ? self.itBPay : @""];//30m
//	}
//	if (self.showUrl) {
//		[discription appendFormat:@"&show_url=\"%@\"",self.showUrl? self.showUrl : @""];//m.alipay.com
//	}
//
//	for (NSString * key in [self.extraParams allKeys]) {
//		[discription appendFormat:@"&%@=\"%@\"", key, [self.extraParams objectForKey:key]];
//	}
//	return discription;
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
