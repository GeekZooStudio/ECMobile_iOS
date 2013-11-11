/*
 *                                                                          
 *       _/_/_/                      _/        _/_/_/_/_/                     
 *    _/          _/_/      _/_/    _/  _/          _/      _/_/      _/_/    
 *   _/  _/_/  _/_/_/_/  _/_/_/_/  _/_/          _/      _/    _/  _/    _/   
 *  _/    _/  _/        _/        _/  _/      _/        _/    _/  _/    _/    
 *   _/_/_/    _/_/_/    _/_/_/  _/    _/  _/_/_/_/_/    _/_/      _/_/       
 *                                                                          
 *
 *  Copyright 2013-2014, Geek Zoo Studio
 *  http://www.ecmobile.cn/license.html
 *
 *  HQ China:
 *    2319 Est.Tower Van Palace 
 *    No.2 Guandongdian South Street 
 *    Beijing , China
 *
 *  U.S. Office:
 *    One Park Place, Elmira College, NY, 14901, USA
 *
 *  QQ Group:   329673575
 *  BBS:        bbs.ecmobile.cn
 *  Fax:        +86-10-6561-5510
 *  Mail:       info@geek-zoo.com
 */
	
#import "SearchBoard_iPhone.h"
#import "CategoryBoard_iPhone.h"
#import "GoodsListBoard_iPhone.h"
#import "AppBoard_iPhone.h"
#import "BaseBoard_iPhone.h"

#import "model.h"

#pragma mark -

@implementation SearchRecoder_iPhone

SUPPORT_RESOURCE_LOADING( YES )
SUPPORT_AUTOMATIC_LAYOUT( YES )

@end

#pragma mark -

@implementation SearchCategory_iPhone

SUPPORT_RESOURCE_LOADING( YES )
SUPPORT_AUTOMATIC_LAYOUT( YES )

- (void)dataDidChanged
{
	NSObject * obj = self.data;
	
	if ( [obj isKindOfClass:[TOP_CATEGORY class]] )
	{
		TOP_CATEGORY * category = (TOP_CATEGORY *)obj;
		if ( category )
		{
			$(@"#title").DATA( category.name );
			
//			if ( category.children && category.children.count )
//			{
				$(@"#arrow").SHOW();
//			}
//			else
//			{
//				$(@"#arrow").HIDE();
//			}
		}
	}
	else if ( [obj isKindOfClass:[CATEGORY class]] )
	{
		CATEGORY * category = (CATEGORY *)obj;
		if ( category )
		{
			$(@"#title").DATA( category.name );
			$(@"#arrow").HIDE();
		}		
	}
}

@end

#pragma mark -

@implementation SearchInput_iPhone

SUPPORT_RESOURCE_LOADING( YES )
SUPPORT_AUTOMATIC_LAYOUT( YES )

@end

#pragma mark -

@interface SearchBoard_iPhone()
{
	BeeUIScrollView *		_scroll;
    SearchInput_iPhone *    _titleSearch;
    SearchRecoder_iPhone *    _voiceSearch;
	
	NSTimer *				_timer;
}
@end

#pragma mark -

@implementation SearchBoard_iPhone

- (void)load
{
	[[SearchCategoryModel sharedInstance] addObserver:self];
	[[SearchModel sharedInstance] addObserver:self];
}

- (void)unload
{
	[[SearchCategoryModel sharedInstance] removeObserver:self];
	[[SearchModel sharedInstance] removeObserver:self];
}

#pragma mark -

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        [self showNavigationBarAnimated:NO];
        
		_scroll = [[BeeUIScrollView alloc] init];
		_scroll.dataSource = self;
		_scroll.vertical = YES;
		[self.view addSubview:_scroll];

	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
		[_timer invalidate];
		_timer = nil;

		SAFE_RELEASE_SUBVIEW( _scroll );
		SAFE_RELEASE_SUBVIEW( _titleSearch );
	}
	else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{
        _scroll.frame = CGRectMake( 0, 0, self.bounds.size.width, self.bounds.size.height - 40.0f );
	}
    else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
    {
    }
    else if ( [signal is:BeeUIBoard.FREE_DATAS] )
    {
    }
    else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
    {
        [[AppBoard_iPhone sharedInstance] setTabbarHidden:NO];
        
		if ( nil == _titleSearch )
		{
			_titleSearch = [[SearchInput_iPhone alloc] initWithFrame:CGRectZero];
			_titleSearch.frame = CGRectMake(0, 0, self.view.width, 44.0f);
			self.titleView = _titleSearch;
		}

		[[SearchCategoryModel sharedInstance] fetchFromServer];

		if ( [UserModel online] )
		{
			[[CartModel sharedInstance] fetchFromServer];
		}

		[_scroll asyncReloadData];
    }
    else if ( [signal is:BeeUIBoard.DID_APPEAR] )
    {
    }
    else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
    {
		[self dismissModalViewAnimated:YES];

        [[AppBoard_iPhone sharedInstance] setTabbarHidden:YES];
    }
    else if ( [signal is:BeeUIBoard.DID_DISAPPEAR] )
    {
    }
    else if ( [signal is:BeeUIBoard.ORIENTATION_WILL_CHANGE] )
    {
    }
    else if ( [signal is:BeeUIBoard.ORIENTATION_DID_CHANGED] )
    {
    }
}

ON_SIGNAL2( BeeUITextField, signal )
{
	[super handleUISignal:signal];
	
	BeeUITextField * textField = (BeeUITextField *)signal.source;
	
	if ( [signal is:BeeUITextField.RETURN] )
	{
		[textField endEditing:YES];

        [self doSearch:textField.text];
	}
}

- (void)doSearch:(NSString *)keyword
{    
    if ( 0 == keyword.length )
    {
//		[self presentFailureTips:@"请输入正确的关键字"];
        return;
    }
    
    GoodsListBoard_iPhone * board = [[[GoodsListBoard_iPhone alloc] init] autorelease];
    board.model1.filter.keywords = keyword;
    board.model2.filter.keywords = keyword;
    board.model3.filter.keywords = keyword;
    [self.stack pushBoard:board animated:YES];
}

ON_SIGNAL3( SearchInput_iPhone, open, signal )
{
	[super handleUISignal:signal];
	
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
		$(_titleSearch).FIND( @"#search-input" ).BLUR();
		
        _voiceSearch = [[[SearchRecoder_iPhone alloc] init] autorelease];
		_voiceSearch.frame = self.viewBound;
		
        [self presentModalView:_voiceSearch animated:YES];
		[self beginVoiceRecord];
    }
}

ON_SIGNAL3( SearchRecoder_iPhone, cancel, signal )
{
	[super handleUISignal:signal];
	
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
        [self dismissModalViewAnimated:YES];
        [self cancelVoiceRecording];
        self.isVoiceRecording = NO;
        _voiceSearch = nil;
    }
}

ON_SIGNAL3( SearchRecoder_iPhone, voice, signal )
{
	[super handleUISignal:signal];
	
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
		[self endVoiceRecording];
    }
}

ON_SIGNAL3( SearchCategory_iPhone, mask, signal )
{
	[super handleUISignal:signal];
	
	TOP_CATEGORY * category = signal.sourceCell.data;
	if ( category )
	{
		if ( category.children && category.children.count )
		{
			CategoryBoard_iPhone * board = [CategoryBoard_iPhone board];
			board.category = category;
			[self.stack pushBoard:board animated:YES];
		}
		else
		{
			GoodsListBoard_iPhone * board = [GoodsListBoard_iPhone board];
			board.category = category.name;
			board.model1.filter.category_id = category.id;
			board.model2.filter.category_id = category.id;
			board.model3.filter.category_id = category.id;
			[self.stack pushBoard:board animated:YES];
		}
	}
}

#pragma mark - IFlySpeechRecognizer

- (void)beginVoiceRecord
{
    [_timer invalidate];
	_timer = [NSTimer scheduledTimerWithTimeInterval:6.0f
											  target:self
											selector:@selector(onTimeout)
											userInfo:nil
											 repeats:NO];
}

- (void)onTimeout
{
	_timer = nil;
	
	[self endVoiceRecording];
}

- (void)endVoiceRecording
{
	[_timer invalidate];
	_timer = nil;
    
    [self dismissModalViewAnimated:YES];
}

- (void)cancelVoiceRecording
{
}

#pragma mark -

- (void)handleMessage:(BeeMessage *)msg
{
    [super handleMessage:msg];

	if ( [msg is:API.category] )
	{
		if ( msg.sending )
		{
			if ( NO == [SearchCategoryModel sharedInstance].loaded )
			{
//				[self presentLoadingTips:__TEXT(@"tips_loading")];
			}
		}
		else
		{
			[self dismissTips];
            [self dismissModalViewAnimated:YES];
		}

		if ( msg.succeed )
		{
			[_scroll asyncReloadData];
		}
	}
}

#pragma mark -

- (void)handleNotification:(NSNotification *)notification
{
    [super handleNotification:notification];
}

#pragma mark -

- (NSInteger)numberOfLinesInScrollView:(BeeUIScrollView *)scrollView
{
	return 1;
}

- (NSInteger)numberOfViewsInScrollView:(BeeUIScrollView *)scrollView
{
	return [SearchCategoryModel sharedInstance].topCategories.count;
}

- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index scale:(CGFloat)scale
{
	id data = [[SearchCategoryModel sharedInstance].topCategories objectAtIndex:index];
	
	SearchCategory_iPhone * cell = [scrollView dequeueWithContentClass:[SearchCategory_iPhone class]];
	cell.data = data;
	return cell;
}

- (CGSize)scrollView:(BeeUIScrollView *)scrollView sizeForIndex:(NSInteger)index
{
    id data = [[SearchCategoryModel sharedInstance].topCategories objectAtIndex:index];
	return [SearchCategory_iPhone estimateUISizeByBound:scrollView.bounds.size forData:data];
}

@end
