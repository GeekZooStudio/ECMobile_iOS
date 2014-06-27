//
//  UPPayPluginEx.h
//  UPPayPluginEx
//
//  Created by wxzhao on 12-10-10.
//  Copyright (c) 2012年 China UnionPay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UPPayPluginDelegate.h"

@interface UPPayPlugin : NSObject

+ (BOOL)startPay:(NSString*)tn mode:(NSString*)mode viewController:(UIViewController*)viewController delegate:(id<UPPayPluginDelegate>)delegate;


@end
