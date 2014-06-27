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
//	Powered by BeeFramework
//

#import "C0_ShoppingCartCell_iPhone.h"
#import "C0_ShoppingCartEditCell_iPhone.h"
#import "C0_ShoppingCartGoodCell_iPhone.h"

#pragma mark -

@interface C0_ShoppingCartCell_iPhone()
{
    NSString * _tempCount;
}
@end

@implementation C0_ShoppingCartCell_iPhone

SUPPORT_RESOURCE_LOADING( YES );
SUPPORT_AUTOMATIC_LAYOUT( YES );

DEF_SIGNAL( CART_EDIT_DONE )
DEF_SIGNAL( CART_EDIT_BEGAN )
DEF_SIGNAL( CART_REMOVE )

+ (CGSize)estimateUISizeByWidth:(CGFloat)width forData:(id)data
{
    CGSize size = CGSizeMake(320, 130);
    return  size;
}

- (void)load
{
    _editing = NO;
    
    _container = [[BeeUICell alloc] initWithFrame:CGRectZero];
    [self addSubview:_container];
    
    _cartCell = [[C0_ShoppingCartGoodCell_iPhone alloc] initWithFrame:CGRectZero];
    [_container addSubview:_cartCell];
    
    UIImage * image = [[UIImage imageNamed:@"shopping_cart_body_bg_03.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    _background = [[BeeUIImageView alloc] initWithFrame:CGRectZero];
    _background.contentMode = UIViewContentModeScaleToFill;
    _background.image  = image;
    [self insertSubview:_background atIndex:0];
    
    _editCell = [[C0_ShoppingCartEditCell_iPhone alloc] initWithFrame:CGRectZero];
    [_container addSubview:_editCell];
}

- (void)layoutDidFinish
{
    _container.frame = CGRectMake(10, 0, 300, self.height);
    _cartCell.frame = CGRectMake( 0, 0, _container.width, _container.height );
    _editCell.frame = CGRectMake( _container.width, 0, 150, _container.height - 1 );
    _editCell.x = _editing ? _container.width - _editCell.width: _container.width;
    _cartCell.x = _editing ? -_editCell.width : 0;
    _background.frame = CGRectMake( 3, 0, 314, self.height );
}

- (void)dataDidChanged
{
    CART_GOODS * goods = self.data;
    
    $(_cartCell).FIND(@"#cart-goods-price").TEXT(goods.subtotal);
    $(_cartCell).FIND(@"#cart-goods-photo").IMAGE(goods.img.thumbURL);
    $(_cartCell).FIND(@"#cart-goods-title").TEXT(goods.goods_name);
    $(_cartCell).FIND(@"#cart-goods-info").TEXT( [self attrString:goods] );
    
    _editCell.data = self.data;
    _tempCount = goods.goods_number;
    
    [self setEditing:goods.scrollEditing animated:NO];
}

- (NSString *)attrString:(CART_GOODS *)goods
{
    NSMutableString * string = [NSMutableString string];
    
    if ( goods.goods_attr.count )
    {
        for ( GOOD_ATTR * attr in goods.goods_attr )
        {
            [string appendFormat:@"%@:%@ | ", attr.name, attr.value];
        }
    }

    [string appendFormat:@" %@:%@", __TEXT(@"amount"), goods.goods_number];
    
    return string;
}

- (void)setEditing:(BOOL)editing
{
    [self setEditing:editing animated:YES];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    _editing = editing;
    
	$(_cartCell).FIND(@"#action").DATA( _editing ? __TEXT(@"shopcaritem_done") : __TEXT(@"collect_compile") );
    
    if ( animated )
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
    }
    
    _editCell.x = _editing ? _container.width - _editCell.width: _container.width;;
    _cartCell.x = _editing ? -_editCell.width : 0;

    if ( animated )
    {
        [UIView commitAnimations];
    }
}

#pragma mark - BeeUITextField

ON_SIGNAL2( BeeUITextField, signal )
{
    if ( [signal is:BeeUITextField.RETURN] )
    {
        [self endEditing:YES];
    }
}

#pragma mark - C0_ShoppingCartCell_iPhone

/**
 * 购物车-商品列表-移除商品，点击事件触发时执行的操作
 */
ON_SIGNAL3( C0_ShoppingCartCell_iPhone, CART_REMOVE, signal )
{
    self.editing = NO;
}

#pragma mark - C0_ShoppingCartGoodCell_iPhone

/**
 * 购物车-商品列表-编辑（非编辑状态）/完成（编辑状态）按钮，点击事件触发时执行的操作
 */
ON_SIGNAL3( C0_ShoppingCartGoodCell_iPhone, action, signal )
{
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
