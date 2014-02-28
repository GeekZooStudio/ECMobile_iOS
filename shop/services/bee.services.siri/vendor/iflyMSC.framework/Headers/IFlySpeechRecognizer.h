//
//  IFlySpeechRecognizer.h
//  MSC
//
//  Created by iflytek on 13-3-19.
//  Copyright (c) 2013年 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IFlySpeechRecognizerDelegate.h"
#import "IFlySpeechError.h"

@class IFlyMscRecognizer;

@interface IFlySpeechRecognizer : NSObject<IFlySpeechRecognizerDelegate>
{
    IFlyMscRecognizer                       *_mscer;
    
    id<IFlySpeechRecognizerDelegate>       _delegate;
}

@property(assign) id<IFlySpeechRecognizerDelegate> delegate ;

/**
 * @fn      createRecognizer
 * @brief   创建对象
 *
 * 整个语音识别对象是一个单类，开发者只需要创建一次，不可多次创建
 *
 * @param   params              -[in] 初始化参数
 * @see
 */
+ (id) createRecognizer:(NSString *)params delegate:(id<IFlySpeechRecognizerDelegate>) delegate;

/**
 * @fn      getRecognizer
 * @brief   获取对象
 *
 * @return  识别对象
 * @see
 */
+ (IFlySpeechRecognizer *) getRecognizer;


/**
 * @fn      setParameter
 * @brief   设置引擎参数
 * 
 * key的取值:
 *          domain:应用的领域,可设参数:iat,search,video,poi，music,asr
 *          vad_bos:vad前端点超时,可选范围:1000-10000(单位:ms),默认值：短信转写5000，其它4000
 *          vad_eos:vad后端点超时，可选范围:0-10000(单位:ms),默认值:短信转写1800,其它700
 *          sample_rate:采样率,16000或者8000
 * 更多取值请参考开发手册
 * @param   key                 -[in] 参数名称
 * @param   value               -[in] 参数的值
 * @see
 */
- (BOOL) setParameter:(NSString *) key value:(NSString *) value;

/**
 * @fn      startListening
 * @brief   开始识别
 * 
 * 同时只能进行一次识别，同时进行多路识别，会报网络繁忙错误。
 *
 * @see
 */
- (void) startListening;


/**
 * @fn      stopListening
 * @brief   停止录音，并开始获取结果
 *
 * @see
 */
- (void) stopListening;

/**
 * @fn      cancel
 * @brief   取消本次识别，调用次接口之后，整个会话过程并没有结束，在
 *          - (void) onError:(IFlySpeechError *) errorCode;函数被调用的时候，整个会话才会结束
 *
 * @see
 */
- (void) cancel;
@end
