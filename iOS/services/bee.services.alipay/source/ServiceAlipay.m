//
//   ______    ______    ______
//  /\  __ \  /\  ___\  /\  ___\
//  \ \  __<  \ \  __\_ \ \  __\_
//   \ \_____\ \ \_____\ \ \_____\
//    \/_____/  \/_____/  \/_____/
//
//
//  Copyright (c) 2014-2015, Geek Zoo Studio
//  http://www.bee-framework.com
//
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//

#import "ServiceAlipay.h"
#import "Order.h"
#import "DataSigner.h"
#import "DataVerifier.h"
#import <AlipaySDK/AlipaySDK.h>

@implementation ServiceAlipay

DEF_NOTIFICATION( WAITING )
DEF_NOTIFICATION( SUCCEED )
DEF_NOTIFICATION( FAILED )

DEF_SINGLETON( ServiceAlipay )

#pragma mark -

- (void)powerOn
{
}

- (void)powerOff
{
}

- (void)serviceWillActive
{
}

- (void)serviceDidActived
{
    
    NSURL * url = [self.launchParameters objectForKey:@"url"];
    
    if ( nil == url )
    {
        return;
    }
    if ([url.host isEqualToString:@"safepay"])
    {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                                  standbyCallback:^(NSDictionary *resultDic) {
                                                      NSLog(@"result = %@",resultDic);
                                                  }];
    }
}

- (void)serviceWillDeactive
{
}

- (void)serviceDidDeactived
{
}

#pragma mark -

- (void)notifyWaiting
{
    [self postNotification:ServiceAlipay.WAITING];
    
    if ( self.whenWaiting )
    {
        self.whenWaiting();
    }
}

- (void)notifySucceed
{
    [self postNotification:ServiceAlipay.SUCCEED];
    
    if ( self.whenSucceed )
    {
        self.whenSucceed();
    }
}

- (void)notifyFailed
{
    [self postNotification:ServiceAlipay.FAILED];
    
    if ( self.whenFailed )
    {
        self.whenFailed();
    }
}

#pragma mark -

- (ServiceAlipayConfig *)config
{
    return [ServiceAlipayConfig sharedInstance];
}

#pragma mark -

- (BeeServiceBlock)PAY
{
    BeeServiceBlock block = ^ void ( void )
    {
        [self pay];
    };
    
    return [block copy];
}

#pragma mark -

- (void)pay
{
    Order * order = [[Order alloc] init];
    order.partner = self.config.partner;
    order.seller = self.config.seller;
    order.tradeNO = self.config.tradeNO; //订单ID(由商家自行制定)
    order.productName = self.config.productName; //商品标题
    order.productDescription = self.config.productDescription; //商品描述
    order.amount = self.config.amount; //商品价格
    order.notifyURL = self.config.notifyURL; //回调URL
    
    // 参见接入与使用（3技术接入规则）、支付宝钱包支付接口开发包（5请求参数说明）
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
//    order.itBPay = @"30m";
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString * appScheme = [BeeSystemInfo appSchema:@"alipay"];
    
    //将商品信息拼接成字符串
    NSString * orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循 RSA 签名规范, 并将签名字符串 base64 编码和 UrlEncode
    
    id<DataSigner> signer = CreateRSADataSigner(self.config.privateKey);
     NSString * signedString = [signer signString:orderSpec];
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString * orderString = nil;
    if ( signedString != nil )
    {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary * resultDic) {
            //【callback 处理支付结果】
            NSLog(@"reslut = %@",resultDic);
            
            // 通知返回时验证签名
            NSNumber * resultStatus = resultDic[@"resultStatus"];
            NSString * resultStr = resultDic[@"result"];
            
            NSString * verifierStr ; // 同步通知待签名字符串
            NSString * signedStr ; // 支付宝通知返回参数中的sign
            NSString * successStr = [NSString stringWithFormat:@"success=\"%@\"",@"true"]; // success="true"
            BOOL success; // result中是否包含success="true"

            if ( resultStatus.intValue == 9000 )
            {
                if ( resultStr && resultStr.length )
                {
                    NSRange range = [resultStr rangeOfString:successStr];
                    if ( range.length == [successStr length] )
                    {
                        success = YES;
                    }
                    else
                    {
                        success = NO;
                    }
                    
                    NSArray * items = [resultStr componentsSeparatedByString:[NSString stringWithFormat:@"&sign_type=\"%@\"&sign=",@"RSA"]];
                    if ( items && items.count )
                    {
                        verifierStr = items[0];
                        signedStr = items[1];
                        signedStr = [signedStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                        
                        id<DataVerifier> verifier = CreateRSADataVerifier(self.config.publicKey);
                        BOOL result  = [verifier verifyString:verifierStr withSign:signedStr];
                        
                        if ( success && result )
                        {
                            if ( self.whenSucceed )
                            {
                                self.whenSucceed();
                            }
                        }
                        else
                        {
                            if ( self.whenFailed )
                            {
                                self.whenFailed();
                            }
                        }
                    }
                }
            }
            else
            {
                if ( self.whenFailed )
                {
                    self.whenFailed();
                }
            }
        }];
    }
}

@end
