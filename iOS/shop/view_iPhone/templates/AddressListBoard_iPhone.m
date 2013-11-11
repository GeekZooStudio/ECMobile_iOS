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
	
#import "AddressListBoard_iPhone.h"
#import "AddAddressBoard_iPhone.h"
#import "EditAddressBoard_iPhone.h"
#import "AppBoard_iPhone.h"
#import "CommonWaterMark.h"
#import "model.h"

#pragma mark -

@implementation AddressListCell_iPhone

DEF_SIGNAL( TOUCHED )

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

- (void)load
{
    [super load];
    
    self.tappable = YES;
    self.tapSignal = self.TOUCHED;
}

- (void)dataDidChanged
{
    if ( self.data )
    {
        ADDRESS * address = self.data;
        
        $(@"#name").TEXT(address.consignee);
        $(@"#location").TEXT([RegionModel regionFromAddress:address]);
        $(@"#location-detail").TEXT(address.address);
        
        if ( address.default_address.boolValue )
        {
            $(@"#list-indictor").SHOW();
            $(@"#name").CSS(@"color: #2097C8");
//            $(@"#location").CSS(@"color: #2097C8");
//            $(@"#location-detail").CSS(@"color: #2097C8");
        }
        else
        {
            $(@"#list-indictor").HIDE();
//            $(@"#name").CSS(@"color: #333");
//            $(@"#location").CSS(@"color: #333");
//            $(@"#location-detail").CSS(@"color: #333");
        }
    }
}

@end

#pragma mark -

@interface AddressListBoard_iPhone()
{
	BeeUIScrollView * _scroll;
}
@end

#pragma mark -

@implementation AddressListBoard_iPhone

- (void)load
{
	[super load];
    
    self.shouldGotoManage = YES;
    
    self.addressModel = [[[AddressModel alloc] init] autorelease];
    [self.addressModel addObserver:self];
}

- (void)unload
{
    [self.addressModel removeObserver:self];
    self.addressModel = nil;
    
	[super unload];
}

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        if ( self.shouldGotoManage )
        {
            self.titleString = __TEXT(@"manage_address");
        }
        else
        {
            self.titleString = __TEXT(@"select_address");
        }
        
        [self showNavigationBarAnimated:NO];
        
        [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav-back.png"]];
		[self showBarButton:BeeUINavigationBar.RIGHT image:[UIImage imageNamed:@"nav-add.png"]];
        
		_scroll = [[BeeUIScrollView alloc] init];
		_scroll.dataSource = self;
        [_scroll setBaseInsets:UIEdgeInsetsMake(10, 0, 0, 0)];
		[self.view addSubview:_scroll];
        
        [_scroll showHeaderLoader:YES animated:YES];
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
		self.addressModel.loaded = NO;		
        [self.addressModel fetchFromServer];

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
        [self.stack pushBoard:[AddAddressBoard_iPhone board] animated:YES];
    }
}

ON_SIGNAL2( BeeUIScrollView, signal )
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIScrollView.HEADER_REFRESH] )
	{
		[self.addressModel fetchFromServer];
	}
	else if ( [signal is:BeeUIScrollView.REACH_BOTTOM] )
	{
//		[self.addressModel fetchFromServer];
	}
}

ON_SIGNAL2( AddressListCell_iPhone, signal )
{
    if ( self.shouldGotoManage )
    {
        [self.addressModel info:((AddressListCell_iPhone *)signal.source).data];
    }
    else
    {
        [CurrentAddressModel sharedInstance].address = ((AddressListCell_iPhone *)signal.source).data;
        [self.addressModel setDefault:[CurrentAddressModel sharedInstance].address];
    }
}

#pragma mark -

- (void)handleMessage:(BeeMessage *)msg
{
    [super handleMessage:msg];
    
    if ( [msg is:API.address_list] )
    {
        if ( msg.sending )
        {
            if ( NO == self.addressModel.loaded )
            {
                 [self presentLoadingTips:__TEXT(@"tips_loading")];
            }
            else
            {
                [_scroll setHeaderLoading:YES];
            }
        }
        else
        {
            [_scroll setHeaderLoading:NO];
            [self dismissTips];
        }

        if ( msg.succeed )
        {
            [_scroll reloadData];
        }
        else if( msg.failed )
        {
//			[self presentFailureTips:@"加载失败"];
			[ErrorMsg presentErrorMsg:msg inBoard:self];
        }
    }
    else if ( [msg is:API.address_info] )
    {
        if ( msg.sending )
        {
            [self presentLoadingTips:__TEXT(@"tips_loading")];
        }
        else
        {
            [self dismissTips];
        }
        
        if ( msg.succeed )
        {
            EditAddressBoard_iPhone * board = [EditAddressBoard_iPhone board];
            board.address = self.addressModel.singleAddress;
            [self.stack pushBoard:board animated:YES];
        }
        else if( msg.failed )
        {
			[ErrorMsg presentErrorMsg:msg inBoard:self];
        }
    }
    else if ( [msg is:API.address_setDefault] )
    {
        if ( msg.sending )
        {
            [self presentLoadingTips:__TEXT(@"tips_loading")];
        }
        else
        {
            [self dismissTips];
        }
        
        if ( msg.succeed )
        {
            [self.stack popBoardAnimated:YES];
        }
        else if( msg.failed )
        {
//            [self presentFailureTips:@"选择收货地址失败\n请稍后再试"];
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
	return 1;
}

- (NSInteger)numberOfViewsInScrollView:(BeeUIScrollView *)scrollView
{
	if ( _addressModel.loaded && 0 == _addressModel.address.count )
	{
		return 1;
	}

	return self.addressModel.address.count;
}

- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index scale:(CGFloat)scale
{
	if ( _addressModel.loaded && 0 == _addressModel.address.count )
	{
		return [scrollView dequeueWithContentClass:[NoResultCell class]];
	}

	AddressListCell_iPhone * cell = [scrollView dequeueWithContentClass:[AddressListCell_iPhone class]];
	ADDRESS * address = [self.addressModel.address safeObjectAtIndex:index];
    
    if ( !self.shouldGotoManage )
    {
        if ( [CurrentAddressModel sharedInstance].address.id.integerValue == address.id.integerValue )
        {
            address.default_address = @(YES);
        }
        else
        {
            address.default_address = @(NO);
        }
    }
    
    cell.data = address;
    
    int cellCount = [self.addressModel.address count];
    
    if ( cellCount == 1 )
    {
        $(cell).FIND(@".bg").IMAGE(@"cell-bg-single.png");
    }
    else
    {
        if ( index == 0 )
        {
            $(cell).FIND(@".bg").IMAGE(@"cell-bg-header.png");
        }
        else if ( index == (cellCount - 1) )
        {
            $(cell).FIND(@".bg").IMAGE(@"cell-bg-footer.png");
        }
        else
        {
            $(cell).FIND(@".bg").IMAGE(@"cell-bg-content.png");
        }
    }
    
	return cell;
}

- (CGSize)scrollView:(BeeUIScrollView *)scrollView sizeForIndex:(NSInteger)index
{
	if ( _addressModel.loaded && 0 == _addressModel.address.count )
	{
		return self.size;
	}

    id data = [self.addressModel.address safeObjectAtIndex:index];
    CGSize size = [AddressListCell_iPhone estimateUISizeByWidth:self.viewWidth forData:data];
	return size;
}

@end
