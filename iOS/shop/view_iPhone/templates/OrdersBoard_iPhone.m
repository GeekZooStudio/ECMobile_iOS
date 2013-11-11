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
	
#import "OrdersBoard_iPhone.h"
#import "AppBoard_iPhone.h"

#pragma mark -

@implementation OrderCellInfo_iPhone

SUPPORT_RESOURCE_LOADING( YES )

- (void)dataDidChanged
{
    $(@"#ship").TEXT( self.formated_shipping_fee );
    $(@"#bonus").TEXT( [NSString stringWithFormat:@"- %@", self.formated_bonus] );
    $(@"#integral").TEXT( [NSString stringWithFormat:@"- %@", self.formated_integral_money] );
}

@end

@implementation OrderCellFooter_iPhone

SUPPORT_RESOURCE_LOADING( YES )

- (void)dataDidChanged
{
}

@end

@implementation OrderCellHeader_iPhone

SUPPORT_RESOURCE_LOADING( YES )

- (void)dataDidChanged
{
    if ( self.data )
    {
        ORDER * order = self.data;
        
        if ( order.order_time )
        {
            $(@"#order-date-label").SHOW();
            $(@"#order-date").SHOW();
            
            NSDate * date = [order.order_time asNSDate];
            
            $(@"#order-date-label").TEXT( __TEXT(@"tradeitem_time") );
            $(@"#order-date").TEXT( [date stringWithDateFormat:@"yyyy-MM-dd HH:mm"] );
        }
        else
        {
            $(@"#order-date-label").HIDE();
            $(@"#order-date").HIDE();
        }
        
        if ( order.order_sn )
        {
            $(@"#order-number-label").SHOW();
            $(@"#order-number").SHOW();
            
            $(@"#order-number-label").TEXT( __TEXT(@"tradeitem_number") );
            $(@"#order-number").TEXT( order.order_sn );
        }
        else
        {
            $(@"#order-number-label").HIDE();
            $(@"#order-number").HIDE();
        }
    }
}

@end

@implementation OrderCellBody_iPhone

SUPPORT_RESOURCE_LOADING( YES )

- (void)dataDidChanged
{
    ORDER_GOODS * goods = self.data;
    
    $(@"#order-goods-count").TEXT( [NSString stringWithFormat:@"X %@", goods.goods_number] );
    $(@"#order-goods-price").TEXT( goods.formated_shop_price );
    $(@"#order-goods-title").TEXT( goods.name );
    $(@"#order-goods-photo").IMAGE( goods.img.thumbURL );
}

@end

@implementation OrderCell_iPhone

+ (CGSize)estimateUISizeByWidth:(CGFloat)width forData:(id)data
{
    CGSize size = CGSizeMake( width, [self.class heightByCount:3] );
    return size;
}

+ (CGFloat)heightByCount:(NSInteger)count
{
    return ( 195 + 90 * count );
}

- (void)layoutDidFinish
{
    _scroll.frame = CGRectMakeBound(self.width, self.height);
	[_scroll reloadData];
}

- (void)load
{
    [super load];
    
    _dataCounts = 6;
    
    _scroll = [[BeeUIScrollView alloc] init];
    _scroll.scrollEnabled = NO;
    _scroll.dataSource = self;
    [self addSubview:_scroll];
}


#pragma mark -

- (NSInteger)numberOfLinesInScrollView:(BeeUIScrollView *)scrollView
{
	return 1;
}

- (NSInteger)numberOfViewsInScrollView:(BeeUIScrollView *)scrollView
{
	return _dataCounts;
}

- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index scale:(CGFloat)scale
{
    if ( 0 == index )
    {
        OrderCellHeader_iPhone * cell = [scrollView dequeueWithContentClass:[OrderCellHeader_iPhone class]];
        cell.data = nil;
        return cell;
    }
    else if( (_dataCounts - 1) == index )
    {
        OrderCellFooter_iPhone * cell = [scrollView dequeueWithContentClass:[OrderCellFooter_iPhone class]];
        cell.data = nil;
        return cell;
    }
    else if( (_dataCounts - 2) == index )
    {
        OrderCellInfo_iPhone * cell = [scrollView dequeueWithContentClass:[OrderCellInfo_iPhone class]];
        cell.data = nil;
        return cell;
    }
    else
    {
        OrderCellBody_iPhone * cell = [scrollView dequeueWithContentClass:[OrderCellBody_iPhone class]];
        cell.data = nil;
        return cell;
    }
}

- (CGSize)scrollView:(BeeUIScrollView *)scrollView sizeForIndex:(NSInteger)index
{
    CGSize size = CGSizeZero;
    
    if ( 0 == index )
    {
        size = CGSizeMake(320, 32);
    }
    else if( (_dataCounts - 1) == index )
    {
        size = CGSizeMake(320, 90);
    }
    else if( (_dataCounts - 2) == index )
    {
        size = CGSizeMake(320, 70);
    }
    else
    {
        size = CGSizeMake(320, 90);
    }
    
	return size;
}

@end

#pragma mark -

@interface OrdersBoard_iPhone()
{
	BeeUIScrollView * _scroll;
}
@end



#pragma mark -

@implementation OrdersBoard_iPhone

#pragma mark -

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{		
		_scroll = [[BeeUIScrollView alloc] init];
		_scroll.dataSource = self;
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

#pragma mark -

- (void)handleMessage:(BeeMessage *)msg
{
    [super handleMessage:msg];
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
	return 5;
}

- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index scale:(CGFloat)scale
{
	OrderCell_iPhone * cell = [scrollView dequeueWithContentClass:[OrderCell_iPhone class]];
	cell.data = nil;
	return cell;
}

- (CGSize)scrollView:(BeeUIScrollView *)scrollView sizeForIndex:(NSInteger)index
{
    int height = [OrderCell_iPhone heightByCount:3];
	return CGSizeMake(scrollView.width, height);
}

@end
