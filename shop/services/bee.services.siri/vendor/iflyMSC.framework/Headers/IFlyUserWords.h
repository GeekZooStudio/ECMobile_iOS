//
//  UserWords.h
//  MSC
//
//  description: 用户词表类，获取用户词表是为了更好的语音识别(sms)，用户词表也属于个性化的一部分

//  Created by ypzhao on 13-2-26.
//  Copyright (c) 2013年 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IFlyUserWords  : NSObject
{
    NSMutableDictionary     *_jsonDictionary;
}

- (id) initWithJson:(NSString *)json;

/**
 * @fn      toString
 * @brief   将数据转化为上传的数据格式
 *
 * @return  NSString *      -没有数据或者格式不对时返回nil
 * @see
 */
- (NSString *) toString;

/**
 * @fn      getWords
 * @brief   返回key对应的数据
 *
 * @return  NSArray *       -没有数据或者格式不对时返回nil
 * @param   NSString *key   -key
 * @see
 */
- (NSArray *) getWords: (NSString *) key;

/**
 * @fn      putWord
 * @brief   添加一条数据
 *
 * @return  BOOL            -成功返回YES,失败返回NO
 * @param   NSString *key   -数据对应的key
 * @param   NSString *value -上传的数据
 * @see
 */
- (BOOL) putWord: (NSString *) key value:(NSString *)value;

/**
 * @fn      putWords
 * @brief   添加一组数据
 *
 * @return  BOOL            -成功返回YES,失败返回NO
 * @param   NSString *key   -数据对应的key
 * @param   NSArray *words  -上传的数据
 * @see
 */
- (BOOL) putwords: (NSString *) key words:(NSArray *)words;

/**
 * @fn      containsKey
 * @brief   是否包含key对应的数据
 *
 * @return  BOOL            -成功返回YES,失败返回NO
 * @see
 */
- (BOOL) containsKey: (NSString *) key;


@end
