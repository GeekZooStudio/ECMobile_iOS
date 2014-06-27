//
//  H0_BrowserBoard_iPhone.m
//  ActionInChina
//
//  Created by QFish on 4/16/13.
//  Copyright (c) 2013 GeekZoo. All rights reserved.
//

#import "AppBoard_iPhone.h"
#import "H0_BrowserBoard_iPhone.h"

#pragma mark -

@implementation H0_BrowserBoard_iPhone
{
	BOOL _showLoading;
    UIToolbar * _toolbar;
    
    UIBarButtonItem * _back;
    UIBarButtonItem * _stop;
    UIBarButtonItem * _forward;
    UIBarButtonItem * _refresh;
    UIBarButtonItem * _flexible;
	UIBarButtonItem * _fixed;
}

DEF_SINGLETON( H0_BrowserBoard_iPhone )

@synthesize showLoading = _showLoading;
@synthesize useHTMLTitle = _useHTMLTitle;

@synthesize toolbar = _toolbar;
@synthesize defaultTitle = _defaultTitle;

@synthesize backBoard = _backBoard;

- (void)load
{
	self.showLoading = YES;
	self.isToolbarHiden = NO;
}

- (void)unload
{
	self.htmlString = nil;
	self.urlString = nil;
	self.defaultTitle = nil;
}

#pragma mark -

ON_CREATE_VIEWS( signal )
{
    self.view.backgroundColor = HEX_RGB( 0xdfdfdf );
    
    [self showNavigationBarAnimated:NO];
    [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav_back.png"]];
    
    if ( self.defaultTitle && self.defaultTitle.length )
    {
        self.navigationBarTitle = self.defaultTitle;
    }
    else
    {
        self.navigationBarTitle = @"浏览器";
    }
    
    _webView = [[BeeUIWebView alloc] init];
    _webView.scalesPageToFit = YES;
    [self.view addSubview:_webView];
    
    if ( !_isToolbarHiden )
    {
        _toolbar = [[UIToolbar alloc] init];
        _toolbar.autoresizesSubviews = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        _toolbar.backgroundColor = [UIColor clearColor];
        _toolbar.tintColor = [UIColor grayColor];
        _toolbar.translucent = YES;
        
        [self.view addSubview:_toolbar];
    }
    
    [self setupToolbar];
    [self updateUI];
}

ON_DELETE_VIEWS( signal )
{
    [self.webView stopLoading];
    
    SAFE_RELEASE( _back );
    SAFE_RELEASE( _stop );
    SAFE_RELEASE( _forward );
    SAFE_RELEASE( _refresh );
    SAFE_RELEASE( _urlString );
    
    SAFE_RELEASE( _flexible );
    SAFE_RELEASE( _fixed );
    
    SAFE_RELEASE_SUBVIEW( _webView );

}

ON_LAYOUT_VIEWS( signal )
{
    if ( _isToolbarHiden )
    {
        _webView.frame = self.view.bounds;
    }
    else
    {
        int toolbarHeight = 44.0f;
        
        CGRect frame = self.view.frame;
        frame.size.height -= toolbarHeight;
        if ( IOS7_OR_EARLIER )
        {
            frame.origin.y = 0;
        }
        _webView.frame = frame;
        
        frame.origin.y += frame.size.height;
        frame.size.height = toolbarHeight;
        _toolbar.frame = frame;
    }
}

ON_WILL_APPEAR( signal )
{
}

ON_DID_APPEAR( signal )
{
    if ( self.firstEnter )
    {
        [self refresh];
        
        self.firstEnter = NO;
    }
}

ON_WILL_DISAPPEAR( signal )
{
}

ON_DID_DISAPPEAR( signal )
{
    
}

#pragma mark -

ON_LEFT_BUTTON_TOUCHED( signal )
{
	if ( self.backBoard )
	{
		[self.stack popToBoard:self.backBoard animated:YES];
	}
	else
	{
		[self.stack popBoardAnimated:YES];
	}
}

ON_RIGHT_BUTTON_TOUCHED( signal )
{
}

#pragma mark - BeeUIWebView

ON_SIGNAL3( BeeUIWebView, DID_START, signal )
{
	[self updateUI];

	if ( _showLoading )
	{
		BeeUIActivityIndicatorView * activity = [BeeUIActivityIndicatorView spawn];
		[activity startAnimating];
		[activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
		[self showBarButton:BeeUINavigationBar.RIGHT custom:activity];
	}
}

ON_SIGNAL3( BeeUIWebView, DID_LOAD_FINISH, signal )
{
    [self updateUI];
    
    if ( _showLoading )
    {
        [self dismissTips];
        [self hideBarButton:BeeUINavigationBar.RIGHT];
    }
}

ON_SIGNAL3( BeeUIWebView, DID_LOAD_CANCELLED, signal )
{
    [self updateUI];
    
    if ( _showLoading )
    {
        [self dismissTips];
        [self hideBarButton:BeeUINavigationBar.RIGHT];
    }
}

ON_SIGNAL3( BeeUIWebView, DID_LOAD_FAILED, signal )
{
    [self updateUI];
    
    if ( _showLoading )
    {
        [self dismissTips];
        [self hideBarButton:BeeUINavigationBar.RIGHT];
        
        [self presentFailureTips:__TEXT(@"error_network")];
    }
}

#pragma mark -

- (void)refresh
{
	if ( self.htmlString )
	{
		self.webView.html = self.htmlString;
	}
	else if ( self.urlString )
	{
		self.webView.url = self.urlString;
	}
	else if ( self.webView.loadingURL && self.webView.loadingURL.length )
	{
		self.webView.url = self.webView.loadingURL;
	}
}

- (void)updateUI
{
	if ( self.useHTMLTitle )
	{
		NSString * title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
		if ( title && title.length )
		{
			self.navigationBarTitle = title;
		}
	}
	
	_back.enabled = self.webView.canGoBack;
	_forward.enabled = self.webView.canGoForward;
		
	if ( _webView.loading )
	{
        [_toolbar setItems:@[ _flexible, _back, _flexible, _forward, _flexible, _flexible, _flexible, _stop, _flexible ] animated:NO];
    }
    else
    {
        [_toolbar setItems:@[ _flexible, _back, _flexible, _forward, _flexible, _flexible, _flexible, _refresh , _flexible] animated:NO];
    }
}

#pragma mark -

- (void)setupToolbar
{
    _flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    _fixed = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	
    _back = \
    [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"browser_baritem_back.png"]
                                     style:UIBarButtonItemStylePlain
                                    target:self.webView
                                    action:@selector(goBack)];
    
    _forward = \
    [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"browser_baritem_forward.png"]
                                     style:UIBarButtonItemStylePlain
                                    target:self.webView
                                    action:@selector(goForward)];
    
    _refresh = \
    [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"browser_baritem_refresh.png"]
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(refresh)];

    _stop = \
    [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"browser_baritem_stop.png"]
                                     style:UIBarButtonItemStylePlain
                                    target:self.webView
                                    action:@selector(stopLoading)];
    
}
@end
