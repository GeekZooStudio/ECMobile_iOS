//
//  WXPayModel.h
//  shop
//
//  Created by QFish on 5/4/15.
//  Copyright (c) 2015 geek-zoo studio. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - POST /order/pay_weixin

@interface REQ_ORDER_PAY_WEIXIN : BeeActiveObject
@property (nonatomic, copy) NSNumber * order_id;
@property (nonatomic, retain) SESSION * session;
@end

@interface RESP_ORDER_PAY_WEIXIN : BeeActiveObject
@property (nonatomic, retain) NSNumber *			error_code;
@property (nonatomic, retain) NSString *			error_desc;
@property (nonatomic, retain) NSString *			appid;
@property (nonatomic, retain) NSString *			noncestr;
@property (nonatomic, retain) NSString *			timestamp;
@property (nonatomic, retain) NSString *			package;
@property (nonatomic, retain) NSString *			prepayid;
@property (nonatomic, retain) NSNumber *			succeed;
@property (nonatomic, retain) NSString *			sign;
@end

@interface API_ORDER_PAY_WEIXIN : BeeAPI
@property (nonatomic, retain) REQ_ORDER_PAY_WEIXIN *	req;
@property (nonatomic, retain) RESP_ORDER_PAY_WEIXIN *	resp;
@end

#pragma mark - WXPayModel

// 获取 prepayid

@interface WXPayModel : BeeOnceViewModel

@property (nonatomic, retain) IN NSNumber *       order_id; // 商品订单号

@property (nonatomic, retain) OUT RESP_ORDER_PAY_WEIXIN * pay_info;

- (void)pay;

@end
