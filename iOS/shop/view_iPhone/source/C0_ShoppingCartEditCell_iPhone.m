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

#import "C0_ShoppingCartEditCell_iPhone.h"
#import "C0_ShoppingCartCell_iPhone.h"

#pragma mark -

@implementation C0_ShoppingCartEditCell_iPhone

SUPPORT_RESOURCE_LOADING( YES );
SUPPORT_AUTOMATIC_LAYOUT( YES );

- (void)load
{
    _minus = [[[BeeUIButton alloc] initWithFrame:CGRectZero] autorelease];
    [_minus setImage:[UIImage imageNamed:@"item_info_buy_choose_min_btn.png"] forState:UIControlStateNormal];
    [_minus addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_minus];
    
    _input = [[[BeeUITextField alloc] initWithFrame:CGRectZero] autorelease];
    _input.textColor = [UIColor lightGrayColor];
    _input.enabled = NO;
    _input.textAlignment = NSTextAlignmentCenter;
    _input.keyboardType = UIKeyboardTypeNumberPad;
    _input.background = [UIImage imageNamed:@"item_info_buy_choose_num_bg.png"];
    [self addSubview:_input];
    
    _pluss = [[[BeeUIButton alloc] initWithFrame:CGRectZero] autorelease];
    [_pluss addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
    [_pluss setImage:[UIImage imageNamed:@"item_info_buy_choose_sum_btn.png"] forState:UIControlStateNormal];
    [self addSubview:_pluss];
    
    _remove = [[[BeeUIButton alloc] initWithFrame:CGRectZero] autorelease];
    _remove.title = __TEXT(@"shopcaritem_remove");
    _remove.titleFont = [UIFont systemFontOfSize:14];
    _remove.titleColor = [UIColor blackColor];
    [_remove addTarget:self.superview action:@selector(remove:) forControlEvents:UIControlEventTouchUpInside];
    [_remove setBackgroundImage:[[UIImage imageNamed:@"shopping_cart_edit_remove_bg_grey.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
    [self addSubview:_remove];
    
    self.backgroundImage = [[UIImage imageNamed:@"shopping_cart_edit_remove_box.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    
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
    [self sendUISignal:C0_ShoppingCartCell_iPhone.CART_REMOVE];
}

@end
