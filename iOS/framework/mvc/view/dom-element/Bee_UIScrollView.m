//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//
//	Copyright (c) 2013-2014, {Bee} open source community
//	http://www.bee-framework.com
//
//
//	Permission is hereby granted, free of charge, to any person obtaining a
//	copy of this software and associated documentation files (the "Software"),
//	to deal in the Software without restriction, including without limitation
//	the rights to use, copy, modify, merge, publish, distribute, sublicense,
//	and/or sell copies of the Software, and to permit persons to whom the
//	Software is furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//	IN THE SOFTWARE.
//

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Bee_UIScrollView.h"
#import "Bee_UIPullLoader.h"
#import "Bee_UIFootLoader.h"
#import "UIView+BeeUISignal.h"
#import "UIView+LifeCycle.h"

#pragma mark -

#undef	MAX_LINES
#define MAX_LINES			(128)

#undef	MAX_QUEUED_ITEMS
#define	MAX_QUEUED_ITEMS	(32)

#undef	ANIMATION_DURATION
#define	ANIMATION_DURATION	(0.3f)

#pragma mark -

@interface BeeUIScrollItem()
{
	BOOL					_visible;
	NSInteger				_index;
	NSInteger				_line;
	NSInteger				_order;
	NSInteger				_columns;
	CGFloat					_scale;
	CGSize					_size;
	CGRect					_rect;
	Class					_clazz;
	id						_data;
	UIView *				_view;
	BeeUIScrollLayoutRule	_rule;
}

@property (nonatomic, assign) BOOL					visible;
@property (nonatomic, assign) NSInteger				line;
@property (nonatomic, assign) NSInteger				columns;
@property (nonatomic, assign) CGFloat				scale;
@property (nonatomic, assign) CGRect				rect;

@end

#pragma mark -

@implementation BeeUIScrollItem

@synthesize visible = _visible;
@synthesize	index = _index;
@synthesize line = _line;
@synthesize order = _order;
@synthesize columns = _columns;
@synthesize scale = _scale;
@synthesize	size = _size;
@synthesize rect = _rect;
@synthesize clazz = _clazz;
@synthesize data = _data;
@synthesize	view = _view;
@synthesize rule = _rule;

- (id)init
{
	self = [super init];
	if ( self )
	{
		_visible = NO;
		_index = 0;
		_line = 0;
		_order = 0;
		_columns = 1;
		_scale = 1.0f;
		_size = CGSizeZero;
		_rect = CGRectZero;
		_view = nil;
		_rule = BeeUIScrollLayoutRule_Tile;
	}
	return self;
}

- (void)dealloc
{
	[_view removeFromSuperview];
	[_view release];

	[super dealloc];
}

@end

#pragma mark -

@interface BeeUIScrollView()
{
	BOOL						_inited;

	id							_dataSource;
	NSInteger					_direction;
	CGFloat						_animationDuration;

	BOOL						_animated;
	NSInteger					_visibleStart;
	NSInteger					_visibleEnd;
	
	NSInteger					_lineCount;
	CGFloat						_lineHeights[MAX_LINES];
	
	NSInteger					_total;
	NSMutableArray *			_items;

	BOOL						_shouldNotify;
	BOOL						_reloaded;
	BOOL						_reloading;
	UIEdgeInsets				_baseInsets;
	
	BOOL						_reachTop;
	BOOL						_reachEnd;
	NSMutableArray *			_reuseQueue;
	
	CGPoint						_scrollSpeed;
	CGPoint						_lastScrollOffset;
	NSTimeInterval				_lastScrollTime;
	
	BeeUIPullLoader *			_headerLoader;
	BeeUIFootLoader *			_footerLoader;
	
	BeeUIScrollViewBlock		_whenReloading;
	BeeUIScrollViewBlock		_whenReloaded;
	BeeUIScrollViewBlock		_whenLayouting;
	BeeUIScrollViewBlock		_whenlayouted;
	BeeUIScrollViewBlock		_whenScrolling;
	BeeUIScrollViewBlock		_whenStop;
	BeeUIScrollViewBlock		_whenReachTop;
	BeeUIScrollViewBlock		_whenReachBottom;
	BeeUIScrollViewBlock		_whenHeaderRefresh;
	BeeUIScrollViewBlock		_whenFooterRefresh;
}

- (void)initSelf;

- (void)reloadAllItems;
- (void)recalcVisibleRange;

- (void)syncPositionsIfNeeded;
- (void)syncCellPositions;
- (void)syncPullPositions;
- (void)syncPullInsets;

- (NSInteger)getShortestLine;
- (NSInteger)getLongestLine;

- (void)operateReloadData;
- (void)internalReloadData;

- (void)enqueueAllItems;
- (void)enqueueItem:(BeeUIScrollItem *)item;
- (void)dequeueItem:(BeeUIScrollItem *)item;

- (void)notifyReloading;
- (void)notifyReloaded;
- (void)notifyLayouting;
- (void)notifyLayouted;
- (void)notifyReachTop;
- (void)notifyReachBottom;
- (void)notifyHeaderRefresh;
- (void)notifyFooterRefresh;

@end

#pragma mark -

@implementation BeeUIScrollView

IS_CONTAINABLE( YES )

DEF_INT( DIRECTION_HORIZONTAL,	0 )
DEF_INT( DIRECTION_VERTICAL,	1 )

DEF_INT( STYLE_DEFAULT,			0 )
DEF_INT( STYLE_AUTOBREAK,		1 )
DEF_INT( STYLE_AUTOFILLING,		2 )
DEF_INT( STYLE_AUTOSHIFT,		3 )

DEF_SIGNAL( RELOADING )
DEF_SIGNAL( RELOADED )
DEF_SIGNAL( LAYOUTING )
DEF_SIGNAL( LAYOUTED )
DEF_SIGNAL( REACH_TOP )
DEF_SIGNAL( REACH_BOTTOM )

DEF_SIGNAL( DID_DRAG )
DEF_SIGNAL( DID_STOP )
DEF_SIGNAL( DID_SCROLL )

DEF_SIGNAL( HEADER_REFRESH )
DEF_SIGNAL( FOOTER_REFRESH )

@synthesize dataSource = _dataSource;
@synthesize animated = _animated;
@synthesize animationDuration = _animationDuration;

@dynamic horizontal;
@dynamic vertical;
@dynamic headerShown;
@dynamic footerShown;

@dynamic visibleStart;
@dynamic visibleEnd;

@dynamic visibleRange;
@dynamic visiblePageIndex;

@synthesize reloaded = _reloaded;
@synthesize reloading = _reloading;
@synthesize reuseQueue = _reuseQueue;

@synthesize scrollSpeed = _scrollSpeed;
@dynamic scrollPercent;

@dynamic pageCount;
@dynamic pageIndex;
@dynamic baseInsets;

@synthesize lineCount = _lineCount;
@dynamic total;
@dynamic items;
@dynamic visibleItems;

@synthesize headerLoader = _headerLoader;
@synthesize footerLoader = _footerLoader;

@synthesize whenReloading = _whenReloading;
@synthesize whenReloaded = _whenReloaded;
@synthesize whenLayouting = _whenLayouting;
@synthesize whenLayouted = _whenlayouted;
@synthesize whenScrolling = _whenScrolling;
@synthesize whenStop = _whenStop;
@synthesize whenReachTop = _whenReachTop;
@synthesize whenReachBottom = _whenReachBottom;
@synthesize whenHeaderRefresh = _whenHeaderRefresh;
@synthesize whenFooterRefresh = _whenFooterRefresh;

- (id)init
{
	self = [super initWithFrame:CGRectZero];
	if ( self )
	{
		[self initSelf];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if ( self )
	{
		[self initSelf];
	}
	return self;
}

// thanks to @ilikeido
- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
    if ( self )
    {
		[self initSelf];
    }
    return self;
}

- (void)initSelf
{
	if ( NO == _inited )
	{
		_animationDuration = 0.45f;

		_direction = self.DIRECTION_VERTICAL;		
		_shouldNotify = YES;
		_reloaded = NO;
		_lineCount = 1;
		
		_total = 0;
		_items = [[NSMutableArray alloc] init];
		_reuseQueue = [[NSMutableArray nonRetainingArray] retain];

		_visibleStart = 0;
		_visibleEnd = 0;
		
		_reachTop = NO;
		_reachEnd = NO;
		_baseInsets = UIEdgeInsetsZero;	

		self.backgroundColor = [UIColor clearColor];
		self.contentSize = self.bounds.size;
		self.contentInset = _baseInsets;
		self.alwaysBounceVertical = YES;
		self.alwaysBounceHorizontal = NO;
		self.directionalLockEnabled = YES;
		self.bounces = YES;
		self.scrollEnabled = YES;
		self.showsVerticalScrollIndicator = NO;
		self.showsHorizontalScrollIndicator = NO;
		self.alpha = 1.0f;
		self.delegate = self;
		self.layer.masksToBounds = YES;
//		self.decelerationRate = 0.9f;

		[self load];
	}
}

- (void)dealloc
{
	[self unload];

	for ( BeeUIScrollItem * item in _items )
	{
		if ( item.view )
		{
			[item.view removeFromSuperview];
			item.view = nil;
		}
	}

	self.whenReloading = nil;
	self.whenReloaded = nil;
	self.whenLayouting = nil;
	self.whenLayouted = nil;
	self.whenScrolling = nil;
	self.whenStop = nil;

	[_reuseQueue removeAllObjects];
	[_reuseQueue release];
	_reuseQueue = nil;
	
	[_items removeAllObjects];
	[_items release];
	_items = nil;
	
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(operateReloadData) object:nil];	
	[NSObject cancelPreviousPerformRequestsWithTarget:self];

	[super dealloc];
}

- (void)removeFromSuperview
{
	_dataSource = nil;
	
	[NSObject cancelPreviousPerformRequestsWithTarget:self];

	[super removeFromSuperview];
}

- (BOOL)horizontal
{
	return self.DIRECTION_HORIZONTAL == _direction ? YES : NO;
}

- (void)setHorizontal:(BOOL)horizonal
{
	if ( horizonal )
	{
		_direction = self.DIRECTION_HORIZONTAL;
		
		self.alwaysBounceHorizontal = YES;
		self.showsHorizontalScrollIndicator = NO;
		
		self.alwaysBounceVertical = NO;
		self.showsVerticalScrollIndicator = NO;
	}
}

- (BOOL)vertical
{
	return self.DIRECTION_VERTICAL == _direction ? YES : NO;
}

- (void)setVertical:(BOOL)vertical
{
	if ( vertical )
	{
		_direction = self.DIRECTION_VERTICAL;
		
		self.alwaysBounceVertical = YES;
		self.showsVerticalScrollIndicator = NO;

		self.alwaysBounceHorizontal = NO;
		self.showsHorizontalScrollIndicator = NO;		
	}
}

- (NSInteger)visibleStart
{
	return _visibleStart;
}

- (NSInteger)visibleEnd
{
	return _visibleEnd;
}

- (NSRange)visibleRange
{
	return NSMakeRange( _visibleStart, _visibleEnd - _visibleStart );
}

- (NSUInteger)visiblePageIndex
{
	// special thanks to @Royall
	
	if ( self.DIRECTION_HORIZONTAL == _direction )
	{
		return (NSUInteger)floorf( _total - ((self.contentSize.width - self.contentOffset.x) / self.bounds.size.width) + 0.5f );
	}
	else
	{
		return (NSUInteger)floorf( _total - ((self.contentSize.height - self.contentOffset.y) / self.bounds.size.height) + 0.5f );
	}
}

- (CGFloat)scrollPercent
{
	CGFloat percent = 0.0f;
	
	if ( self.DIRECTION_HORIZONTAL == _direction )
	{
		percent = self.contentOffset.x / self.contentSize.width;
	}
	else
	{
		percent = self.contentOffset.y / self.contentSize.height;
	}	

//	INFO( @"percent = %0.2f", percent );
	return percent;
}

- (NSInteger)pageCount
{
	if ( self.DIRECTION_HORIZONTAL == _direction )
	{
		return (self.contentSize.width + self.bounds.size.width - 1) / self.bounds.size.width;
	}
	else
	{
		return (self.contentSize.height + self.bounds.size.height - 1) / self.bounds.size.height;
	}
}

- (NSInteger)pageIndex
{
	if ( self.DIRECTION_HORIZONTAL == _direction )
	{
		return self.contentOffset.x / self.bounds.size.width;
	}
	else
	{
		return self.contentOffset.y / self.bounds.size.height;
	}
}

- (void)setPageIndex:(NSInteger)index
{
	if ( self.DIRECTION_HORIZONTAL == _direction )
	{
		self.contentOffset = CGPointMake( self.bounds.size.width * index, self.contentOffset.y );
	}
	else
	{
		self.contentOffset = CGPointMake( self.contentOffset.x, self.bounds.size.height * index );
	}
}

- (void)setBaseInsets:(UIEdgeInsets)insets
{
	_baseInsets = insets;
	self.contentInset = insets;

	[self syncPullPositions];
	[self syncPullInsets];
}

- (UIEdgeInsets)baseInsets
{
	return _baseInsets;
}

- (NSInteger)total
{
	return _total;
}

- (void)setTotal:(NSInteger)tot
{
	for ( NSInteger t = _total; t < tot; ++t )
	{
		BeeUIScrollItem * item = [[BeeUIScrollItem alloc] init];
		item.index = t;
		[_items addObject:item];
		[item release];
	}
	
	_total = tot;
}

- (NSArray *)items
{
	return _items;
}

- (NSArray *)visibleItems
{
	NSMutableArray * array = [NSMutableArray nonRetainingArray];

	if ( _items.count > 0 )
	{
		for ( NSInteger l = _visibleStart; l <= _visibleEnd; ++l )
		{
			if ( l >= _items.count )
				break;
			
			BeeUIScrollItem * item = [_items objectAtIndex:l];
			[array addObject:item];
		}
	}
	
	return array;
}

- (void)notifyLayouting
{
	if ( _shouldNotify )
	{
		[self sendUISignal:BeeUIScrollView.LAYOUTING];
		
		if ( self.whenLayouting )
		{
			self.whenLayouting();
		}
	}
}

- (void)notifyLayouted
{
	if ( _shouldNotify )
	{
		[self sendUISignal:BeeUIScrollView.LAYOUTED];
		
		if ( self.whenLayouted )
		{
			self.whenLayouted();
		}
	}	
}

- (void)notifyReloading
{
	if ( _shouldNotify )
	{
		[self sendUISignal:BeeUIScrollView.RELOADING];
		
		if ( self.whenReloading )
		{
			self.whenReloading();
		}
	}
}

- (void)notifyReloaded
{
	if ( _shouldNotify )
	{
		[self sendUISignal:BeeUIScrollView.RELOADED];
		
		if ( self.whenReloaded )
		{
			self.whenReloaded();
		}
	}
}

- (void)notifyReachTop
{
	if ( _shouldNotify )
	{
		[self sendUISignal:BeeUIScrollView.REACH_TOP];
		
		if ( self.whenReachTop )
		{
			self.whenReachTop();
		}
	}
}

- (void)notifyReachBottom
{
	if ( _shouldNotify )
	{
		[self sendUISignal:BeeUIScrollView.REACH_BOTTOM];
		
		if ( self.whenReachBottom )
		{
			self.whenReachBottom();
		}
	}
}

- (void)notifyHeaderRefresh
{
	if ( _shouldNotify )
	{
		[self sendUISignal:BeeUIScrollView.HEADER_REFRESH];
		
		if ( self.whenHeaderRefresh )
		{
			self.whenHeaderRefresh();
		}
	}
}

- (void)notifyFooterRefresh
{
	if ( _shouldNotify )
	{
		[self sendUISignal:BeeUIScrollView.FOOTER_REFRESH];
		
		if ( self.whenFooterRefresh )
		{
			self.whenFooterRefresh();
		}
	}
}

- (void)recalcFrames
{
	[self recalcFramesAnimated:YES];
}

- (void)recalcFramesAnimated:(BOOL)animated
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(operateReloadData) object:nil];

	[self notifyReloading];
	
	if ( _dataSource && [_dataSource respondsToSelector:@selector(numberOfLinesInScrollView:)] )
	{
		_lineCount = [_dataSource numberOfLinesInScrollView:self];
	}

	if ( _dataSource && [_dataSource respondsToSelector:@selector(numberOfViewsInScrollView:)] )
	{
		_total = [_dataSource numberOfViewsInScrollView:self];
	}

	_animated = animated;

	[self reloadAllItems];
	
	[self notifyLayouting];
	
	[self syncCellPositions];
	[self syncPullPositions];
	[self syncPullInsets];

	[self notifyLayouted];
	
	_reloaded = YES;
	_animated = NO;
	
	[self notifyReloaded];
	
	[self setNeedsDisplay];
}

- (void)reloadData
{
	[self syncReloadData];
}

- (void)syncReloadData
{
	self.userInteractionEnabled = NO;
	
	[self cancelReloadData];
	_reloading = YES;
	[self operateReloadData];
	
	self.userInteractionEnabled = YES;		
}

- (void)asyncReloadData
{
	if ( NO == _reloading )
	{
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(operateReloadData) object:nil];
		[self performSelector:@selector(operateReloadData) withObject:nil afterDelay:0.2f];
		_reloading = YES;
	}
}

- (void)cancelReloadData
{
	if ( YES == _reloading )
	{
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(operateReloadData) object:nil];	
		_reloading = NO;		
	}
}

- (void)operateReloadData
{
	if ( YES == _reloading )
	{
		_reloading = NO;
		
		[self internalReloadData];		
	}
}

- (void)internalReloadData
{
	[self notifyReloading];

	if ( _dataSource && [_dataSource respondsToSelector:@selector(numberOfLinesInScrollView:)] )
	{
		_lineCount = [_dataSource numberOfLinesInScrollView:self];
	}

	if ( _dataSource && [_dataSource respondsToSelector:@selector(numberOfViewsInScrollView:)] )
	{
		_total = [_dataSource numberOfViewsInScrollView:self];
	}

	_visibleStart = 0;
	_visibleEnd = 0;

	[self enqueueAllItems];
	[self reloadAllItems];
	[self recalcVisibleRange];

	[self notifyLayouting];

	[self syncCellPositions];
	[self syncPullPositions];
	[self syncPullInsets];

	[self notifyLayouted];

	_reloaded = YES;
	
	[self notifyReloaded];
	
	[self setNeedsDisplay];
}

- (void)setFrame:(CGRect)frame
{
	_shouldNotify = NO;
	
	[super setFrame:frame];

	if ( CGSizeEqualToSize(self.contentSize, CGSizeZero) )
	{
		self.contentSize = frame.size;
		self.contentInset = _baseInsets;
	}
	
	_shouldNotify = YES;
	
	if ( NO == _reloaded )
	{
		[self syncReloadData];
	}
	else
	{
		[self asyncReloadData];	
	}
	
	[self syncPullPositions];
	[self syncPullInsets];
}

- (void)scrollToFirstPage:(BOOL)animated
{
	CGPoint offset;

	if ( self.DIRECTION_HORIZONTAL == _direction )
	{
		offset.x = -1.0f * _baseInsets.left;
		offset.y = self.contentOffset.y;
	}
	else
	{
		offset.x = self.contentOffset.x;
		offset.y = -1.0f * _baseInsets.top;
	}

	[self setContentOffset:offset animated:animated];	
}

- (void)scrollToLastPage:(BOOL)animated
{
	CGPoint offset;
	
	if ( self.DIRECTION_HORIZONTAL == _direction )
	{
		offset.x = self.contentOffset.x + self.contentSize.width + 1.0f * _baseInsets.right;
		offset.y = self.contentOffset.y;
	}
	else
	{
		offset.x = self.contentOffset.x;
		offset.y = self.contentOffset.y + self.contentSize.height + 1.0f * _baseInsets.bottom;
	}

	[self setContentOffset:offset animated:animated];		
}

- (void)scrollToPrevPage:(BOOL)animated
{
	CGPoint offset;
	
	if ( self.DIRECTION_HORIZONTAL == _direction )
	{
		if ( self.contentSize.width < self.bounds.size.width )
			return;
		
		offset.x = self.contentOffset.x - self.bounds.size.width;
		offset.y = self.contentOffset.y;
		
		if ( offset.x < -1.0f * _baseInsets.left )
		{
			offset.x = -1.0f * _baseInsets.left;
		}
	}
	else
	{
		if ( self.contentSize.height < self.bounds.size.height )
			return;
		
		offset.x = self.contentOffset.x;
		offset.y = self.contentOffset.y - self.bounds.size.height;
		
		if ( offset.x < -1.0f * _baseInsets.top )
		{
			offset.x = -1.0f * _baseInsets.top;
		}
	}

	[self setContentOffset:offset animated:animated];
}

- (void)scrollToNextPage:(BOOL)animated
{	
	CGPoint offset;
	
	if ( self.DIRECTION_HORIZONTAL == _direction )
	{
		if ( self.contentSize.width < self.bounds.size.width )
			return;
		
		offset.x = self.contentOffset.x + self.bounds.size.width;
		offset.y = self.contentOffset.y;
		
		CGFloat rightBound = self.contentOffset.x + self.contentSize.width + 1.0f * _baseInsets.right;
		
		if ( self.contentSize.width > self.bounds.size.width )
		{
			if (self.contentOffset.x < (self.contentSize.width - self.bounds.size.width)  )
			{
				offset.x = rightBound - self.bounds.size.width;
			}
			else
			{
				offset.x =  (self.contentSize.width - self.bounds.size.width + 1.0f * _baseInsets.right);
			}
		}
		else
		{
			offset.x =  (self.contentSize.width - self.bounds.size.width + 1.0f * _baseInsets.right);
		}
	}
	else
	{
		if ( self.contentSize.height < self.bounds.size.height )
			return;
		
		offset.x = self.contentOffset.x;
		offset.y = self.contentOffset.y + self.bounds.size.height;

		CGFloat bottomBound = self.contentOffset.y + self.contentSize.height + 1.0f * _baseInsets.bottom;
		
		if ( offset.y > bottomBound )
		{
			offset.y = bottomBound - self.bounds.size.height;
		}
	}
	
	[self setContentOffset:offset animated:animated];
}

- (void)scrollToIndex:(NSUInteger)index animated:(BOOL)animated
{
	if ( 0 == _total || index >= _total )
		return;

	if ( self.DIRECTION_VERTICAL == _direction )
	{
		if ( self.contentSize.height <= self.bounds.size.height )
		{
			return;
		}
	}
	else if ( self.DIRECTION_HORIZONTAL == _direction )
	{
		if ( self.contentSize.width <= self.bounds.size.width )
		{
			return;
		}
	}

	CGRect frame = ((BeeUIScrollItem *)[_items objectAtIndex:index]).rect;
	if ( CGRectEqualToRect(frame, CGRectZero) )
	{
		return;
	}

	CGFloat	margin = 0.0f;
	CGPoint	offset = CGPointZero;

	if ( self.DIRECTION_VERTICAL == _direction )
	{
		margin = (self.bounds.size.height - frame.size.height) / 2.0f;
		
		offset.x = self.contentOffset.x;
		offset.y = frame.origin.y - margin;
		
		if ( offset.y < 0.0f )
		{
			offset.y = 0.0f;
		}
		else if ( offset.y + self.bounds.size.height > self.contentSize.height )
		{
			offset.y = self.contentSize.height - self.bounds.size.height;
		}
	}
	else if ( self.DIRECTION_HORIZONTAL == _direction )
	{
		margin = (self.bounds.size.width - frame.size.width) / 2.0f;

		offset.x = frame.origin.x - margin;
		offset.y = self.contentOffset.y;
		
		if ( offset.x < 0.0f )
		{
			offset.x = 0.0f;
		}
		else if ( offset.x + self.bounds.size.width > self.contentSize.width )
		{
			offset.x = self.contentSize.width - self.bounds.size.width;
		}
	}

	[self setContentOffset:offset animated:animated];
}

- (void)scrollToView:(UIView *)view animated:(BOOL)animated
{
	for ( BeeUIScrollItem * item in _items )
	{
		if ( item.view == view )
		{
			[self scrollToIndex:item.index animated:animated];
			break;
		}
	}
}

- (id)dequeueWithContentClass:(Class)clazz
{
	for ( UIView * reuseView in _reuseQueue )
	{
		if ( [reuseView isKindOfClass:clazz] )
		{
//			INFO( @"[-] UIScrollView, dequeue '%@' %p", [[reuseView class] description], reuseView );

			[_reuseQueue removeObject:reuseView];
			return reuseView;
		}
	}

	UIView * newView = (UIView *)[BeeRuntime allocByClass:clazz];
	if ( nil == newView )
		return nil;
	
	return [[newView initWithFrame:CGRectZero] autorelease];
}

- (void)enqueueAllItems
{
	for ( BeeUIScrollItem * item in _items )
	{
		[self enqueueItem:item];
	}
}

- (void)enqueueItem:(BeeUIScrollItem *)item
{
	UIView * reuseView = item.view;
	if ( nil == reuseView )
		return;

	reuseView.hidden = YES;
	
	if ( _reuseQueue.count < MAX_QUEUED_ITEMS )
	{
//		INFO( @"[+] UIScrollView, enqueue '%@' %p", [[reuseView class] description], reuseView );
		
		[_reuseQueue insertObject:reuseView atIndex:0];
	}
	else
	{
		[reuseView removeFromSuperview];
	}
	
	item.view = nil;
	item.visible = NO;
}

- (void)dequeueItem:(BeeUIScrollItem *)item
{
	if ( nil == item.view )
	{
		if ( _dataSource )
		{
			if ( [_dataSource respondsToSelector:@selector(scrollView:viewForIndex:scale:)] )
			{
				item.view = [_dataSource scrollView:self viewForIndex:item.index scale:item.scale];
			}
			else if ( [_dataSource respondsToSelector:@selector(scrollView:viewForIndex:)] )
			{
				item.view = [_dataSource scrollView:self viewForIndex:item.index];
			}
		}

		if ( nil == item.view )
		{
			if ( item.clazz )
			{
				item.view = [self dequeueWithContentClass:item.clazz];
				if ( nil == item.view )
				{
					item.view = [[[item.clazz alloc] init] autorelease];
				}
			}
		}

		if ( item.view )
		{
			if ( nil == item.view.superview )
			{
				[self addSubview:item.view];
			}
			else if ( item.view.superview != self )
			{
				[item.view retain];
				[item.view removeFromSuperview];
				[self addSubview:item.view];
				[item.view release];
			}
		}
	}

	if ( item.view && [item.view respondsToSelector:@selector(bindData:)] )
	{
		if ( item.data )
		{
			[item.view performSelector:@selector(bindData:) withObject:item.data];
		}
	}

	item.view.hidden = NO;
}

- (void)syncPositionsIfNeeded
{
	if ( _visibleStart >= _total || _visibleEnd >= _total )
		return;

	BOOL		needed = NO;
	CGPoint		offset = self.contentOffset;
	CGSize		size = self.bounds.size;

	offset.x += self.contentInset.left;
	offset.y += self.contentInset.top;

	CGRect visibleStartRect = ((BeeUIScrollItem *)_items[_visibleStart]).rect;
	CGRect visibleEndRect = ((BeeUIScrollItem *)_items[_visibleEnd]).rect;
	
	if ( self.DIRECTION_VERTICAL == _direction )
	{
		if ( offset.y < CGRectGetMinY(visibleStartRect) || offset.y + size.height > CGRectGetMaxY(visibleEndRect) )
		{
			needed = YES;
		}
	}
	else if ( self.DIRECTION_HORIZONTAL == _direction )
	{
		if ( offset.x < CGRectGetMinX(visibleStartRect) || offset.x + size.width > CGRectGetMaxX(visibleEndRect) )
		{
			needed = YES;
		}
	}
	
	if ( needed )
	{
		[self recalcVisibleRange];

//		[self notifyLayouting];
		
		[self syncCellPositions];
		[self syncPullPositions];

//		[self notifyLayouted];
	}
}

- (void)recalcVisibleRange
{
//	INFO( @"UIScrollView, subviews = %d", [self.subviews count] );
	
	if ( 0 == _total || 0 == _lineCount )
	{
		return;
	}

	NSInteger	lineFits = 0;
	CGFloat		linePixels[MAX_LINES] = { 0.0f };

	_visibleStart = 0;
	_visibleEnd = 0;

	for ( NSInteger i = 0; i < _total; ++i )
	{
		BeeUIScrollItem * item = [_items objectAtIndex:i];

		// 先找起始INDEX
		if ( self.DIRECTION_HORIZONTAL == _direction )
		{
			if ( CGRectGetMaxX(item.rect) >= self.contentOffset.x )
			{
				_visibleStart = i;
				break;
			}			
		}
		else
		{
			if ( CGRectGetMaxY(item.rect) >= self.contentOffset.y )
			{
				_visibleStart = i;
				break;
			}
		}

		[self enqueueItem:item];
	}

//	CGFloat rightEdge = self.contentOffset.x + (self.contentInset.left + self.contentInset.right) + self.bounds.size.width;
//	CGFloat bottomEdge = self.contentOffset.y + (self.contentInset.top + self.contentInset.bottom) + self.bounds.size.height;
	
	for ( NSInteger j = _visibleStart; j < _total; ++j )
	{
		BOOL itemVisible = NO;

		BeeUIScrollItem * item = [_items objectAtIndex:j];
				
		if ( self.DIRECTION_HORIZONTAL == _direction )
		{
			if ( linePixels[item.line] <= self.bounds.size.width )
			{
				itemVisible = YES;
				
				if ( item.rect.origin.x < self.contentOffset.x )
				{
					linePixels[item.line] += item.rect.origin.x + item.rect.size.width - self.contentOffset.x;
				}
//				else if ( item.rect.origin.x > rightEdge )
//				{
//					linePixels[item.line] += 0.0f;
//				}
				else
				{
					linePixels[item.line] += item.rect.size.width;
				}

				if ( linePixels[item.line] > self.bounds.size.width )
				{
					lineFits += 1;
				}
			}
		}
		else
		{
			if ( linePixels[item.line] <= self.bounds.size.height )
			{
				itemVisible = YES;
				
				if ( item.rect.origin.y < self.contentOffset.y )
				{
					linePixels[item.line] += item.rect.origin.y + item.rect.size.height - self.contentOffset.y;
				}
//				else if ( item.rect.origin.y > bottomEdge )
//				{
//					linePixels[item.line] += 0.0f;
//				}
				else
				{
					linePixels[item.line] += item.rect.size.height;
				}

				if ( linePixels[item.line] > self.bounds.size.height )
				{
					lineFits += 1;
				}		
			}
		}
		
		item.visible = itemVisible;

		if ( NO == item.visible )
		{
			[self enqueueItem:item];
		}

		// 再找终止INDEX
		if ( lineFits >= _lineCount )
		{
			_visibleEnd = j;
			break;
		}
	}

	if ( 0 == _visibleEnd )
	{
		_visibleEnd = (_total > 0) ? (_total - 1) : 0;
	}
	
	for ( NSInteger k = _visibleEnd + 1; k < _total; ++k )
	{
		BeeUIScrollItem * item = [_items objectAtIndex:k];
		[self enqueueItem:item];
	}
	
//	INFO( @"start = %d, end = %d", _visibleStart, _visibleEnd );
	
//	if ( BEE_SCROLL_DIRECTION_HORIZONTAL == _direction )
//	{
//		CGFloat offset = self.contentOffset.x + self.bounds.size.width;
//		CGFloat bound = self.contentSize.width;
//		
//		if ( offset <= bound )
//		{
//			if ( _reachEnd )
//			{
//				_reachEnd = NO;
//			}
//		}
//	}
//	else
//	{
//		CGFloat offset = self.contentOffset.y + self.bounds.size.height;
//		CGFloat bound = self.contentSize.height;
//		
//		if ( offset <= bound )
//		{
//			if ( _reachEnd )
//			{
//				_reachEnd = NO;
//			}
//		}
//	}

	for ( NSInteger l = _visibleStart; l <= _visibleEnd; ++l )
	{
		BeeUIScrollItem * item = [_items objectAtIndex:l];		
		if ( NO == item.visible )
			continue;
		
		if ( nil == item.view )
		{
			[self dequeueItem:item];
		}

//		INFO( @"%p, (%f, %f), (%f, %f)",
//			  item.view,
//			  item.rect.origin.x, item.rect.origin.y,
//			  item.rect.size.width, item.rect.size.height );
	}
}

- (void)didAnimationStop
{
	[self reloadData];
}

- (void)syncCellPositions
{
	if ( 0 == _total )
		return;
	
	BOOL reachTop = (0 == _visibleStart) ? YES : NO;
	if ( reachTop )
	{
		if ( NO == _reachTop )
		{
			[self notifyReachTop];
			
			_reachTop = YES;
		}			
	}
	else
	{
		_reachTop = NO;
	}
	
	BOOL reachEnd = (_visibleEnd + 1 >= _total) ? YES : NO;
	if ( reachEnd )
	{
		if ( NO == _reachEnd )
		{
			[self notifyReachBottom];

			if ( _footerLoader && NO == _footerLoader.hidden )
			{
				if ( NO == _footerLoader.loading && _footerLoader.more )
				{
					_footerLoader.loading = YES;
					
					[self notifyFooterRefresh];
				}
				else
				{
					_footerLoader.loading = NO;
				}

//				[UIView beginAnimations:nil context:NULL];
//				[UIView setAnimationDuration:0.3f];
//				[UIView setAnimationBeginsFromCurrentState:YES];
//					
//				[self syncPullPositions];
//				[self syncPullInsets];
//					
//				[UIView commitAnimations];
			}

			_reachEnd = YES;
		}
	}
	else
	{
		_reachEnd = NO;
	}

	NSMutableArray * orderedItems = [NSMutableArray nonRetainingArray];
	[orderedItems addObjectsFromArray:_items];
	[orderedItems sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
		BeeUIScrollItem * item1 = obj1;
		BeeUIScrollItem * item2 = obj2;
		
		return item1.order > item2.order;
	}];
	
	for ( BeeUIScrollItem * orderedItem in orderedItems )
	{
		[self bringSubviewToFront:orderedItem.view];
	}

	if ( _animated )
	{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
		[UIView setAnimationDuration:self.animationDuration];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(didAnimationStop)];
	}

	CGRect screenFrame;
	screenFrame.origin = self.contentOffset;
	screenFrame.size = self.bounds.size;
	
	for ( NSInteger i = _visibleStart; i <= _visibleEnd; ++i )
	{
		BeeUIScrollItem * item = [_items objectAtIndex:i];
		if ( item.view )
		{
			item.view.frame = item.rect;
		}
	}
	
	if ( _animated )
	{
		[UIView commitAnimations];
	}

	CGPoint			currentOffset = self.contentOffset;
    NSTimeInterval	currentTime = [NSDate timeIntervalSinceReferenceDate];
    NSTimeInterval	timeDiff = currentTime - _lastScrollTime;
	
    if ( timeDiff > 0.1 )
	{
		_scrollSpeed.x = -((currentOffset.x - _lastScrollOffset.x) / 1000.0f);
		_scrollSpeed.y = -((currentOffset.y - _lastScrollOffset.y) / 1000.0f);

        _lastScrollOffset = currentOffset;
        _lastScrollTime = currentTime;
    }

//	INFO( @"scrollSpeed = (%f, %f)", _scrollSpeed.x, _scrollSpeed.y );
}

- (void)reloadAllItems
{
	if ( 0 == _total )
		return;

	if ( 0 == _lineCount )
		return;
	
	CGFloat itemPixels = 0.0f;
	
	if ( self.DIRECTION_HORIZONTAL == _direction )
	{
		itemPixels = self.bounds.size.height / _lineCount;
	}
	else
	{
		itemPixels = self.bounds.size.width / _lineCount;
	}

	for ( NSInteger i = 0; i < _total; ++i )
	{
		BeeUIScrollItem * item = [_items safeObjectAtIndex:i];
		if ( nil == item )
		{
			item = [[BeeUIScrollItem alloc] init];
			item.index = i;
			[_items addObject:item];
			[item release];
		}

		item.line = 0;
		item.rect = CGRectAuto;
		item.scale = 1.0f;

		if ( _dataSource && [_dataSource respondsToSelector:@selector(scrollView:orderForIndex:)] )
		{
			item.order = [_dataSource scrollView:self orderForIndex:i];
		}
			
		if ( _dataSource && [_dataSource respondsToSelector:@selector(scrollView:sizeForIndex:)] )
		{
			item.size = [_dataSource scrollView:self sizeForIndex:i];
		}
		else
		{
			if ( CGSizeEqualToSize(item.size, CGSizeAuto) )
			{
				if ( [item.clazz supportForUISizeEstimating] )
				{
					if ( self.DIRECTION_HORIZONTAL == _direction )
					{
						item.size = [item.clazz estimateUISizeByHeight:self.bounds.size.height forData:item.data];
					}
					else
					{
						item.size = [item.clazz estimateUISizeByWidth:self.bounds.size.width forData:item.data];						
					}
				}
			}
		}

		if ( _dataSource && [_dataSource respondsToSelector:@selector(scrollView:ruleForIndex:)] )
		{
			item.rule = [_dataSource scrollView:self ruleForIndex:i];
		}

		if ( self.DIRECTION_HORIZONTAL == _direction )
		{
			item.columns = floorf( (item.size.height + itemPixels - 1) / itemPixels );
		}
		else
		{
			item.columns = floorf( (item.size.width + itemPixels - 1) / itemPixels );
		}

		if ( item.columns > _lineCount )
		{
			item.columns = _lineCount;
		}
		
		if ( 0 == item.columns )
		{
			item.columns = 1;
		}
	}
	
	for ( NSInteger i = 0; i < MAX_LINES; ++i )
	{
		_lineHeights[i] = 0.0f;
	}

	NSMutableArray * gaps = [NSMutableArray array];

	for ( NSInteger i = 0; i < _total; ++i )
	{
		BeeUIScrollItem *		item = [_items objectAtIndex:i];
		BeeUIScrollLayoutRule	currentRule = item.rule;

		for ( ;; )
		{
		// Tile
			
			if ( BeeUIScrollLayoutRule_Tile == currentRule )
			{
				item.line = [self getShortestLine];

				if ( self.DIRECTION_HORIZONTAL == _direction )
				{
					CGRect itemRect;
					itemRect.origin.x = _lineHeights[item.line];
					itemRect.origin.y = item.line * itemPixels;
					itemRect.size.width = item.size.width;
					itemRect.size.height = itemPixels * item.columns;

					item.rect = itemRect;
					item.scale = 1.0f;

					for ( NSInteger k = 0; k < item.columns; ++k )
					{
						NSInteger itemLine = item.line + k;
						if ( itemLine >= _lineCount )
							break;
						
						_lineHeights[itemLine] = CGRectGetMaxX(itemRect);
					}
				}
				else
				{
					CGRect itemRect;
					itemRect.origin.x = item.line * itemPixels;
					itemRect.origin.y = _lineHeights[item.line];
					itemRect.size.width = itemPixels * item.columns;
					itemRect.size.height = item.size.height;

					item.rect = itemRect;
					item.scale = 1.0f;

					for ( NSInteger k = 0; k < item.columns; ++k )
					{
						NSInteger itemLine = item.line + k;
						if ( itemLine >= _lineCount )
							break;
						
						_lineHeights[itemLine] = CGRectGetMaxY(itemRect);
					}
				}

				break;
			}
			
		// Fall
			
			if ( BeeUIScrollLayoutRule_Fall == currentRule )
			{
				item.line = item.index % _lineCount;

				if ( self.DIRECTION_HORIZONTAL == _direction )
				{
					CGRect itemRect;
					itemRect.origin.x = _lineHeights[item.line];
					itemRect.origin.y = item.line * itemPixels;
					itemRect.size.width = item.size.width;
					itemRect.size.height = itemPixels * item.columns;

					item.rect = itemRect;
					item.scale = 1.0f;

					for ( NSInteger k = 0; k < item.columns; ++k )
					{
						NSInteger itemLine = item.line + k;
						if ( itemLine >= _lineCount )
							break;
						
						_lineHeights[itemLine] = CGRectGetMaxX(itemRect);
					}
				}
				else
				{
					CGRect itemRect;
					itemRect.origin.x = item.line * itemPixels;
					itemRect.origin.y = _lineHeights[item.line];
					itemRect.size.width = itemPixels * item.columns;
					itemRect.size.height = item.size.height;
					
					item.rect = itemRect;
					item.scale = 1.0f;
					
					for ( NSInteger k = 0; k < item.columns; ++k )
					{
						NSInteger itemLine = item.line + k;
						if ( itemLine >= _lineCount )
							break;
						
						_lineHeights[itemLine] = CGRectGetMaxY(itemRect);
					}
				}
				
				break;
			}

		// Fill

			if ( BeeUIScrollLayoutRule_Fill == currentRule )
			{
				BOOL		gapFound = NO;
				NSUInteger	gapLine = 0;
				CGRect		gapRect = CGRectZero;
				
				for ( NSDictionary * gap in gaps )
				{
					NSValue *	rect = [gap objectForKey:@"rect"];
					NSNumber *	line = [gap objectForKey:@"line"];
					
					gapLine = [line unsignedIntValue];
					gapRect = [rect CGRectValue];
					
					if ( self.DIRECTION_HORIZONTAL == _direction )
					{
						if ( gapRect.size.width >= item.size.width )
						{
							gapFound = YES;
							
							[gaps removeObject:gap];
							break;
						}
					}
					else
					{
						if ( gapRect.size.height >= item.size.height )
						{
							gapFound = YES;
							
							[gaps removeObject:gap];
							break;
						}
					}
				}
				
				if ( NO == gapFound )
				{
					currentRule = BeeUIScrollLayoutRule_Tile;
					continue;
				}
				
				item.line = gapLine;
				item.rect = gapRect;
				break;
			}

		// Line

			if ( BeeUIScrollLayoutRule_Line == currentRule )
			{
				NSInteger longestLine = [self getLongestLine];
				
				item.line = 0;
				item.columns = _lineCount;
				
				if ( self.DIRECTION_HORIZONTAL == _direction )
				{
					CGRect itemRect;
					itemRect.origin.x = _lineHeights[longestLine];
					itemRect.origin.y = item.line * itemPixels;
					itemRect.size.width = item.size.width;
					itemRect.size.height = itemPixels * item.columns;
					
					item.rect = itemRect;
					item.scale = 1.0f;
				}
				else
				{
					CGRect itemRect;
					itemRect.origin.x = item.line * itemPixels;
					itemRect.origin.y = _lineHeights[longestLine];
					itemRect.size.width = itemPixels * item.columns;
					itemRect.size.height = item.size.height;

					item.rect = itemRect;
					item.scale = 1.0f;
				}

				for ( NSUInteger m = 0; m < _lineCount; ++m )
				{
					if ( self.DIRECTION_HORIZONTAL == _direction )
					{
						CGFloat minX = CGRectGetMinX( item.rect );
						CGFloat diff = minX - _lineHeights[m];
						
						if ( diff > 0 )
						{
							CGRect gap;
							gap.origin.x = _lineHeights[m];
							gap.origin.y = m * itemPixels;
							gap.size.width = diff;
							gap.size.height = itemPixels;

							NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
												   [NSNumber numberWithUnsignedInt:m],	@"line",
												   [NSValue valueWithCGRect:gap],		@"rect",
												   nil];
							
							[gaps addObject:dict];
						}

						_lineHeights[m] = CGRectGetMaxX( item.rect );
					}
					else
					{
						CGFloat minY = CGRectGetMinY( item.rect );
						CGFloat diff = minY - _lineHeights[m];
						
						if ( diff > 0 )
						{
							CGRect gap;
							gap.origin.x = m * itemPixels;
							gap.origin.y = _lineHeights[m];
							gap.size.width = itemPixels;
							gap.size.height = diff;
							
							NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
												   [NSNumber numberWithUnsignedInt:m],	@"line",
												   [NSValue valueWithCGRect:gap],		@"rect",
												   nil];
							
							[gaps addObject:dict];
						}

						_lineHeights[m] = CGRectGetMaxY( item.rect );
					}
				}
				
				break;
			}

		// Inject

			if ( BeeUIScrollLayoutRule_Inject == currentRule )
			{
//				if ( 1 == item.columns )
//				{
//					currentRule = BeeUIScrollLayoutRule_Tile;
//					continue;
//				}

				NSUInteger shortestLine = [self getShortestLine];
//				if ( shortestLine + item.columns <= _lineCount )
//				{
//					currentRule = BeeUIScrollLayoutRule_Tile;
//					continue;
//				}

				if ( shortestLine + item.columns >= _lineCount )
				{
					item.line = _lineCount - item.columns;
				}
				else
				{
					item.line = shortestLine;
				}
				
				if ( item.line < 0 )
				{
					item.line = 0;
				}
				
				if ( self.DIRECTION_HORIZONTAL == _direction )
				{
					CGRect itemRect;
					itemRect.origin.x = _lineHeights[shortestLine];
					itemRect.origin.y = item.line * itemPixels;
					itemRect.size.width = item.size.width;
					itemRect.size.height = itemPixels * item.columns;

					item.rect = itemRect;
					item.scale = 1.0f;

					for ( NSInteger k = 0; k < item.columns; ++k )
					{
						NSInteger itemLine = item.line + k;
						if ( itemLine >= _lineCount )
							break;
						
						_lineHeights[itemLine] = CGRectGetMaxX(item.rect);
					}
				}
				else
				{
					CGRect itemRect;
					itemRect.origin.x = item.line * itemPixels;
					itemRect.origin.y = _lineHeights[shortestLine];
					itemRect.size.width = itemPixels * item.columns;
					itemRect.size.height = item.size.height;

					item.rect = itemRect;
					item.scale = 1.0f;
					
					for ( NSInteger k = 0; k < item.columns; ++k )
					{
						NSInteger itemLine = item.line + k;
						if ( itemLine >= _lineCount )
							break;

						_lineHeights[itemLine] = CGRectGetMaxY(item.rect);
					}
				}

				for ( NSInteger j = 0; j < i; ++j )
				{
					BeeUIScrollItem * item2 = [_items objectAtIndex:j];
					
					if ( item2.line >= item.line && item2.line < (item.line + item.columns) )
					{
						if ( self.DIRECTION_HORIZONTAL == _direction )
						{
							if ( CGRectGetMaxX(item2.rect) > CGRectGetMinX(item.rect) )
							{
								CGRect itemRect = item2.rect;
								itemRect.origin.x = CGRectGetMaxX( item.rect );
								item2.rect = itemRect;
							}

							if ( CGRectGetMaxX(item2.rect) > _lineHeights[item2.line] )
							{
								_lineHeights[item2.line] = CGRectGetMaxX(item2.rect);
							}
						}
						else
						{
							if ( CGRectGetMaxY(item2.rect) > CGRectGetMinY(item.rect) )
							{
								CGRect itemRect = item2.rect;
								itemRect.origin.y = CGRectGetMaxY( item.rect );
								item2.rect = itemRect;
							}

							if ( CGRectGetMaxY(item2.rect) > _lineHeights[item2.line] )
							{
								_lineHeights[item2.line] = CGRectGetMaxY(item2.rect);
							}
						}
					}
				}

				break;
			}
		}
	}

	NSInteger bottomLine = [self getLongestLine];

	if ( bottomLine < _lineCount )
	{
		if ( self.DIRECTION_HORIZONTAL == _direction )
		{
			self.contentSize = CGSizeMake( _lineHeights[bottomLine], self.bounds.size.height );
		}
		else
		{
			self.contentSize = CGSizeMake( self.bounds.size.width, _lineHeights[bottomLine] );
		}
	}
	else
	{
		if ( self.DIRECTION_HORIZONTAL == _direction )
		{
			self.contentSize = CGSizeMake( 0.0f, self.bounds.size.height );
		}
		else
		{
			self.contentSize = CGSizeMake( self.bounds.size.width, 0.0f );
		}
	}
}

- (NSInteger)getLongestLine
{
	if ( 0 == _total )
	{
		return _lineCount + 1;
	}
	
	NSInteger longest = 0;

	for ( NSInteger i = 0; i < _lineCount; ++i )
	{
		if ( _lineHeights[i] > _lineHeights[longest] )
		{
			longest = i;
		}
	}
	
	return longest;	
}

- (NSInteger)getShortestLine
{
	if ( 0 == _total )
	{
		return _lineCount + 1;
	}
	
	NSInteger shortest = 0;

	for ( NSInteger i = 0; i < _lineCount; ++i )
	{
		if ( _lineHeights[i] < _lineHeights[shortest] )
		{
			shortest = i;
		}
	}
	
	return shortest;
}

- (BOOL)headerShown
{
	if ( _headerLoader && NO == _headerLoader.hidden )
	{
		return YES;
	}
	
	return NO;
}

- (void)setHeaderShown:(BOOL)flag
{
	[self showHeaderLoader:flag animated:YES];
}

- (BOOL)footerShown
{
	if ( _footerLoader && NO == _footerLoader.hidden )
	{
		return YES;
	}
	
	return NO;
}

- (void)setFooterShown:(BOOL)flag
{
	[self showFooterLoader:flag animated:YES];
}

- (void)showHeaderLoader:(BOOL)flag animated:(BOOL)animated
{
	if ( nil == _headerLoader )
	{
		_headerLoader = [[BeeUIPullLoader spawn] retain];
		_headerLoader.hidden = YES;
//		_headerLoader.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;

		if ( _direction == self.DIRECTION_HORIZONTAL )
		{
			_headerLoader.transform = CGAffineTransformMakeRotation( M_PI / 2.0f * 3.0f );
		}
		else
		{
			_headerLoader.transform = CGAffineTransformIdentity;
		}

		[self addSubview:_headerLoader];
		[self bringSubviewToFront:_headerLoader];
	}
	
	if ( flag )
	{
		_headerLoader.hidden = NO;
	}
	else
	{
		_headerLoader.hidden = YES;
	}
	
	[self syncPullPositions];
	[self syncPullInsets];
}

- (void)showFooterLoader:(BOOL)flag animated:(BOOL)animated
{
	if ( nil == _footerLoader )
	{
		_footerLoader = [[BeeUIFootLoader spawn] retain];
//		_footerLoader.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;

		[self addSubview:_footerLoader];
		[self bringSubviewToFront:_footerLoader];
	}

	if ( flag )
	{
		_footerLoader.hidden = NO;
	}
	else
	{
		_footerLoader.hidden = YES;
	}
	
	[self syncPullPositions];
	[self syncPullInsets];
}

- (void)setHeaderLoading:(BOOL)en
{
	if ( _headerLoader )
	{
		if ( en )
		{
			if ( NO == _headerLoader.loading )
			{
				_headerLoader.loading = YES;

				[UIView beginAnimations:nil context:NULL];
				[UIView setAnimationDuration:self.animationDuration];
				
				[self syncPullInsets];
				
				[UIView commitAnimations];
			}
		}
		else
		{
			if ( _headerLoader.loading )
			{
				_headerLoader.loading = NO;

				[UIView beginAnimations:nil context:NULL];
				[UIView setAnimationDuration:self.animationDuration];
				
				[self syncPullInsets];
				
				[UIView commitAnimations];
			}
			else if ( _headerLoader.pulling )
			{
				_headerLoader.pulling = NO;
				
				[UIView beginAnimations:nil context:NULL];
				[UIView setAnimationDuration:self.animationDuration];
				
				[self syncPullInsets];
				
				[UIView commitAnimations];				
			}
		}
	}
}

- (void)setFooterLoading:(BOOL)en
{
	if ( _footerLoader && NO == _footerLoader.hidden )
	{
		_footerLoader.loading = en;

		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:self.animationDuration];
		
		[self syncPullInsets];
		
		[UIView commitAnimations];
	}
}

- (void)setFooterMore:(BOOL)en
{
	if ( _footerLoader && NO == _footerLoader.hidden )
	{
		_footerLoader.more = en;

		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:self.animationDuration];
		
		[self syncPullInsets];
		
		[UIView commitAnimations];
	}	
}

- (void)syncPullPositions
{
	if ( _headerLoader )
	{
		CGRect pullFrame;

		if ( _direction == self.DIRECTION_HORIZONTAL )
		{
		#if __BEE_IOS6_UI_COMPATIBLE__
			pullFrame.origin.x = - _headerLoader.bounds.size.width - _baseInsets.left;
		#else	// #if __BEE_IOS6_UI_COMPATIBLE__
			pullFrame.origin.x = - _headerLoader.bounds.size.width;
		#endif	// #if __BEE_IOS6_UI_COMPATIBLE__
			pullFrame.origin.y = 0.0f;
			pullFrame.size.width = _headerLoader.bounds.size.width;
			pullFrame.size.height = self.bounds.size.height;
		}
		else
		{
			pullFrame.origin.x = 0.0f;
		#if __BEE_IOS6_UI_COMPATIBLE__
			pullFrame.origin.y = - _headerLoader.bounds.size.height - _baseInsets.top;
		#else	// #if __BEE_IOS6_UI_COMPATIBLE__
			pullFrame.origin.y = - _headerLoader.bounds.size.height;
		#endif	// #if __BEE_IOS6_UI_COMPATIBLE__
			pullFrame.size.width = self.bounds.size.width;
			pullFrame.size.height = _headerLoader.bounds.size.height;
		}

		_headerLoader.frame = pullFrame;

//		INFO( @"headerLoader, frame = (%f,%f,%f,%f), insets = (%f,%f,%f,%f)",
//		   _headerLoader.frame.origin.x, _headerLoader.frame.origin.y,
//		   _headerLoader.frame.size.width, _headerLoader.frame.size.height,
//		   self.contentInset.top, self.contentInset.left,
//		   self.contentInset.bottom, self.contentInset.right
//		   );
	}

	if ( _footerLoader && NO == _footerLoader.hidden )
	{
		CGRect footFrame;

		if ( _direction == self.DIRECTION_HORIZONTAL )
		{
			footFrame.origin.x = self.contentSize.width;
			footFrame.origin.y = 0.0f;
			footFrame.size.width = _footerLoader.bounds.size.width;
			footFrame.size.height = self.bounds.size.height;
		}
		else
		{
			footFrame.origin.x = 0.0f;
			footFrame.origin.y = self.contentSize.height;
			footFrame.size.width = self.bounds.size.width;
			footFrame.size.height = _footerLoader.bounds.size.height;
		}

		_footerLoader.frame = footFrame;

//		INFO( @"footerLoader, frame = (%f,%f,%f,%f), insets = (%f,%f,%f,%f)",
//		   _footerLoader.frame.origin.x, _footerLoader.frame.origin.y,
//		   _footerLoader.frame.size.width, _footerLoader.frame.size.height,
//		   self.contentInset.top, self.contentInset.left,
//		   self.contentInset.bottom, self.contentInset.right
//		   );
	}
}

- (void)syncPullInsets
{
	UIEdgeInsets insets = _baseInsets;
	
	if ( _headerLoader && NO == _headerLoader.hidden )
	{
		if ( _headerLoader.loading )
		{
			if ( _direction == self.DIRECTION_HORIZONTAL )
			{
				insets.left += _headerLoader.bounds.size.width;
			}
			else
			{
				insets.top += _headerLoader.bounds.size.height;
			}
		}
		
//		INFO( @"headerLoader, frame = (%f,%f,%f,%f), insets = (%f,%f,%f,%f)",
//		   _headerLoader.frame.origin.x, _headerLoader.frame.origin.y,
//		   _headerLoader.frame.size.width, _headerLoader.frame.size.height,
//		   self.contentInset.top, self.contentInset.left,
//		   self.contentInset.bottom, self.contentInset.right
//		   );
	}
	
	if ( _footerLoader && NO == _footerLoader.hidden )
	{
		if ( NO == _footerLoader.hidden )
		{
			if ( _direction == self.DIRECTION_HORIZONTAL )
			{
				insets.right += _footerLoader.bounds.size.width;
			}
			else
			{
				insets.bottom += _footerLoader.bounds.size.height;
			}
		}
	}

	self.contentInset = insets;
}

#pragma mark -
#pragma mark BeeUIScrollViewDelegate

- (NSInteger)numberOfLinesInScrollView:(BeeUIScrollView *)scrollView
{
	return 0;
}

- (NSInteger)numberOfViewsInScrollView:(BeeUIScrollView *)scrollView
{
	return 0;
}

- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index
{
	return nil;
}

- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index scale:(CGFloat)scale
{
	return nil;
}

- (CGSize)scrollView:(BeeUIScrollView *)scrollView sizeForIndex:(NSInteger)index
{
	return CGSizeZero;
}

- (NSInteger)scrollView:(BeeUIScrollView *)scrollView orderForIndex:(NSInteger)index
{
	return index;
}

- (BeeUIScrollLayoutRule)scrollView:(BeeUIScrollView *)scrollView ruleForIndex:(NSInteger)index
{
	return BeeUIScrollLayoutRule_Tile;
}

#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if ( scrollView.dragging )
	{
		// header loader
		
		if ( _headerLoader && NO == _headerLoader.hidden && NO == _headerLoader.loading )
		{
			if ( _direction == self.DIRECTION_HORIZONTAL )
			{
				CGFloat offset = scrollView.contentOffset.x;
				CGFloat boundX = -(_baseInsets.left + _headerLoader.bounds.size.width);

				if ( offset < boundX )
				{
					if ( NO == _headerLoader.pulling )
					{
						_headerLoader.pulling = YES;
					}
				}
				else if ( offset < 0.0f )
				{
					if ( _headerLoader.loading )
					{
						_headerLoader.loading = NO;
					}
					else if ( _headerLoader.pulling )
					{
						_headerLoader.pulling = NO;
					}
				}
			}
			else
			{
				CGFloat offset = scrollView.contentOffset.y;
				CGFloat boundY = -(_baseInsets.top + _headerLoader.bounds.size.height);

				if ( offset < boundY )
				{
					if ( NO == _headerLoader.pulling )
					{
						_headerLoader.pulling = YES;
					}
				}
				else if ( offset < 0.0f )
				{
					if ( _headerLoader.loading )
					{
						_headerLoader.loading = NO;
					}
					else if ( _headerLoader.pulling )
					{
						_headerLoader.pulling = NO;
					}
				}
			}
		}
	}

	if ( _shouldNotify )
	{
		[self sendUISignal:BeeUIScrollView.DID_SCROLL];

		if ( self.whenScrolling )
		{
			self.whenScrolling();
		}
	}
	
	[self syncPositionsIfNeeded];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	[self syncPositionsIfNeeded];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if ( decelerate )
	{
		// header loader
		
		if ( _headerLoader && NO == _headerLoader.hidden && NO == _headerLoader.loading )
		{
			if ( _direction == self.DIRECTION_HORIZONTAL )
			{
				CGFloat offset = scrollView.contentOffset.x;
				CGFloat boundY = -(_baseInsets.left + _headerLoader.bounds.size.width);
				
				if ( offset <= boundY )
				{
					if ( NO == _headerLoader.loading )
					{
						_headerLoader.loading = YES;
	
						[self notifyHeaderRefresh];
					}
				}
				else
				{
					if ( _headerLoader.loading )
					{
						_headerLoader.loading = NO;
					}
					else if ( _headerLoader.pulling )
					{
						_headerLoader.pulling = NO;
					}
				}
			}
			else
			{
				CGFloat offset = scrollView.contentOffset.y;
				CGFloat boundY = -(_baseInsets.top + _headerLoader.bounds.size.height);
				
				if ( offset <= boundY )
				{
					if ( NO == _headerLoader.loading )
					{
						_headerLoader.loading = YES;
						
						[self notifyHeaderRefresh];
					}
				}
				else
				{
					if ( _headerLoader.loading )
					{
						_headerLoader.loading = NO;
					}
					else if ( _headerLoader.pulling )
					{
						_headerLoader.pulling = NO;
					}
				}
			}
			
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:self.animationDuration];
			
			[self syncPullPositions];
			[self syncPullInsets];
			
			[UIView commitAnimations];
		}
	}

	if ( _shouldNotify )
	{
		[self sendUISignal:BeeUIScrollView.DID_DRAG];
//		[self sendUISignal:BeeUIScrollView.DID_STOP];
		
		if ( self.whenScrolling )
		{
			self.whenScrolling();
		}
	}
	
	[self syncPositionsIfNeeded];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
	[self syncPositionsIfNeeded];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	if ( _shouldNotify )
	{
		[self sendUISignal:BeeUIScrollView.DID_STOP];

		if ( self.whenStop )
		{
			self.whenStop();
		}
	}

	[self syncPositionsIfNeeded];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
	[self syncPositionsIfNeeded];
}

#pragma mark -

- (void)handleUISignal:(BeeUISignal *)signal
{
	if ( [signal is:BeeUIFootLoader.TOUCHED] )
	{
		[self notifyFooterRefresh];
	}
	else
	{
		FORWARD_SIGNAL( signal );
	}
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
