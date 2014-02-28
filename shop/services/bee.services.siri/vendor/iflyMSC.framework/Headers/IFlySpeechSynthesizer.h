//
//  IFlySpeechSynthesizer.h
//  MSC
//
//  Created by iflytek on 13-3-21.
//  Copyright (c) 2013年 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IFlySpeechSynthesizerDelegate.h"

@class IFlyMscSynthesizer;

@interface IFlySpeechSynthesizer : NSObject<IFlySpeechSynthesizerDelegate>
{
    IFlyMscSynthesizer                  *_mscSynthesizer;
    id<IFlySpeechSynthesizerDelegate>   _delegate;
}

@property(assign) id<IFlySpeechSynthesizerDelegate> delegate;

/**
 * @fn      createWithParams
 * @brief   初始化对象
 *
 * @param   params          -[in] 初始化的参数
 * @params  delegate        -[in] 委托对象
 * @see
 */
+ (IFlySpeechSynthesizer *) createWithParams:(NSString *) params delegate:(id<IFlySpeechSynthesizerDelegate>)delegate;

/**
 * @fn      getSpeechSynthesizer
 * @brief   获取合成对象
 *
 * @return  合成对象
 * @see
 */
+ (IFlySpeechSynthesizer *) getSpeechSynthesizer;

/**
 * @fn      startSpeaking
 * @brief   开始播放音频
 * 
 * @param   text            -[in] 播放的文本
 * @see
 */
- (void) startSpeaking:(NSString *)text;

/**
 * @fn      pauseSpeaking
 * @brief   暂停播放音频
 *
 * @see
 */
- (void) pauseSpeaking;

/**
 * @fn      resumeSpeaking
 * @brief   恢复播放音频
 *
 * @see
 */
- (void) resumeSpeaking;


/**
 * @fn      stopSpeaking
 * @brief   取消本次合成
 *
 * @see
 */
- (void) stopSpeaking;

/**
 * @fn      setParameter
 * @brief   设置引擎参数
 * 
 * key的取值参考:
 *          speed:语速(0 ~ 100)
 *          volume:音量(0 ~ 100)
 *          voice_name:发音人，具体参照开发文档
 *
 * @return  成功返回YES,失败返回NO
 
 * @param   key             -[in] 参数名称
 * @param   value           -[in] 参数值
 * @see
 */
-(BOOL) setParameter:(NSString *)key  value:(NSString *) value;

@end
