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

#import "GoodsSpecifyBoard_iPhone.h"
#import "GoodsDetailBoard_iPhone.h"
#import "CartBoard_iPhone.h"
#import "AppBoard_iPhone.h"
#import "UITagList.h"


@implementation SpecifyButton

DEF_SIGNAL( TOUCHED )

- (void)load
{
    [super load];
    
    _button = [[[BeeUIButton alloc] initWithFrame:CGRectZero] autorelease];
    UIImage * image = [[UIImage imageNamed:@"button-red.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 30, 10, 30)];
    [_button setBackgroundImage:image forState:UIControlStateNormal];
    _button.signal = self.TOUCHED;
    [self addSubview:_button];
}

- (void)unload
{
    _button = nil;
    
    [super unload];
}

- (void)layoutDidFinish
{
     _button.frame = CGRectMake( 5, 0, self.width - 10, self.height );
}

- (void)dataDidChanged
{
    _button.title = self.data;
}

+ (CGSize)estimateUISizeByWidth:(CGFloat)width forData:(id)data
{
    return CGSizeMake( width, 44 );
}

@end

@implementation SpecifyCountCell

DEF_SIGNAL( COUNT_CHANGED )

- (void)load
{
    [super load];
    
    _minus = [[[BeeUIButton alloc] initWithFrame:CGRectZero] autorelease];
    [_minus setImage:[UIImage imageNamed:@"item-info-buy-choose-min-btn.png"] forState:UIControlStateNormal];
    [_minus addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_minus];
    
    _input = [[[BeeUITextField alloc] initWithFrame:CGRectZero] autorelease];
    _input.textAlignment = NSTextAlignmentCenter;
    _input.enabled = NO;
    _input.backgroundImage = [[UIImage imageNamed:@"item-info-buy-choose-num-bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [self addSubview:_input];
    
    _pluss = [[[BeeUIButton alloc] initWithFrame:CGRectZero] autorelease];
    [_pluss addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
    [_pluss setImage:[UIImage imageNamed:@"item-info-buy-choose-sum-btn.png"] forState:UIControlStateNormal];
    [self addSubview:_pluss];
}

- (void)unload
{
    _minus = nil;
    _input = nil;
    _pluss = nil;
    
    [super unload];
}

- (void)dataDidChanged
{
    _input.text = [self.data description];
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
        _input.text = [NSString stringWithFormat:@"%d", (count + 1)];
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

@interface GoodsSpecifyBoardCellData : NSObject
@property (nonatomic, retain) NSArray *  tags;
@property (nonatomic, retain) GOOD_SPEC * spec;
@end

@implementation GoodsSpecifyBoardCellData
@end

#pragma mark -

@interface GoodsSpecifyBoardCell_iPhone()
@property (nonatomic, retain) UITagList * taglist;
@end

@implementation GoodsSpecifyBoardCell_iPhone

SUPPORT_RESOURCE_LOADING( YES );
SUPPORT_AUTOMATIC_LAYOUT( YES );

+ (CGSize)estimateUISizeByWidth:(CGFloat)width forData:(id)data expaned:(BOOL)expaned
{
    if ( expaned )
    {
        CGSize size = [GoodsSpecifyBoardCell_iPhone estimateUISizeByWidth:width forData:data];
        return size;
    }
    else
    {
        return CGSizeMake( width, 60.0f );
    }
}

- (void)load
{
    [super load];
    
    UIImage * imageNoraml = [[UIImage imageNamed:@"item-info-buy-kinds-btn-grey.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 20, 5, 30)];
    UIImage * imageSelected = [[UIImage imageNamed:@"item-info-buy-kinds-active-btn.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 20, 5, 30)];
    
    _taglist = (UITagList *)$(@"#taglist").view;
    _taglist.normalImage = imageNoraml;
    _taglist.selectedImage = imageSelected;
}

- (void)dataDidChanged
{
    if ( self.data )
    {
        GoodsSpecifyBoardCellData * data = self.data;
        
        $(@"#taglist").DATA( data.tags );
        
        NSString * attrType = nil;
        
        if ( data.spec.attr_type.intValue == ATTR_TYPE_SINGLE )
        {
            _taglist.isRadio = YES;
            attrType = __TEXT(@"single");
        }
        else if ( data.spec.attr_type.intValue == ATTR_TYPE_MULTI )
        {
            _taglist.isRadio = NO;
            attrType = __TEXT(@"multiple");
        }
        else if ( data.spec.attr_type.intValue == ATTR_TYPE_UNIQUE )
        {
            _taglist.isRadio = YES;
            attrType = __TEXT(@"unique");
        }

        NSString * title = [NSString stringWithFormat:@"%@(%@)", data.spec.name, attrType];
        
        $(@"#title").DATA( title );
    }
    else
    {
        
    }
}

@end

@interface GoodsSpecifyBoard_iPhone()
{
    BeeUIScrollView * _scroll;
    BeeUIImageView * _background;
}
@property (nonatomic, retain) NSMutableArray * taglistData;
@end

@implementation GoodsSpecifyBoard_iPhone

DEF_SIGNAL( SPEC_DONE )
DEF_SIGNAL( SPEC_SAVE )
DEF_SIGNAL( SPEC_CANCEL )

- (void)load
{
	[super load];
    
    self.taglistData = [[[NSMutableArray alloc] init] autorelease];
    self.specs = [[[NSMutableArray alloc] init] autorelease];
}

- (void)unload
{
    [self.taglistData removeAllObjects];
    self.taglistData = nil;
    
    [self.specs removeAllObjects];
    self.specs = nil;
    
	[super unload];
}

#pragma mark -


ON_SIGNAL2( BeeUIBoard, signal )
{
    [super handleUISignal:signal];
    
    if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
    {
        self.titleString = __TEXT(@"select_specification");
        
        self.view.backgroundColor = HEX_RGBA( 0x000, 0.6f );
        
        self.modalBack = [[[BeeUIButton alloc] init] autorelease];
        self.modalBack.signal = @"back";
        [self.view addSubview:self.modalBack];

        _background = [[BeeUIImageView alloc] init];
        _background.image = [UIImage imageNamed:@"item-graph-cont-box-bg.png"].stretched;
        _background.autoresizesSubviews = YES;
		_background.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		_background.contentMode = UIViewContentModeScaleToFill;

        [self.view addSubview:_background];
        
        _scroll = [[BeeUIScrollView alloc] init];
		_scroll.dataSource = self;
		_scroll.vertical = YES;
		[self.view addSubview:_scroll];
    }
    else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
    {   
        SAFE_RELEASE_SUBVIEW( _scroll );
        SAFE_RELEASE_SUBVIEW( _background );
		
		self.modalBack = nil;
    }
    else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
    {
        CGRect scrollFrame = self.viewBound ;
        scrollFrame.size.width -= 20;
        
        int height = _scroll.contentSize.height;
        
        if ( height > self.viewBound.size.height * 0.6f ) {
            height = self.viewBound.size.height * 0.6f;
        }
            
        scrollFrame.size.height = height;
        
        scrollFrame.origin.x = ( self.viewBound.size.width - scrollFrame.size.width ) / 2;
        scrollFrame.origin.y = ( self.viewBound.size.height - scrollFrame.size.height ) / 2;
        
        _scroll.frame = scrollFrame;
        
        scrollFrame.origin.y -= 5;
        scrollFrame.size.height += 10;
        
        _background.frame = scrollFrame;
        
        self.modalBack.frame = self.viewBound;
    }
    else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
    {
        [self buildData];
    }
    else if ( [signal is:BeeUIBoard.FREE_DATAS] )
    {
    }
    else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
    {
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

- (void)dismissSelf
{
    if ( IOS7_OR_LATER )
    {
        [self.parentBoard dismissModalBoardAnimated:YES];
    }
    else
    {
        [self.parentBoard dismissModalStackAnimated:YES];
    }
}

ON_SIGNAL2( back , signal )
{
    [self dismissSelf];
}

ON_SIGNAL3( SpecifyButton, TOUCHED, signal )
{
    GoodsDetailBoard_iPhone * board = (GoodsDetailBoard_iPhone *)self.parentBoard;
    [board.specs removeAllObjects];
    [board.specs addObjectsFromArray:self.specs];
    board.count = self.count;
    
    [self dismissSelf];
}

ON_SIGNAL3( UITagListCell, button, signal )
{
    [super handleUISignal:signal];
    
    UITagListCell * cell = (UITagListCell *)signal.sourceCell;
    
    if ( [signal is:[BeeUIButton TOUCH_UP_INSIDE]] )
    {
        GOOD_SPEC_VALUE * data = (GOOD_SPEC_VALUE *)cell.data;
        
        if ( data.spec.attr_type.integerValue != ATTR_TYPE_MULTI )
        {
            [self addSingleSpec:data];
        }
        else
        {
            [self addMutiSpec:data];
        }
    }
}

ON_SIGNAL3( SpecifyCountCell, COUNT_CHANGED, signal )
{
    self.count = ((SpecifyCountCell *)signal.source).count;
}

#pragma mark -

- (void)addSingleSpec:(GOOD_SPEC_VALUE *)data
{
    if ( 0 == self.specs.count )
    {
        [self.specs addObject:data];
        return;
    }
    
    NSArray * values = [NSArray arrayWithArray:self.specs];
    
    for ( int i = 0; i < values.count; i++ )
    {
        GOOD_SPEC_VALUE * spec_value = values[i];
        
        if ( [spec_value.spec.name isEqualToString:data.spec.name] )
        {
            [self.specs replaceObjectAtIndex:i withObject:data];
        }
    }
}

- (void)addMutiSpec:(GOOD_SPEC_VALUE *)data
{
    if ( 0 == self.specs.count )
    {
        [self.specs addObject:data];
        return;
    }
    
    NSArray * values = [NSArray arrayWithArray:self.specs];
    
    BOOL found = NO;
    
    for ( int i = 0; i < values.count; i++ )
    {
        GOOD_SPEC_VALUE * spec_value = values[i];
        
        if ( spec_value.value.id.integerValue == data.value.id.integerValue )
        {
            [self.specs removeObjectAtIndex:i];
            found = YES;
            break;
        }
    }
    
    if ( NO == found )
    {
        [self.specs addObject:data];
    }
}

- (BOOL)hasSingleSpec:(GOOD_SPEC_VALUE *)data
{
    BOOL found = NO;
    
    NSArray * values = [NSArray arrayWithArray:self.specs];
    
    for ( int i = 0; i < values.count; i++ )
    {
        GOOD_SPEC_VALUE * spec_value = values[i];
        
        if ( [spec_value.spec.name isEqualToString:data.spec.name] )
        {
            found = YES;
            break;
        }
    }
    
    return found;
}

#pragma mark -

- (void)buildData
{
    if ( self.goods.specification.count > 0 )
    {
        for ( GOOD_SPEC * spec in self.goods.specification )
        {
            NSMutableArray * tags = [NSMutableArray array];
            
            for ( GOOD_VALUE * value in spec.value )
            {
                GOOD_SPEC_VALUE * spec_value = [[[GOOD_SPEC_VALUE alloc] init] autorelease];
                spec_value.value = value;
                spec_value.spec = spec;
                            
                if ( spec_value.spec.attr_type.integerValue != ATTR_TYPE_MULTI )
                {
                    if ( NO == [self hasSingleSpec:spec_value] )
                    {
                        [self addSingleSpec:spec_value];
                    }
                }
                
                [tags addObject:spec_value];
            }
            
            GoodsSpecifyBoardCellData * data = [[[GoodsSpecifyBoardCellData alloc] init] autorelease];
            data.spec = spec;
            data.tags = [NSArray arrayWithArray:tags];
            [self.taglistData addObject:data];
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
    NSUInteger section = 0;
    
	section += self.taglistData.count;
    section += 1;
    section += 1;
    
	return section;
}

- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index scale:(CGFloat)scale
{
    NSUInteger section = 0;
    
	section += self.taglistData.count;
    
    if ( index < section )
	{
        GoodsSpecifyBoardCell_iPhone * cell = [scrollView dequeueWithContentClass:[GoodsSpecifyBoardCell_iPhone class]];
        
        cell.data = [self.taglistData safeObjectAtIndex:index];
        
        if ( self.specs.count )
        {
            cell.taglist.selectedTags = self.specs;
        }
        
        return cell;
	}
	   
    section += 1;
    
    if ( index < section )
    {
        SpecifyCountCell * cell = [scrollView dequeueWithContentClass:[SpecifyCountCell class]];
        cell.data = self.count;
        return cell;
    }
    
    section += 1;
    
    if ( index < section )
    {
        SpecifyButton * cell = [scrollView dequeueWithContentClass:[SpecifyButton class]];
        cell.data = __TEXT(@"dialog_ensure");
        return cell;
    }
    
    return nil;
}

- (CGSize)scrollView:(BeeUIScrollView *)scrollView sizeForIndex:(NSInteger)index
{
    CGSize size = CGSizeZero;
    
    NSUInteger section = 0;
    
	section += self.taglistData.count;
    
    if ( index < section )
	{
        size = [GoodsSpecifyBoardCell_iPhone estimateUISizeByWidth:scrollView.width forData:[self.taglistData objectAtIndex:index]];
        return size;
	}
    
    section += 1;
    
    if ( index < section )
    {
        size = [SpecifyCountCell estimateUISizeByWidth:scrollView.width forData:self.count];
        return size;
    }
    
    section += 1;
    
    if ( index < section )
    {
        size = [SpecifyButton estimateUISizeByWidth:scrollView.width forData:__TEXT(@"dialog_ensure")];
        return size;
    }
    
	return size;
}

@end
