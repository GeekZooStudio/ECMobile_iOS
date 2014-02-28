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

#import "B2_ProductSpecifyCountCell_iPhone.h"

#pragma mark -

@implementation B2_ProductSpecifyCountCell_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_SIGNAL( COUNT_CHANGED )

- (void)load
{
    _minus = [[[BeeUIButton alloc] initWithFrame:CGRectZero] autorelease];
    [_minus setImage:[UIImage imageNamed:@"item_info_buy_choose_min_btn.png"] forState:UIControlStateNormal];
    [_minus addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_minus];
    
    _input = [[[BeeUITextField alloc] initWithFrame:CGRectZero] autorelease];
    _input.textColor = [UIColor lightGrayColor];
    _input.textAlignment = NSTextAlignmentCenter;
    _input.enabled = NO;
    _input.text = @"1";
    _input.background = [UIImage imageNamed:@"item_info_buy_choose_num_bg.png"];
    [self addSubview:_input];
    
    _pluss = [[[BeeUIButton alloc] initWithFrame:CGRectZero] autorelease];
    [_pluss addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
    [_pluss setImage:[UIImage imageNamed:@"item_info_buy_choose_sum_btn.png"] forState:UIControlStateNormal];
    [self addSubview:_pluss];
}

- (void)unload
{
    _minus = nil;
    _input = nil;
    _pluss = nil;
}

- (void)dataDidChanged
{
    if ( self.data )
    {
        _input.text = [self.data[@"count"] stringValue];
        self.max = [self.data[@"maximum"] integerValue];
    }
    else
    {
        _input.text = @"1";
        self.max = 1;
    }
}

- (void)layoutDidFinish
{
    _minus.frame = CGRectMake( 85, 20, 30, 25 );
    _input.frame = CGRectMake( _minus.right, _minus.top, 60, 25 );
    _pluss.frame = CGRectMake( _input.right, _minus.top, 30, 25 );
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
        if ( count < self.max )
        {
            _input.text = [NSString stringWithFormat:@"%d", (count + 1)];
        }
    }
    
    [self sendUISignal:self.COUNT_CHANGED];
}

+ (CGSize)estimateUISizeByWidth:(CGFloat)width forData:(id)data
{
    return CGSizeMake( width, 64 );
}

- (NSNumber *)count
{
    return [NSNumber numberWithInt:_input.text.integerValue];
}

@end
