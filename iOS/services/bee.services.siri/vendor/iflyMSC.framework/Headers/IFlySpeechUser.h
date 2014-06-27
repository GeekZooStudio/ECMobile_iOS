//
//  IFlySpeechError.h
//  MSC

//  description: 用户登陆接口,用户登陆是为了上传数据，

//  Created by iflytek on 13-4-8.
//  Copyright (c) 2013年 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IFlySpeechError.h"


@class IFlySpeechUser;

/** 登陆完成回调 */
__attribute__((deprecated))
@protocol IFlySpeechUserDelegate

/** 登陆结束回调
 
 当本函数被调用的时候，表明登陆已经完成，可能失败或者成功。
 
 @param iFlySpeechUser      -[out] 登陆对象，
 @param error               -[out] 本次会话的错误对象，0表示没有错误
*/
@optional
- (void) onEnd:(IFlySpeechUser *)iFlySpeechUser error:(IFlySpeechError *)error;

@end

/** 用户接口。
 *  此接口为用户登陆的接口，在上传用户数据时，您必须先登陆。
 */

@interface IFlySpeechUser : NSObject

@property (assign) id<IFlySpeechUserDelegate> delegate __attribute__((deprecated));

/** 初始化对象
 
 @param delegate        -[in]委托对象
 */
- (id) initWithDelegate:(id<IFlySpeechUserDelegate>) delegate __attribute__((deprecated));

/** 登陆接口
 
 此接口为用户登陆的接口，在上传用户数据时，您必须先登陆，登陆只进行一次即可，登陆为异步的过程，在这个过程中，您不可以将这个对象释放掉 注意看开发文档，这样会极大的节省您的时间，如有什么问题可以发邮件到msp_support@iflytek.com，我们很乐意帮助您。
 
 @param   user        -[in] 用户名，此用户名为您在语音云论坛中申请的账号,为nil就表明为匿名登陆
 @param   pwd         -[in] 密码，密码为您在语音云论坛中申请的账号，当user为空时，pwd自动被置为nil
 @param   param       -[in] 登陆的参数，具体参数可以参考用户手册
 */
- (IFlySpeechError *) login:(NSString *) user pwd:(NSString *)pwd param:(NSString *) param;

/** 退出登陆接口
 MSPLogout 应当在应用程序退出时仅调用一次。
 */
-(void) logout;

/** 登陆接口
 
 此接口为用户登陆的接口，在上传用户数据时，您必须先登陆，登陆只进行一次即可，登陆为**同步**的过程，在这个过程中如果您用此方法进行登陆,onEnd接口将不会被调用
 
 @param   user        -[in] 用户名，此用户名为您在语音云论坛中申请的账号,为nil就表明为匿名登陆
 @param   pwd         -[in] 密码，密码为您在语音云论坛中申请的账号，当user为空时，pwd自动被置为nil
 @param   param       -[in] 登陆的参数，具体参数可以参考用户手册
 */
- (IFlySpeechError *) synchronousLogin:(NSString *)user pwd:(NSString *)pwd param:(NSString *) param __attribute__((deprecated));

/** 是否登陆成功
 
 @return  成功返回YES，失败返回NO
 */
- (BOOL) isLogin;

/** 是否登陆成功
 
 当您已经将登陆对象释放时，如果您想获取是否已经登陆，可以用此方法。
 
 @return  成功返回YES，失败返回NO
 */
+ (BOOL) isLogin;

@property(nonatomic,copy) NSString *user;
@property(nonatomic,copy) NSString *pwd;
@property(nonatomic,copy) NSString *param;


@end
