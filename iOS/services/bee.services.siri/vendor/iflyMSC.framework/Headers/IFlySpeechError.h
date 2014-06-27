//
//  IFlySpeechError.h
//  MSC
//  description: 错误描述类
//  Created by iflytek on 13-3-19.
//  Copyright (c) 2013年 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 错误描述类 */
@interface IFlySpeechError : NSObject
{
    int         _errorCode;
    int         _errorType;
}

/**
 * @fn      initWithError
 * @brief   初始化
 *
 * @param   errorCode           -[in] 错误码
 * @see
 */
+ (id) initWithError:(int) errorCode;

/**
 * @fn      errorCode
 * @brief   获取错误码
 *
 * @return  错误码
 * @see
 */
-(int) errorCode;

/**
 * @fn      errorDesc
 * @brief   获取错误描述
 *
 * @return  错误描述
 * @see
 */
- (NSString *) errorDesc;

@end
