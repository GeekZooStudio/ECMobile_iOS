//
//  WXPayModel.m
//  shop
//
//  Created by QFish on 5/4/15.
//  Copyright (c) 2015 geek-zoo studio. All rights reserved.
//

#import "WXPayModel.h"
#import "bee.services.share.weixin.h"

#pragma mark - POST /order/pay_weixin

#pragma mark - REQ_ORDER_PAY_WEIXIN

@implementation REQ_ORDER_PAY_WEIXIN

@synthesize order_id = _order_id;
@synthesize session = _session;

- (BOOL)validate
{
    return YES;
}

@end

#pragma mark - RESP_ORDER_PAY_WEIXIN

@implementation RESP_ORDER_PAY_WEIXIN

@synthesize appid = _appid;
@synthesize error_code = _error_code;
@synthesize error_desc = _error_desc;
@synthesize noncestr = _noncestr;
@synthesize timestamp = _timestamp;
@synthesize package = _package;
@synthesize succeed = _succeed;
@synthesize prepayid = _prepayid;
@synthesize sign = _sign;

- (BOOL)validate
{
    return YES;
}

@end

@implementation API_ORDER_PAY_WEIXIN

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
    self = [super init];
    if ( self )
    {
        self.req = [[[REQ_ORDER_PAY_WEIXIN alloc] init] autorelease];
        self.resp = nil;
    }
    return self;
}

- (void)dealloc
{
    self.req = nil;
    self.resp = nil;
    [super dealloc];
}

- (void)routine
{
    if ( self.sending )
    {
        if ( nil == self.req || NO == [self.req validate] )
        {
            self.failed = YES;
            return;
        }
        
        NSString * requestURI = bee.services.share.weixin.config.payUrl;
        NSString * requestBody = [self.req objectToString];
        self.HTTP_POST( requestURI ).PARAM( @"json", requestBody );
    }
    else if ( self.succeed )
    {
        NSObject * result = self.responseJSON;
        
        if ( result && [result isKindOfClass:[NSDictionary class]] )
        {
            self.resp = [RESP_ORDER_PAY_WEIXIN objectFromDictionary:(NSDictionary *)result];
        }
        
        if ( nil == self.resp || NO == [self.resp validate] )
        {
            self.failed = YES;
            return;
        }
    }
    else if ( self.failed )
    {
        // TODO:
    }
    else if ( self.cancelled )
    {
        // TODO:
    }
}
@end

#pragma mark - WXPayModel

@implementation WXPayModel

- (void)pay
{
    [API_ORDER_PAY_WEIXIN cancel:self];
    
    API_ORDER_PAY_WEIXIN * api = [API_ORDER_PAY_WEIXIN apiWithResponder:self];
    
    @weakify(api);
    
    api.req.session = [UserModel sharedInstance].session;
    api.req.order_id = self.order_id;
    
    api.whenUpdate = ^
    {
        @normalize(api);
        
        if ( api.sending )
        {
            [self sendUISignal:self.RELOADING];
        }
        else
        {
            [self dismissTips];
            
            if ( api.succeed && api.resp.succeed.boolValue )
            {
                self.pay_info = api.resp;
                [self sendUISignal:self.RELOADED];
            }
            else
            {
                [self sendUISignal:self.FAILED];
            }
        }
    };
    
    [api send];
}

@end
