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


@interface IFlySetting : NSObject

/**
 * @fn      getVersion
 * @brief   获取版本号
 * 
 * @return  版本号
 * @see
 */
+ (NSString *) getVersion;

/**
 * @fn      setLogFile
 * @brief   设置日志文件
 *
 * 只在初始化合成或者识别对象之前调用生效

 * 日志文件保存在应用程序的document目录下;
 * 软件发布时尽量不要保存日志，以免生成大量日志文件，如果发生网络连接等问题，
 * 可以在开发阶段将生成的日志文件发送到msp_support@iflytek.com获得支持
 *
 * @param   lvl             -[in] 日志等级
 * @see
 */
+ (void) setLogFile:(LOG_LEVEL) lvl;

/**
 * @fn      logLvl
 * @brief   获取日志等级
 * 
 * @return  返回日志等级
 */
+ (LOG_LEVEL) logLvl;


/**
 * @fn      showLogCat
 * @brief   是否打印控制台log
 * 
 * 在软件发布时，建议关闭此log;
 *
 * @param   showLog         -[in] YES,打印log;NO,不打印
 */
+ (void) showLogcat:(BOOL) showLog;

@end
