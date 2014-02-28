//
//  IFlyDataUploader.h
//  MSC

//  descrption: 数据上传类

//  Created by iflytek on 13-4-8.
//  Copyright (c) 2013年 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IFlySpeechError.h"
#import "IFlySpeechUser.h"

@class IFlyDataUploader;

@protocol   IFlyDataUploaderDelegate<NSObject>
/**
 * @fn      onEnd
 * @brief   上传结束回调
 *
 * 当有错误发生的时候grammerid为nil;不是所有的上传类型都会返回grammerid,具体请参考开发手册
 * 注意看开发文档，这样会极大的节省您的时间，如有什么问题可以发邮件到msp_support@iflytek.com
 * 或者ypzhao@iflytek.com;我们很乐意帮助您。
 *
 * @param   uploader        -[out] IFlyDataUploader对象，你可以在此释放这个对象
 * @param   grammerID       -[out] 返回上传的语法id
 * @param   error           -[out] 错误对象
 */
- (void) onEnd:(IFlyDataUploader*) uploader grammerID:(NSString *)grammerID error:(IFlySpeechError *)error;

@end

@interface IFlyDataUploader : NSObject<IFlySpeechUserDelegate>
{
    IFlySpeechUser                     *_iFlySpeechUser;
    id<IFlyDataUploaderDelegate>        _delegate;
    int                                 _error;
}

@property(nonatomic,copy) NSString *dataName;
@property(nonatomic,copy) NSString *params;
@property(nonatomic,copy) NSString *data;

/**
 * @fn      initWithDelegate
 * @brief   初始化对象
 *
 * &&&& 如果您在此将params设置为nil,则在上传之前不自动登陆，
 * 那么您必须使用IFlySpeechUser自行登陆&&&&
 *
 * @param   delegate    -[in] 委托对象
 * @param   user        -[in] 用户名，此用户名为您在语音云论坛中申请的账号,为nil就表明为匿名登陆
 * @param   pwd         -[in] 密码，密码为您在语音云论坛中申请的账号，当user为空时，pwd自动被置为nil
 * @param   params      -[in] 登陆的参数，具体参数可以参考用户手册
 * @see
 */
- (id) initWithDelegate:(NSString *)user pwd:(NSString *)pwd params:(NSString *) params delegate:(id<IFlyDataUploaderDelegate>) delegate;

/**
 * @fn      uploadData
 * @brief   上传数据
 *
 * 此函数为数据上传类，上传的过程是异步的，在上传过程中不能将这个对象释放掉
 *
 * @return
 * @param   name        -[in] 上传的内容名称，名称最好和你要上传的数据内容相关,不可以为nil
 * @param   params      -[in] 上传的参数,不可以为nil
 * @param   data        -[in] 上传的数据，以utf8编码,,不可以为nil
 * @see
 */
- (void) uploadData:(NSString *)name params:(NSString *) params data:(NSString *)data;

@end
