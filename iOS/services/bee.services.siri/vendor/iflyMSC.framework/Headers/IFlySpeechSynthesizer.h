//
//  IFlySpeechSynthesizer.h
//  MSC
//
//  Created by ypzhao on 13-3-21.
//  Copyright (c) 2013年 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IFlySpeechSynthesizerDelegate.h"

/** 语音合成  */

@interface IFlySpeechSynthesizer : NSObject<IFlySpeechSynthesizerDelegate>

/** 设置识别的委托对象 */
@property(assign) id<IFlySpeechSynthesizerDelegate> delegate;

/** 创建合成对象
 
 使用示例如下:
<pre><code>NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@,timeout=%@",APPID,TIMEOUT];
_iFlySpeechSynthesizer = [IFlySpeechSynthesizer createWithParams: initString delegate:self];
[initString release];
</code></pre>
 
 合成对象是单类,创建之后无需释放。params的参数取值如下:
 
 1. appid：应用程序ID (必选)。ID为您在语音云平台申请的appid。appid与iflyMSC.framework一一对应，不能混用
 2. timeout：网络超时时间，单位:ms，默认为20000，范围0-30000 (可选)
 3. usr：用户名，开发者在开发者网站上注册的用户名
 4. pwd：用户密码，开发者在开发者网站上的用户密码
 5. server_url：默认连接语音云公网入口 http://dev.voicecloud.cn/index.htm，只有特定业务才需要设 置为固定ip或域名，普通开发者不需要设置
 6. besturl_search：默认为1，如果server_url设置为固定ip地址，需要将此参数设置为0，表示不寻找最佳服务器。如果 server_url为域名，可以将此参数设置为1
 
 @param params 初始化参数
 @param delegate 委托对象
 */
+ (IFlySpeechSynthesizer *) createWithParams:(NSString *) params delegate:(id<IFlySpeechSynthesizerDelegate>)delegate;

/** 获取合成对象
 
 @return 合成对象
 */
+ (IFlySpeechSynthesizer *) getSpeechSynthesizer;

/** 设置合成参数
 
 设置参数需要在调用startSpeaking:之前进行。
 
 参数的名称和取值：
 
 1. speed：合成语速,取值范围 0~100
 2. volume：合成的音量,取值范围 0~100
 3. voice_name：默认为”xiaoyan”；可以设置的参数列表可参考个性化发音人列表
 4. sample_rate：目前支持的采样率有 16000 和 8000
 5. tts_audio_path：音频文件名 设置此参数后，将会自动保存合成的音频文件。路径为Documents/(指定值)。不设置或者设置为nil，则不保存音频。
 6. params：扩展参数
 
 @param key  合成参数
 @param value 参数取值
 @return 设置成功返回YES，失败返回NO
 */
-(BOOL) setParameter:(NSString *)key  value:(NSString *) value;

/** 开始合成
 
 调用此函数进行合成，如果发生错误会回调错误`onCompleted`
 
 @param text 合成的文本,最大的字节数为1k
 */
- (void) startSpeaking:(NSString *)text;

/** 暂停播放
 
 暂停播放之后，合成不会暂停，仍会继续，如果发生错误则会回调错误`onCompleted`
 */
- (void) pauseSpeaking;

/** 恢复播放 */
- (void) resumeSpeaking;


/** 停止播放并停止合成 */
- (void) stopSpeaking;


@end
