//
//  IFlySetting.h
//  MSC
//
//  Created by iflytek on 13-4-12.
//  Copyright (c) 2013年 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _LOG_LEVEL {                                 // 日志打印等级
    LVL_ALL                 = -1,                         // 全部打印
    LVL_DETAIL              = 31,                         // 高，异常分析需要的级别
    LVL_NORMAL              = 15,                         // 中，打印基本日志信息
    LVL_LOW                 = 7,                          // 低，只打印主要日志信息
    LVL_NONE                = 0                           // 不打印
}LOG_LEVEL;

/**
 此接口为iflyMSC sdk 配置接口。
  可以获取版本号，设置日志打印等级等
 */
@interface IFlySetting : NSObject

/** 获取版本号
 
 @return 版本号
 */
+ (NSString *) getVersion;

/** 设置日志文件
 
 只在初始化合成或者识别对象之前调用生效
 
 日志文件保存在应用程序的document目录下;软件发布时尽量不要保存日志，以免生成大量日志文件，如果发生网络连接等问题，可以在开发阶段将生成的日志文件发送到msp_support@iflytek.com获得支持。
 <table>
 <thead>
 <tr><th>*日志打印等级</th><th><em>描述</em></th>
 </tr>
 </thead>
 <tbody>
 <tr><td>LVL_ALL</td><td>全部打印</td></tr>
 <tr><td>LVL_DETAIL</td><td>高，异常分析需要的级别</td></tr>
 <tr><td>LVL_NORMAL</td><td>中，打印基本日志信息</td></tr>
 <tr><td>LVL_LOW</td><td>低，只打印主要日志信息</td></tr>
 <tr><td>LVL_NONE</td><td>不打印</td></tr>
 </tbody>
 </table>

 @param   lvl             -[in] 日志等级
 */
+ (void) setLogFile:(LOG_LEVEL) lvl;

/** 获取日志等级

 @return  返回日志等级
 */
+ (LOG_LEVEL) logLvl;


/** 是否打印控制台log

 在软件发布时，建议关闭此log。
 
 @param   showLog         -[in] YES,打印log;NO,不打印
 */
+ (void) showLogcat:(BOOL) showLog;

@end
