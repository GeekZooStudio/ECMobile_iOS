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
#import "UITagList.h"
#import <QuartzCore/QuartzCore.h>
#import "NSObject+TagList.h"

#pragma mark - UITagListCell

@interface UITagListCell()
@property (nonatomic, retain) BeeUILabel *  label;
@property (nonatomic, retain) BeeUIButton * button;
- (void)configWithImage:(UIImage *)normal selected:(UIImage *)selected;
@end

@implementation UITagListCell

SUPPORT_AUTOMATIC_LAYOUT(YES);
SUPPORT_RESOURCE_LOADING(YES);

+ (id)cellWithData:(id)data
{
    UITagListCell * cell = [[[UITagListCell alloc] init] autorelease];
    cell.data = data;
    return cell;
}

- (void)load
{
    [super load];
    
    _button = (BeeUIButton *)$(@"#button").view;
    
    _label = (BeeUILabel *)$(@"#label").view;
    _label.userInteractionEnabled = NO;
    
    [_label setTextColor:[UIColor blackColor]];
    [_label setShadowColor:[UIColor whiteColor]];
    [_label setShadowOffset:CGSizeMake(0.0f, 1.0f)];
    [_label setTextAlignment:NSTextAlignmentCenter];
    [_label setBackgroundColor:[UIColor clearColor]];
}

- (void)dataDidChanged
{
    if ( self.data )
    {
        [self changeData:self.data];
    }
}

- (void)changeData:(id)data
{
    if ( [data isKindOfClass:[NSString class]] )
    {
        $(@"#label").DATA( data );
    }
    else if ( [data isKindOfClass:[NSObject class]] )
    {
        if ( [data respondsToSelector:@selector(tagTitle)] )
        {
            $(@"#label").DATA( [data performSelector:@selector(tagTitle) withObject:nil] );
        }
    }
}

- (void)setSelected:(BOOL)selected
{
    _button.selected = selected;
}

- (BOOL)selected
{
    return _button.selected;
}

- (void)configWithImage:(UIImage *)normal selected:(UIImage *)selected
{
    [_button setBackgroundImage:normal   forState:UIControlStateNormal];
    [_button setBackgroundImage:selected forState:UIControlStateSelected];
}

@end

#pragma mark - UITagList

@interface UITagList()
@property (nonatomic, retain) NSMutableArray * cells;
@property (nonatomic, retain) NSMutableArray * selectedCells;
@end

@implementation UITagList

- (void)dealloc
{
    self.tags          = nil;
    self.selectedCells = nil;
    
    [super dealloc];
}

- (id)initSelf
{
    if (self)
    {
        self.isRadio       = NO;
        self.clipsToBounds = YES;
        self.tagHeight     = 30.0f;
        self.tagMargin     = UIEdgeInsetsMake(5, 5, 0, 5);
        self.selectedCells = [NSMutableArray array];
    }
    
    return self;
}

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

#pragma mark - display

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self estimateByWidth:self.width layouted:YES];
}

- (CGSize)estimateByWidth:(CGFloat)width layouted:(BOOL)layouted
{
    CGSize realSize  = CGSizeZero;
    CGRect lastFrame = CGRectZero;
    
    if ( self.tags && self.tags.count )
    {
        for ( UITagListCell * cell in self.cells )
        {
            CGSize cellSize = [UITagListCell estimateUISizeByHeight:self.tagHeight forData:cell.data];
            
            CGRect newFrame = lastFrame;
            
            CGFloat right = cellSize.width;
            right += lastFrame.origin.x + lastFrame.size.width;
            right += self.tagMargin.left + self.tagMargin.right;
            
            if ( right > width )
            {
                newFrame.origin.x = self.tagMargin.left;
                newFrame.origin.y = lastFrame.origin.y + lastFrame.size.height + self.tagMargin.top;
            }
            else
            {
                newFrame.origin.x = lastFrame.origin.x + lastFrame.size.width + self.tagMargin.left;
                newFrame.origin.y = lastFrame.origin.y;
            }
            
            newFrame.size = cellSize;
            
            if ( layouted )
            {
                cell.frame = newFrame;
            }
            
            newFrame.size.width += self.tagMargin.right;
            newFrame.size.height += self.tagMargin.bottom;
            
            lastFrame = newFrame;
        }
    }
    
    realSize.width = self.frame.size.width;
    realSize.height = lastFrame.origin.y + lastFrame.size.height;
    
    self.realSize = realSize;
    
    return realSize;
}

- (NSArray *)selectedTags
{
    NSMutableArray * array = [NSMutableArray array];
    
    for ( UITagListCell * tagCell in self.selectedCells )
    {
        [array addObject:tagCell.data];
    }
    
    return [NSArray arrayWithArray:array];
}

- (void)setSelectedTags:(NSArray *)selectedTags
{
    if ( selectedTags && selectedTags.count )
    {
        for ( UITagListCell * cell in self.cells )
        {
            if ( [cell.data respondsToSelector:@selector(tagRecipt)] )
            {
                NSString * tagRecipt = [cell.data performSelector:@selector(tagRecipt) withObject:nil];
                
                for ( NSObject * obj in selectedTags )
                {
                    NSString * recipt = nil;
                    
                    if ( [obj isKindOfClass:[NSString class]] )
                    {
                        recipt = (NSString *)obj;
                    }
                    else if ( [obj isKindOfClass:[NSNumber class]] )
                    {
                        recipt = [obj description];
                    }
                    else if ( [obj isKindOfClass:[NSObject class]] )
                    {
                        recipt = obj.tagRecipt;
                    }
                    
                    if ( [recipt isEqualToString:tagRecipt] )
                    {
                        cell.selected = YES;
                        
                        if ( self.isRadio )
                        {
                            return;
                        }
                    }
                }
            }
        }
    }
}

- (void)setTags:(NSArray *)tags
{
    if ( _tags != tags )
    {
        [tags retain];
        [_tags release];
        _tags = tags;
    }
    
    if ( self.cells == nil )
    {
        self.cells = [NSMutableArray array];
    }
    else
    {
        [self.cells removeAllObjects];
    }
    
    for ( UIView * view in self.subviews )
    {
        if ( [view isKindOfClass:[UITagListCell class]] )
        {
            [view removeFromSuperview];
        }
    }
    
    for ( id tag in self.tags )
    {
        UITagListCell * cell = [UITagListCell cellWithData:tag];
        [cell configWithImage:self.normalImage selected:self.selectedImage];
        [self addSubview:cell];
        [self.cells addObject:cell];
    }
}

#pragma mark -

- (void)bindData:(id)data
{
    if ( data )
    {
        self.tags = data;
        [self setNeedsLayout];
    }
}

- (CGSize)estimateUISizeByWidth:(CGFloat)width
{
    CGSize size = [self estimateByWidth:width layouted:NO];
    return size;
}

ON_SIGNAL3( UITagListCell, button, signal )
{
    [super handleUISignal:signal];
    
    UITagListCell * cell = (UITagListCell *)signal.sourceCell;
    
    if ( [signal is:[BeeUIButton TOUCH_UP_INSIDE]] )
    {
        if ( self.isRadio )
        {
            for ( UITagListCell * tagCell in self.cells )
            {
                tagCell.selected = NO;
            }
            // Radio tagList keeps only one object
            [self.selectedCells removeAllObjects];
        }
        
        cell.selected = !cell.selected;
        
        if ( cell.selected )
        {
            [self.selectedCells addObject:cell];
        }
        else
        {
            // if it's exist and selected, then to be removed
            if ( NSNotFound != [self.selectedCells indexOfObject:cell] )
            {
                [self.selectedCells removeObject:cell];
            }
        }
    }
}

@end
