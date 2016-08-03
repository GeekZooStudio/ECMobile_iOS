//
//  H0_BrowserBoard_iPhone.h
//  ActionInChina
//
//  Created by QFish on 4/16/13.
//  Copyright (c) 2013 GeekZoo. All rights reserved.
//

#import "Bee.h"
@interface H0_BrowserBoard_iPhone : BeeUIBoard<UIWebViewDelegate>

AS_SINGLETON( H0_BrowserBoard_iPhone )

@property (nonatomic, assign) BOOL				showLoading;
@property (nonatomic, assign) BOOL				useHTMLTitle;
@property (nonatomic, copy)NSString*            URLJudge;
@property (nonatomic, retain) UIToolbar *		toolbar;
@property (nonatomic, retain) BeeUIWebView *	webView;
@property (nonatomic, copy) NSString *			urlString;
@property (nonatomic, copy) NSString *          htmlString;
@property (nonatomic, copy) NSString *			defaultTitle;
@property (nonatomic, copy) NSString *          payString;

@property (nonatomic, assign) BOOL              isToolbarHiden;

@property (nonatomic, assign) id				backBoard;

- (void)refresh;

@end
