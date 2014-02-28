//
//                       __
//                      /\ \   _
//    ____    ____   ___\ \ \_/ \           _____    ___     ___
//   / _  \  / __ \ / __ \ \    <     __   /\__  \  / __ \  / __ \
//  /\ \_\ \/\  __//\  __/\ \ \\ \   /\_\  \/_/  / /\ \_\ \/\ \_\ \
//  \ \____ \ \____\ \____\\ \_\\_\  \/_/   /\____\\ \____/\ \____/
//   \/____\ \/____/\/____/ \/_//_/         \/____/ \/___/  \/___/
//     /\____/
//     \/___/
//
//  Powered by BeeFramework
//
	
#import "D0_SearchBoard_iPhone.h"
#import "D1_CategoryBoard_iPhone.h"
#import "B1_ProductListBoard_iPhone.h"
#import "AppBoard_iPhone.h"
#import "BaseBoard_iPhone.h"

#import "controller.h"
#import "model.h"

#import "D0_SearchRecoder_iPhone.h"
#import "D0_SearchCategory_iPhone.h"
#import "D0_SearchInput_iPhone.h"

#import "bee.services.siri.h"

#pragma mark -

@interface D0_SearchBoard_iPhone()
{
	NSTimer *	_timer;
}
@end

#pragma mark -

@implementation D0_SearchBoard_iPhone

SUPPORT_RESOURCE_LOADING( YES )
SUPPORT_AUTOMATIC_LAYOUT( YES )

DEF_OUTLET( BeeUIScrollView, list )

DEF_MODEL( SearchCategoryModel, searchCategoryModel )

- (void)load
{
	self.searchCategoryModel = [SearchCategoryModel modelWithObserver:self];
}

- (void)unload
{
	SAFE_RELEASE_MODEL( self.searchCategoryModel );
}

#pragma mark -

ON_CREATE_VIEWS( signal )
{
    [self showNavigationBarAnimated:NO];
    
    @weakify(self);
    
    self.list.lineCount = 1;
    self.list.animationDuration = 0.25f;
    
    self.list.whenReloading = ^
    {
        @normalize(self);
        
        self.list.total = self.searchCategoryModel.categories.count;
        
        for ( int i = 0; i < self.searchCategoryModel.categories.count; i++ )
        {
            BeeUIScrollItem * item = self.list.items[i];
            item.clazz = [D0_SearchCategory_iPhone class];
            item.size = CGSizeMake( self.list.width, 44 );
            item.data = [self.searchCategoryModel.categories safeObjectAtIndex:i];
            item.rule = BeeUIScrollLayoutRule_Tile;
        }
    };
}

ON_DELETE_VIEWS( signal )
{
    [_timer invalidate];
    _timer = nil;

    self.list = nil;
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
    [bee.ui.appBoard showTabbar];
    
	self.titleView = [[D0_SearchInput_iPhone alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 44.0f)];

    [self.searchCategoryModel reload];
    [[CartModel sharedInstance] reload];
    
    [self.list reloadData];
}

ON_DID_APPEAR( signal )
{
}

ON_WILL_DISAPPEAR( signal )
{
	bee.services.siri.STOP();
    
    [self dismissModalViewAnimated:YES];
    
    [bee.ui.appBoard hideTabbar];
}

ON_DID_DISAPPEAR( signal )
{
}

#pragma mark -

ON_LEFT_BUTTON_TOUCHED( signal )
{
}

ON_RIGHT_BUTTON_TOUCHED( signal )
{
}

#pragma mark - BeeUITextField

ON_SIGNAL2( BeeUITextField, signal )
{
	BeeUITextField * textField = (BeeUITextField *)signal.source;
	
	if ( [signal is:BeeUITextField.RETURN] )
	{
		[textField endEditing:YES];

        [self doSearch:textField.text];
	}
}

#pragma mark - D0_SearchInput_iPhone

/**
 * 搜索-语音，点击事件触发时执行的操作
 */
ON_SIGNAL3( D0_SearchInput_iPhone, open, signal )
{
    [self beginVoiceRecord];
}

#pragma mark - D0_SearchRecoder_iPhone

/**
 * 搜索-语音识别-取消，点击事件触发时执行的操作
 */
ON_SIGNAL3( D0_SearchRecoder_iPhone, cancel, signal )
{
    [self cancelVoiceRecording];
}

/**
 * 搜索-语音识别，点击事件触发时执行的操作
 */
ON_SIGNAL3( D0_SearchRecoder_iPhone, voice, signal )
{
    [self endVoiceRecording];
}

#pragma mark - D0_SearchCategory_iPhone

/**
 * 搜索-列表项，点击事件触发时执行的操作
 */
ON_SIGNAL3( D0_SearchCategory_iPhone, mask, signal )
{
	TOP_CATEGORY * category = signal.sourceCell.data;
	if ( category )
	{
		if ( category.children && category.children.count )
		{
			D1_CategoryBoard_iPhone * board = [D1_CategoryBoard_iPhone board];
			board.category = category;
			[self.stack pushBoard:board animated:YES];
		}
		else
		{
			B1_ProductListBoard_iPhone * board = [B1_ProductListBoard_iPhone board];
			board.category = category.name;
			board.searchByHotModel.filter.category_id = category.id;
			board.searchByCheapestModel.filter.category_id = category.id;
			board.searchByExpensiveModel.filter.category_id = category.id;
			[self.stack pushBoard:board animated:YES];
		}
	}
}

#pragma mark -

- (void)doSearch:(NSString *)keyword
{
	$(self.titleView).FIND( @"search-input" ).TEXT( keyword );

    if ( keyword.length )
	{
		B1_ProductListBoard_iPhone * board = [[[B1_ProductListBoard_iPhone alloc] init] autorelease];
		board.searchByHotModel.filter.keywords = keyword;
		board.searchByCheapestModel.filter.keywords = keyword;
		board.searchByExpensiveModel.filter.keywords = keyword;
		[self.stack pushBoard:board animated:YES];
	}
}

#pragma mark - IFlySpeechRecognizer

- (void)beginVoiceRecord
{
	ALIAS( bee.services.siri, siri );
	
	siri.whenStart = ^
	{
		[_timer invalidate];
		_timer = [NSTimer scheduledTimerWithTimeInterval:5.0f
												  target:self
												selector:@selector(onVoiceTimeout)
												userInfo:nil
												 repeats:NO];
		
		$(self.titleView).FIND( @"#search-input" ).BLUR();
		
		D0_SearchRecoder_iPhone * recorder = [[[D0_SearchRecoder_iPhone alloc] init] autorelease];
		if ( recorder )
		{
			recorder.frame = self.view.bounds;
			$(recorder).FIND(@"#voice-tips").TEXT( __TEXT(@"recording") );
			$(recorder).FIND(@"#voice").SELECT();
			[self presentModalView:recorder animated:YES];
		}
	};
	
	siri.whenFailed = ^
	{
		[_timer invalidate];
		_timer = nil;

		[self dismissModalViewAnimated:YES];
		[self presentFailureTips:__TEXT(@"failed_to_reco")];
	};

	siri.whenRecognized = ^
	{
		[_timer invalidate];
		_timer = nil;

		D0_SearchRecoder_iPhone * recorder = (D0_SearchRecoder_iPhone *)self.modalView;
		if ( recorder )
		{
			$(recorder).FIND(@"#voice-tips").TEXT( __TEXT(@"searching") );
			$(recorder).FIND(@"#voice").UNSELECT();
		}
		
		[self dismissModalViewAnimated:YES];

		NSMutableString * keywords = [NSMutableString string];
		
		for ( NSString * result in siri.results )
		{
			[keywords appendFormat:@"%@ ", result];
		}

		[self doSearch:keywords];
	};
	
	siri.whenCancelled = ^
	{
		[_timer invalidate];
		_timer = nil;

		[self dismissModalViewAnimated:YES];
	};
	
	siri.START();
}

- (void)endVoiceRecording
{
	[_timer invalidate];
	_timer = nil;
    
	bee.services.siri.STOP();
}

- (void)cancelVoiceRecording
{
	[_timer invalidate];
	_timer = nil;
	
	bee.services.siri.CANCEL();
}

- (void)onVoiceTimeout
{
	_timer = nil;
	
	bee.services.siri.STOP();
}

#pragma mark -

ON_MESSAGE3( API, category, msg )
{
	if ( msg.sending )
	{
		if ( NO == self.searchCategoryModel.loaded )
		{
			[self presentLoadingTips:__TEXT(@"tips_loading")];
		}
	}
	else
	{
		[self dismissTips];
		[self dismissModalViewAnimated:YES];
	}

	if ( msg.succeed )
	{
		[self.list asyncReloadData];
	}
}

@end
