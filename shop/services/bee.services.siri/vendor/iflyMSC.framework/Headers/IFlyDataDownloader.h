//
//  DataDownloader.h
//  msc
//
//  Created by iflytek on 13-3-3.
//  Copyright (c) 2013年 IFLYTEK. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol IFlyDataDownloaderDelegate

- (void) onIFlyDataDownloadEnd:(NSString *)result endCode:(int) endCode;
@end

@interface IFlyDataDownloader : NSObject
{
    int endCode;
}

- (void) dataDownLoader:(NSString *) params;

@property (assign) id<IFlyDataDownloaderDelegate> delegate;
@end
