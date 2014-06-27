//
//  UPPayPluginDelegate.h
//  UPPayDemo
//
//  Created by wang li on 12-2-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UPPayPluginDelegate <NSObject>
-(void)UPPayPluginResult:(NSString*)result;
@end
