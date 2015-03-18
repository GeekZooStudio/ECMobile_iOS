//
//  UMFeedback.h
//  UMFeedback
//
//  Created by ming hua on 2012-03-19.
//  Updated by ming hua on 2013-04-17.
//  Updated by cui guilin on 2014-09-12.
//  Version 1.4
//  Copyright (c) 2012年 umeng.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define UMFBCheckFinishedNotification @"UMFBCheckFinishedNotification"
#define UMFBWebViewDismissNotification @"UMFBWebViewDismissNotification"

#pragma mark - Feedback Data Delegate

@protocol UMFeedbackDataDelegate <NSObject>

@optional
/**
 *  trigger when fetch data from server
 *
 *  @param error
 */
- (void)getFinishedWithError: (NSError *)error;

/**
 *  trigger when post data to server is finished
 *
 *  @param error
 */
- (void)postFinishedWithError:(NSError *)error;

@end


#pragma mark - Feedback Object
@interface UMFeedback : NSObject

/**
 *  UMFeedback Data Delegate
 */
@property(nonatomic, unsafe_unretained) NSObject <UMFeedbackDataDelegate> *delegate;

/**
 *  the new replies
 */
@property(nonatomic, strong) NSMutableArray *theNewReplies;

/**
 *  the topic and replies
 */
@property(nonatomic, strong) NSMutableArray *topicAndReplies;

#pragma mark Settings

/**
 *  A Boolean value indicating whether the feedback log is printed(YES) or not (NO). The default value is NO.
 *
 *  @param value YES to print long while NO to do not print.
 */
+ (void)setLogEnabled:(BOOL)value;

+ (BOOL)feedbackLogEnabled;

/**
 *  set feedback app key. you can find out the app key at: http://www.umeng.com/apps/setting
 *
 *  @param appkey
 */
+ (void)setAppkey:(NSString *)appkey;

+ (NSString *)uuid;
+ (NSString *)messageType;

#pragma mark Show Feedback View

/**
 *  get the default feedback view controller
 *
 *  @return
 */
+ (UIViewController *)feedbackViewController;

/**
 *  get the default modal feedback view controller
 *
 *  @return
 */
+ (UIViewController *)feedbackModalViewController;


+ (void)didReceiveRemoteNotification:(NSDictionary *)userInfo;

#pragma mark Umeng Feedback Data Api

/**
 *  the UMFeedback singleton
 *
 *  @return
 */
+ (UMFeedback *)sharedInstance;

/**
 *  get feedback replies from server
 */
- (void)get;

/**
 *  post feedback repli to server
 *
 *  @param feedback_dictionary <#feedback_dictionary description#>
 */
- (void)post:(NSDictionary *)feedback_dictionary;

// set custom remark info
/**
 *  set custom user info
 *
 *  @param remarkInfo custom user info
 */
- (void)setRemarkInfo:(NSDictionary *)remarkInfo;

- (void)updateUserInfo:(NSDictionary *)info;
- (NSDictionary *)getUserInfo;

// 不建议使用的

+ (void)showFeedback:(UIViewController *)viewController withAppkey:(NSString *)appKey;
+ (void)showFeedback:(UIViewController *)viewController withAppkey:(NSString *)appKey dictionary:(NSDictionary *)dictionary;
+ (void)checkWithAppkey:(NSString *)appkey;
- (void)setAppkey:(NSString *)appKey delegate:(id<UMFeedbackDataDelegate>)newDelegate;

@end