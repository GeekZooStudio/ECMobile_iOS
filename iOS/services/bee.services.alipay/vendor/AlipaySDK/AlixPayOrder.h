//
//  AlixPayOrder.h
//  AliPay
//
//  Created by WenBi on 11-5-18.
//  Copyright 2011 Alipay. All rights reserved.
//

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import <Foundation/Foundation.h>

@interface AlixPayOrder : NSObject {
	NSString * _partner;
	NSString * _seller;
	NSString * _tradeNO;
	NSString * _productName;
	NSString * _productDescription;
	NSString * _amount;
	NSString * _notifyURL;
	NSMutableDictionary * _extraParams;
	NSString * _service;
	NSString * _paymentType;
	NSString * _inputCharset;
	NSString * _itBPay;
	NSString * _showUrl;
}

@property(nonatomic, copy) NSString * partner;
@property(nonatomic, copy) NSString * seller;
@property(nonatomic, copy) NSString * tradeNO;
@property(nonatomic, copy) NSString * productName;
@property(nonatomic, copy) NSString * productDescription;
@property(nonatomic, copy) NSString * amount;
@property(nonatomic, copy) NSString * notifyURL;
@property(nonatomic, copy) NSString * service;
@property(nonatomic, copy) NSString * paymentType;
@property(nonatomic, copy) NSString * inputCharset;
@property(nonatomic, copy) NSString * itBPay;
@property(nonatomic, copy) NSString * showUrl;
@property(nonatomic, readonly) NSMutableDictionary * extraParams;

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)