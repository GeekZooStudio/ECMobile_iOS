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

#import "CartBoard_iPhone.h"
#import "AddAddressBoard_iPhone.h"
#import "CheckoutBoard_iPhone.h"
#import "AppBoard_iPhone.h"
#import "CommonWaterMark.h"
#import "UserModel.h"

#pragma mark -

@implementation CartCheckoutCell_iPhone

SUPPORT_RESOURCE_LOADING( YES )

- (void)dataDidChanged
{
    TOTAL * total = self.data;
    
    if ( total )
    {
        $(@"#cart-goods-price").TEXT(total.goods_price);
    }
}

@end

@implementation CartEditCell_iPhone

- (void)load
{
    [super load];
        
    _minus = [[[BeeUIButton alloc] initWithFrame:CGRectZero] autorelease];
    [_minus setImage:[UIImage imageNamed:@"item-info-buy-choose-min-btn.png"] forState:UIControlStateNormal];
    [_minus addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_minus];
    
    _input = [[[BeeUITextField alloc] initWithFrame:CGRectZero] autorelease];
    _input.enabled = NO;
    _input.textAlignment = NSTextAlignmentCenter;
    _input.keyboardType = UIKeyboardTypeNumberPad;
    _input.backgroundImage = [[UIImage imageNamed:@"item-info-buy-choose-num-bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [self addSubview:_input];
    
    _pluss = [[[BeeUIButton alloc] initWithFrame:CGRectZero] autorelease];
    [_pluss addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
    [_pluss setImage:[UIImage imageNamed:@"item-info-buy-choose-sum-btn.png"] forState:UIControlStateNormal];
    [self addSubview:_pluss];
    
    _remove = [[[BeeUIButton alloc] initWithFrame:CGRectZero] autorelease];
    _remove.title = __TEXT(@"shopcaritem_remove");
    _remove.titleFont = [UIFont systemFontOfSize:14];
    _remove.titleColor = [UIColor blackColor];
    [_remove addTarget:self.superview action:@selector(remove:) forControlEvents:UIControlEventTouchUpInside];
    [_remove setBackgroundImage:[[UIImage imageNamed:@"shopping-cart-edit-remove-bg-grey.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
    [self addSubview:_remove];
    
    self.backgroundImage = [[UIImage imageNamed:@"shopping-cart-edit-remove-box.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];

}

- (void)dataDidChanged
{
    CART_GOODS * goods = self.data;
    _input.text = goods.goods_number;
}

- (void)layoutDidFinish
{
    // 150 15 115 15 30
    _minus.frame = CGRectMake( 15, 40, 30, 25 );
    _input.frame = CGRectMake( _minus.right, _minus.top, 60, 25 );
    _pluss.frame = CGRectMake( _input.right, _minus.top, 30, 25 );
    _remove.frame = CGRectMake( 15, 20 + _minus.bottom, 120, 25 );
}

- (void)change:(BeeUIButton *)sender
{
    NSUInteger count = _input.text.integerValue;
    
    if ( sender == _minus )
    {
        if ( count > 1 )
        {
            _input.text = [NSString stringWithFormat:@"%d", (count - 1)];
        }
    }
    else if ( sender == _pluss )
    {
        _input.text = [NSString stringWithFormat:@"%d", (count + 1)];
    }
}

- (NSNumber *)count
{
    return [NSNumber numberWithInt:_input.text.integerValue];
}

- (void)remove:(id)sender
{
    [self sendUISignal:CartBoardCell_iPhone.CART_REMOVE_DONE];
}

@end

#pragma mark -

@implementation CartGoodCell_iPhone

SUPPORT_RESOURCE_LOADING( YES )

@end

#pragma mark -

@interface CartBoardCell_iPhone()
{
    NSString * _tempCount;
}
@end

@implementation CartBoardCell_iPhone

DEF_SIGNAL( CART_EDIT_DONE )
DEF_SIGNAL( CART_EDIT_BEGAN )
DEF_SIGNAL( CART_REMOVE_DONE )

+ (CGSize)estimateUISizeByWidth:(CGFloat)width forData:(id)data
{
    CGSize size = CGSizeMake(320, 130);
    return  size;
}

- (void)load
{
    [super load];
    
    _editing = NO;
    
    _container = [[BeeUICell alloc] initWithFrame:CGRectZero];
    [self addSubview:_container];
    
    _cartCell = [[CartGoodCell_iPhone alloc] initWithFrame:CGRectZero];
    [_container addSubview:_cartCell];

    UIImage * image = [[UIImage imageNamed:@"shopping-cart-body-bg-03.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    _background = [[BeeUIImageView alloc] initWithFrame:CGRectZero];
    _background.contentMode = UIViewContentModeScaleToFill;
    _background.image  = image;
    [self insertSubview:_background atIndex:0];
    
    _editCell = [[CartEditCell_iPhone alloc] initWithFrame:CGRectZero];
    [_container addSubview:_editCell];
}

- (void)layoutDidFinish
{
    _container.frame = CGRectMake(10, 0, 300, self.height);
    _cartCell.frame = CGRectMake( 0, 0, _container.width, _container.height );
    _cartCell.RELAYOUT();
    _editCell.frame = CGRectMake( _container.width, 0, 150, _container.height - 1 );
    _background.frame = CGRectMake( 3, 0, 314, self.height );
}

- (void)dataDidChanged
{
    CART_GOODS * goods = self.data;
    
    $(_cartCell).FIND(@"#cart-goods-price").TEXT(goods.goods_price);
    $(_cartCell).FIND(@"#cart-goods-photo").IMAGE(goods.img.thumbURL);
    $(_cartCell).FIND(@"#cart-goods-title").TEXT(goods.goods_name);
    $(_cartCell).FIND(@"#cart-goods-info").TEXT( [self attrString:goods] );
    
    _editCell.data = self.data;
    _tempCount = goods.goods_number;
    
    self.editing = NO;
}

- (NSString *)attrString:(CART_GOODS *)goods
{
    NSMutableString * string = [NSMutableString string];

    if ( goods.goods_attr.count )
    {
        for ( GOOD_ATTR * attr in goods.goods_attr )
        {
            string.APPEND( @"%@:%@ | ", attr.name, attr.value );
        }
    }
    
    string.APPEND( @" %@:%@", __TEXT(@"amount"), goods.goods_number );
    
    return string;
}

- (void)setEditing:(BOOL)editing
{
    _editing = editing;
    
	$(_cartCell).FIND(@"#action").DATA( _editing ? __TEXT(@"shopcaritem_done") : __TEXT(@"collect_compile") );

    [UIView animateWithDuration:0.35f animations:^{
        _editCell.x = _editing ? _container.width - _editCell.width: _container.width;;
        _cartCell.x = _editing ? -_editCell.width : 0;
    }];
}

ON_SIGNAL2( BeeUITextField, signal )
{
    [super handleUISignal:signal];

    if ( [signal is:BeeUITextField.RETURN] )
    {
        [self endEditing:YES];
    }
}

ON_SIGNAL2( CartBoardCell_iPhone , signal )
{
    [super handleUISignal:signal];
    
    if ( [signal is:self.CART_REMOVE_DONE] )
    {
        self.editing = NO;
    }
}

ON_SIGNAL3( CartGoodCell_iPhone, action, signal )
{
    [super handleUISignal:signal];
    
    if( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
        self.editing = !self.editing;
        
        if ( self.editing )
        {
            [self sendUISignal:self.CART_EDIT_BEGAN];
        }
        else
        {
            BOOL isChanged = _tempCount.integerValue != self.count.integerValue;
            [self sendUISignal:self.CART_EDIT_DONE withObject:@(isChanged)];
        }
    }
}

- (NSNumber *)count
{
    return _editCell.count;
}

@end

#pragma mark -

@interface CartBoard_iPhone()
{
    BeeUIImageView *            _header;
	BeeUIScrollView *           _scroll;
    CartCheckoutCell_iPhone *   _checkoutCell;
}
@end

#pragma mark -

@implementation CartBoard_iPhone

SUPPORT_RESOURCE_LOADING( NO );
SUPPORT_AUTOMATIC_LAYOUT( NO );

DEF_SIGNAL( REMOVE_CONFIRM )
DEF_SIGNAL( REMOVE_CANCEL )

- (void)load
{
    [super load];

    self.cartModel = [CartModel sharedInstance];
    [self.cartModel addObserver:self];
    
    self.addressModel = [[[AddressModel alloc] init] autorelease];
    [self.addressModel addObserver:self];
    
    self.editingState = [NSMutableArray array];
}

- (void)unload
{
    [self.cartModel removeObserver:self];
    self.cartModel = nil;
    
    [self.addressModel removeObserver:self];
    self.addressModel = nil;
    
    self.editingState = nil;
    
    [super unload];
}

#pragma mark -

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{        
        self.titleString = __TEXT(@"shopcar_shopcar");
        
        [self showNavigationBarAnimated:NO];
        
        _scroll = [[BeeUIScrollView alloc] init];
		_scroll.dataSource = self;
        [_scroll showHeaderLoader:YES animated:NO];
        [self.view addSubview:_scroll];
        
        $(_scroll.headerLoader).FIND(@"#bg").SHOW();
        $(_scroll.headerLoader).FIND(@"#logo").SHOW();
        $(_scroll.headerLoader).FIND(@"#state").HIDE();
        $(_scroll.headerLoader).FIND(@"#date").HIDE();
		
		_header = [[BeeUIImageView alloc] initWithImage:[UIImage imageNamed:@"shopping-cart-body-bg-01.png"]];
        _header.hidden = YES;
		_header.alpha = 0.9f;
        [self.view addSubview:_header];

		[self observeNotification:UserModel.LOGIN];
		[self observeNotification:UserModel.LOGOUT];
		[self observeNotification:UserModel.KICKOUT];
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
		[self unobserveAllNotifications];
		
		SAFE_RELEASE_SUBVIEW( _scroll );
	}
	else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{
        _header.frame = CGRectMake( 0, 0, 320, 15 );
        _scroll.frame = CGRectMake( 0, 10, self.view.width, self.view.height - 10 );
        [_scroll setBaseInsets:UIEdgeInsetsMake(0, 0, [AppBoard_iPhone sharedInstance].tabbar.height, 0)];
    }
    else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
    {
    }
    else if ( [signal is:BeeUIBoard.FREE_DATAS] )
    {
    }
    else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
    {
        [self reloadData];
        
        if ( nil == self.previousBoard )
        {
			[self hideBarButton:BeeUINavigationBar.LEFT];
			
            [[AppBoard_iPhone sharedInstance] setTabbarHidden:NO];
			
			if ( [UserModel online] )
			{
				[self.cartModel fetchFromServer];
			}
        }
		else
		{
			[self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav-back.png"]];

			[[AppBoard_iPhone sharedInstance] setTabbarHidden:YES];
		}
    }
    else if ( [signal is:BeeUIBoard.DID_APPEAR] )
    {
        		
    }
    else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
    {
        if ( nil == self.previousBoard )
        {
            [[AppBoard_iPhone sharedInstance] setTabbarHidden:YES];
        }
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
        
    }
}

ON_SIGNAL2( BeeUIScrollView, signal )
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIScrollView.HEADER_REFRESH] )
	{
		[[self cartModel] fetchFromServer];
	}
}

ON_SIGNAL3( CartCheckoutCell_iPhone, checkout, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE])
    {
        if ( self.currentCell.editing )
        {
//            [self presentMessageTips:@"请先完成修改"];
        }
        else
        {
            [_addressModel fetchFromServer];
        }
    }
}

ON_SIGNAL2( CartBoardCell_iPhone, signal )
{
    CART_GOODS * goods = signal.sourceCell.data;
		
    if ( [signal.sourceCell isKindOfClass:[CartBoardCell_iPhone class]] )
    {
        self.currentCell = (CartBoardCell_iPhone *)signal.sourceCell;
    }
    else if ( [signal.sourceCell isKindOfClass:[CartEditCell_iPhone class]] )
    {
        self.currentCell = (CartBoardCell_iPhone *)signal.sourceCell.superview.superview;
    }
    
    if ( [signal is:CartBoardCell_iPhone.CART_EDIT_DONE] )
    {
        [self.editingState removeObject:goods.rec_id];
    
        if ( 0 == self.editingState.count )
        {
            $(_checkoutCell).FIND(@"#checkout").ENABLE();
        }
        
        BOOL isChanged = ((NSNumber *)signal.object).boolValue;
        
        if ( isChanged )
        {
            [self.cartModel update:goods new_number: self.currentCell.count];
        }
    }
    else if ( [signal is:CartBoardCell_iPhone.CART_REMOVE_DONE] )
    {
        BeeUIAlertView * alert = [BeeUIAlertView spawn];
        alert.title = __TEXT(@"shopcaritem_remove");
        alert.message = __TEXT(@"delete_confirm");
        [alert addButtonTitle:__TEXT(@"button_no") signal:self.REMOVE_CANCEL];
        [alert addButtonTitle:__TEXT(@"button_yes") signal:self.REMOVE_CONFIRM object:@{@"goods":goods}];
        [alert showInViewController:self];
    }
    else if ( [signal is:CartBoardCell_iPhone.CART_EDIT_BEGAN] )
    {
        [self.editingState addObject:goods.rec_id];
        
        $(_checkoutCell).FIND(@"#checkout").DISABLE();
    }
}

ON_SIGNAL2( CartBoard_iPhone, signal )
{
    CART_GOODS * goods = [(NSDictionary *)signal.object objectForKey:@"goods"];
        
    if ( [signal is:self.REMOVE_CANCEL] )
    {
        self.currentCell.editing = YES;
        $(_checkoutCell).FIND(@"#checkout").DISABLE();
    }
    else if ( [signal is:self.REMOVE_CONFIRM] )
    {
        $(_checkoutCell).FIND(@"#checkout").ENABLE();
        [self.editingState removeObject:goods.rec_id];
        [self.cartModel remove:goods];
    }
}

ON_SIGNAL3( BeeUIScrollView, RELOADED, signal )
{
	[super handleUISignal:signal];
	
	[self syncViewStates];
}

- (void)reloadData
{
	[self syncViewStates];
	
    if ( [UserModel online] )
    {
        [self.cartModel fetchFromServer];
    }
	else
	{
//		[[AppBoard_iPhone sharedInstance] showLogin];
		[_scroll asyncReloadData];
	}
}

- (void)syncViewStates
{
	if ( [UserModel online] )
    {
        [_scroll showHeaderLoader:YES animated:YES];
		[_scroll setScrollEnabled:YES];
	}
	else
	{
        [_scroll showHeaderLoader:NO animated:YES];
		[_scroll setScrollEnabled:NO];
	}
}

#pragma mark -

ON_NOTIFICATION3( UserModel, LOGIN, notification )
{
	[self syncViewStates];
	[self.cartModel fetchFromServer];
}

ON_NOTIFICATION3( UserModel, LOGOUT, notification )
{
	[self syncViewStates];
}

ON_NOTIFICATION3( UserModel, KICKOUT, notification )
{
	[self syncViewStates];
}

#pragma mark -

- (void)handleMessage:(BeeMessage *)msg
{
    [super handleMessage:msg];
    
    if ( [msg is:API.cart_list] )
    {
        if ( msg.sending )
        {
            if ( NO == self.cartModel.loaded )
            {
//                [self presentLoadingTips:__TEXT(@"tips_loading")];
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
            [self.editingState removeAllObjects];
            $(_checkoutCell).FIND(@"#checkout").ENABLE();
            [_scroll asyncReloadData];
        }
        else if ( msg.failed )
        {
//            [self presentFailureTips:@"加载失败"];
			[ErrorMsg presentErrorMsg:msg inBoard:self];
        }
    }
    else if ( [msg is:API.cart_delete] )
    {
        if ( msg.sending )
        {
            [self presentLoadingTips:__TEXT(@"tips_removing")];
        }
		else
		{
            [self dismissTips];
		}
		
        if ( msg.succeed )
        {
            [_scroll asyncReloadData];
			
			[self.cartModel fetchFromServer];
        }
        else if ( msg.failed )
        {
			[ErrorMsg presentErrorMsg:msg inBoard:self];
        }
    }
    else if ( [msg is:API.address_list] )
    {
        if ( msg.sending )
        {
//            [self presentLoadingTips:__TEXT(@"tips_loading")];
        }
		else
		{
            [self dismissTips];
		}
		
		if ( msg.succeed )
        {
            if ( self.addressModel.address.count )
            {
                CheckoutBoard_iPhone * board = [CheckoutBoard_iPhone board];
                [self.stack pushBoard:board animated:YES];
            }
            else
            {
                AddAddressBoard_iPhone * board = [AddAddressBoard_iPhone board];
                board.shouldShowMessage = YES;
                [self.stack pushBoard:board animated:YES];
            }
            
        }
        else if ( msg.failed )
        {
			[ErrorMsg presentErrorMsg:msg inBoard:self];
        }
    }
    else if( [msg is:API.cart_update] )
    {
        if ( msg.sending )
        {
            [self presentLoadingTips:__TEXT(@"tips_modifying")];
        }
		else
		{
			[self dismissTips];
		}
        
        if ( msg.succeed )
        {
            STATUS * status = msg.GET_OUTPUT( @"status" );
            
            if ( status.succeed.boolValue )
            {
                [self reloadData];
            }
			
			[self.cartModel fetchFromServer];
        }
        else if ( msg.failed )
        {
            [ErrorMsg presentErrorMsg:msg inBoard:self];
//            [self reloadData];
        }
    }
}

#pragma mark -

- (NSInteger)numberOfLinesInScrollView:(BeeUIScrollView *)scrollView
{
	return 1;
}

- (NSInteger)numberOfViewsInScrollView:(BeeUIScrollView *)scrollView
{
    if ( !self.cartModel.loaded )
    {
        return 1; // 0;
    }
    
    NSUInteger count = self.cartModel.goods.count;
    if ( 0 == count )
    {
        count = 1;
        _header.hidden = YES;
        [_scroll showHeaderLoader:NO animated:NO];
    }
    else
    {
        count = count + 1;
        _header.hidden = NO;
        [_scroll showHeaderLoader:YES animated:NO];
    }
    
    return count;
}

- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index scale:(CGFloat)scale
{
    if ( !self.cartModel.loaded )
    {
        return [scrollView dequeueWithContentClass:[CartEmptyCell class]];
    }

    NSUInteger count = self.cartModel.goods.count;
    if ( 0 == count )
    {
		return [scrollView dequeueWithContentClass:[CartEmptyCell class]];
    }
    else
    {
        if ( count == index )
        {   
            BeeUICell * cell = [scrollView dequeueWithContentClass:[CartCheckoutCell_iPhone class]];
            _checkoutCell = (CartCheckoutCell_iPhone *)cell;
            $(cell).FIND(@".cart-cell-wrapper-bg").IMAGE(@"shopping-cart-body-bg-02.png");
            cell.data = self.cartModel.total;
            return cell;
        }
        else
        {
            BeeUICell * cell = [scrollView dequeueWithContentClass:[CartBoardCell_iPhone class]];
            $(cell).FIND(@".cart-cell-wrapper-bg").IMAGE(@"shopping-cart-body-bg-03.png");
            cell.data = [self.cartModel.goods safeObjectAtIndex:index];
            return cell;
        }
    }
}

- (CGSize)scrollView:(BeeUIScrollView *)scrollView sizeForIndex:(NSInteger)index
{
	if ( !self.cartModel.loaded )
    {
        return self.viewBound.size;
    }

    CGSize size = CGSizeZero;    
    NSUInteger count = self.cartModel.goods.count;
    
    if ( 0 == count )
    {
        size = self.viewBound.size;
    }
    else
    {
        if ( count == index )
        {
            size = [CartCheckoutCell_iPhone estimateUISizeByWidth:scrollView.width forData:self.cartModel.total];
        }
        else
        {
            id data = [self.cartModel.goods safeObjectAtIndex:(index-1)];
            size = [CartBoardCell_iPhone estimateUISizeByWidth:scrollView.width forData:data];
        }
    }
    
	return size;
}

@end
