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
	
#import "GoodsCommentBoard_iPhone.h"
#import "AppBoard_iPhone.h"
#import "CommonWaterMark.h"

#pragma mark -

@implementation GoodsCommentCell_iPhone

SUPPORT_RESOURCE_LOADING( YES )

- (void)layoutDidFinish
{
    $(@".comment-wrapper-bg").view.frame = CGRectMake(10, 0, self.width - 20, self.height );
}

- (void)load
{
    [super load];
}

- (void)dataDidChanged
{
    COMMENT * comment = self.data;
    if ( comment )
    {
        $(@"#comment-creator").TEXT( [NSString stringWithFormat:@"%@:", comment.author] );
        $(@"#comment-date").TEXT([[comment.create asNSDate] timeAgo]);
        $(@"#comment-content").TEXT(comment.content);
    }
}

@end

#pragma mark -

@interface GoodsCommentBoard_iPhone()
{
	BeeUIScrollView * _scroll;
}
@end

#pragma mark -

@implementation GoodsCommentBoard_iPhone

- (void)load
{
    [super load];
    
    self.commentModel = [[[CommentModel alloc] init] autorelease];
    [self.commentModel addObserver:self];
}

- (void)unload
{
    [self.commentModel removeObserver:self];
    self.commentModel = nil;
    
    [super unload];
}

#pragma mark -

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        self.titleString = __TEXT(@"gooddetail_commit");
        [self showNavigationBarAnimated:NO];
        [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav-back.png"]];
        
		_scroll = [[BeeUIScrollView alloc] init];
		_scroll.dataSource = self;
        _scroll.baseInsets = UIEdgeInsetsMake(10, 0, 10, 0);
        [_scroll showHeaderLoader:YES animated:NO];
		[_scroll showFooterLoader:YES animated:NO];
		[self.view addSubview:_scroll];
    }
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
		SAFE_RELEASE_SUBVIEW( _scroll );
	}
	else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{
		_scroll.frame = self.viewBound;
	}
    else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
    {

    }
    else if ( [signal is:BeeUIBoard.FREE_DATAS] )
    {
    }
    else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
    {
        [self.commentModel prevPageFromServer];
		[_scroll reloadData];

		[[AppBoard_iPhone sharedInstance] setTabbarHidden:YES];
    }
    else if ( [signal is:BeeUIBoard.DID_APPEAR] )
    {
    }
    else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
    {
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

ON_SIGNAL2( BeeUINavigationBar, signal )
{
	[super handleUISignal:signal];

    if ( [signal is:BeeUINavigationBar.LEFT_TOUCHED] )
    {
        [self.stack popBoardAnimated:YES];
    }
    else if ( [signal is:BeeUINavigationBar.RIGHT_TOUCHED] )
    {
        
    }
}

ON_SIGNAL2( BeeUIScrollView, signal )
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIScrollView.HEADER_REFRESH] )
	{
		[self.commentModel prevPageFromServer];
	}
	else if ( [signal is:BeeUIScrollView.REACH_BOTTOM] )
	{
		[self.commentModel nextPageFromServer];
	}
}

#pragma mark -

- (void)handleMessage:(BeeMessage *)msg
{
	if ( [msg is:API.comments] )
	{
        if ( msg.sending )
        {
            if ( NO == self.commentModel.loaded )
            {
                [self presentLoadingTips:__TEXT(@"tips_loading")];
            }
			else
			{
				[_scroll setFooterLoading:msg.sending];
				[_scroll setHeaderLoading:msg.sending];
			}
        }
        else
        {
			[_scroll setFooterLoading:NO];
			[_scroll setHeaderLoading:NO];

            [self dismissTips];
        }
        
		if ( msg.succeed )
		{
			[_scroll asyncReloadData];
        }
        else if( msg.failed )
        {
			[ErrorMsg presentErrorMsg:msg inBoard:self];
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
	if ( _commentModel.loaded && 0 == _commentModel.comments.count )
	{
		return 1;
	}

	return 1;
}

- (NSInteger)numberOfViewsInScrollView:(BeeUIScrollView *)scrollView
{
	if ( _commentModel.loaded && 0 == _commentModel.comments.count )
	{
		return 1;
	}

	return self.commentModel.comments.count;
}

- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index scale:(CGFloat)scale
{
	if ( _commentModel.loaded && 0 == _commentModel.comments.count )
	{
		return [scrollView dequeueWithContentClass:[NoResultCell class]];
	}

	GoodsCommentCell_iPhone * cell = [scrollView dequeueWithContentClass:[GoodsCommentCell_iPhone class]];
    
    int cellCount = self.commentModel.comments.count;
    
    if ( cellCount == 1 )
    {
        $(cell).FIND(@".comment-wrapper-bg").IMAGE(@"cell-bg-single.png");
    }
    else
    {
        if ( index == 0 )
        {
            $(cell).FIND(@".comment-wrapper-bg").IMAGE( [UIImage imageNamed:@"cell-bg-header.png"].stretched );
        }
        else if ( index == (cellCount - 1) )
        {
            $(cell).FIND(@".comment-wrapper-bg").IMAGE( [UIImage imageNamed:@"cell-bg-footer.png"].stretched );
        }
        else
        {
            $(cell).FIND(@".comment-wrapper-bg").IMAGE( [UIImage imageNamed:@"cell-bg-content.png"].stretched );
        }
    }
    
	cell.data = [self.commentModel.comments objectAtIndex:index];
    
	return cell;
}

- (CGSize)scrollView:(BeeUIScrollView *)scrollView sizeForIndex:(NSInteger)index
{
	if ( _commentModel.loaded && 0 == _commentModel.comments.count )
	{
		return self.size;
	}

	id data = [self.commentModel.comments objectAtIndex:index];
    CGSize size = [GoodsCommentCell_iPhone estimateUISizeByWidth:self.viewWidth forData:data];
	return size;
}

@end
