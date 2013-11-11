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

#import "FormView.h"
#import "AppBoard_iPhone.h"
#import "WebViewBoard_iPhone.h"

@implementation FormElement

@synthesize text = _text;
@synthesize isSecure = _isSecure;

+ (Class)classWithObject:(FormElement *)object
{
    Class clazz = nil;
    return clazz;
}

+ (id)customWithClass:(Class)clazz
{
    FormElement * e = [[[FormElement alloc] init] autorelease];
    e.clazz = [FormCustomCell class];
    e.customClazz = clazz;
    return e;
}

+ (id)cell
{
    FormElement * e = [[[FormElement alloc] init] autorelease];
    e.clazz = [FormCell class];
    return e;
}

+ (id)input
{
    FormElement * e = [[[FormElement alloc] init] autorelease];
    e.clazz = [FormInputCell class];
    return e;
}

+ (id)check
{
    FormElement * e = [[[FormElement alloc] init] autorelease];
    e.clazz = [FormCheckCell class];
    return e;
}

+ (id)button
{
    FormElement * e = [[[FormElement alloc] init] autorelease];
    e.clazz = [FormButton class];
    return e;
}

+ (id)subtitleCell
{
    FormElement * e = [[[FormElement alloc] init] autorelease];
    e.clazz = [FormSubtitleCell class];
    return e;
}

+ (id)subtitleWithTitle:(NSString *)title
{
    FormElement * e = [[[FormElement alloc] init] autorelease];
    e.clazz = [FormSubtitleCell class];
    e.title = title;
    return e;    
}

+ (id)detailCell
{
    FormElement * e = [[[FormElement alloc] init] autorelease];
    e.clazz = [FormDetailCell class];
    return e;
}

+ (id)switchr
{
    FormElement * e = [[[FormElement alloc] init] autorelease];
    e.clazz = [FormSwitchCell class];
    return e;
}

- (id)init
{
    self = [super init];
    
    if ( self )
    {
        self.enable = YES;
    }
    
    return self;
}

- (void)setData:(id)data
{
	[data retain];
	[_data release];
	_data = data;
	
    [self.customView setData:data];
}

- (void)setEnable:(BOOL)enable
{
    _enable = enable;
    
    if ( enable )
    {
        self.view.textLabel.textColor = [UIColor darkGrayColor];
        self.view.accessoryView.hidden = NO;
    }
    else
    {
        self.view.textLabel.textColor = [UIColor colorWithWhite:0.8f alpha:1.0f];
        self.view.accessoryView.hidden = YES;
    }
}

- (NSString *)text
{
    if ( self.clazz == [FormInputCell class] )
    {
        FormInputCell * cell = (FormInputCell *)self.view;
        return cell.input.text;
    }
    
    return nil;
}

- (void)setText:(NSString *)text
{
    [text retain];
    [_text release];
    _text = text;
    
    if ( self.clazz == [FormInputCell class] )
    {
        FormInputCell * cell = (FormInputCell *)self.view;
        cell.input.text = text;
    }
}

- (void)setTitle:(NSString *)title
{
	[title retain];
	[_title release];
	_title = title;
	
    self.view.textLabel.text = title;
}

- (void)setSubtitle:(NSString *)subtitle
{
	[subtitle retain];
	[_subtitle release];
	_subtitle = subtitle;
    
    self.view.detailTextLabel.text = subtitle;
    
}

- (void)setPlaceholder:(NSString *)placeholder
{
	[placeholder retain];
	[_placeholder release];
	_placeholder = placeholder;
  
    if ( self.clazz == [FormInputCell class] )
    {
        ((FormInputCell *)self.view).input.placeholder = _placeholder;
    }
}

- (void)setIsSecure:(BOOL)isSecure
{
    _isSecure = isSecure;
    
    if ( self.clazz == [FormInputCell class] )
    {
        ((FormInputCell *)self.view).input.secureTextEntry = isSecure;
    }
}

@end

@implementation FormCounter

DEF_SIGNAL( COUNT_CHANGE );

- (void)dealloc
{
    _label = nil;
    _minus = nil;
    _input = nil;
    _pluss = nil;
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if ( self )
    {
        _label = [[[BeeUILabel alloc] initWithFrame:CGRectZero] autorelease];
        _label.textColor = [UIColor darkGrayColor];
        _label.textAlignment = NSTextAlignmentLeft;
        _label.font = [UIFont systemFontOfSize:16.0f];
        [self.contentView addSubview:_label];
        
        _minus = [[[BeeUIButton alloc] initWithFrame:CGRectZero] autorelease];
        [_minus setImage:[UIImage imageNamed:@"item-info-buy-choose-min-btn.png"] forState:UIControlStateNormal];
        [_minus addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_minus];
        
        _input = [[[BeeUITextField alloc] initWithFrame:CGRectZero] autorelease];
        _input.textAlignment = NSTextAlignmentCenter;
        _input.backgroundImage = [[UIImage imageNamed:@"item-info-buy-choose-num-bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        [self.contentView addSubview:_input];
        
        _pluss = [[[BeeUIButton alloc] initWithFrame:CGRectZero] autorelease];
        [_pluss addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
        [_pluss setImage:[UIImage imageNamed:@"item-info-buy-choose-sum-btn.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:_pluss];
    }
    
    return self;
}

- (void)setData:(id)data
{
    [super setData:data];
    _label.text = [data objectAtIndex:1];
    _input.text = [[data objectAtIndex:2] description];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _label.frame = CGRectMake( 10, 10, self.contentView.width - 20, 20 );
    _minus.frame = CGRectMake( 15, 40, 30, 25 );
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
}

+ (CGSize)estimateUISizeByWidth:(CGFloat)width forData:(id)data
{
    CGFloat height = 80;
    
    return CGSizeMake( width, height );
}

- (NSNumber *)count
{
    return [NSNumber numberWithInt:_input.text.integerValue];
}

@end

@implementation FormCheckCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    
    if ( self )
    {
        self.accessoryView = [[[BeeUIImageView alloc] initWithImage:[UIImage imageNamed:@"accsessory-check.png"]] autorelease];
        self.accessoryView.hidden = YES;
    }
    return self;
}

@end

@implementation FormDetailCell

+ (CGSize)estimateUISizeByWidth:(CGFloat)width forData:(id)data
{
    NSString * str1 = [data objectAtIndex:1];
    NSString * str2 = [data objectAtIndex:2];
    
    CGFloat height1 = [str1 sizeWithFont:[UIFont systemFontOfSize:14] byWidth:100].height;
    CGFloat height2 = [str2 sizeWithFont:[UIFont systemFontOfSize:14] byWidth:190].height;
    
    CGFloat height = MAX( height1, height2 );
    
    return CGSizeMake( width, MAX( height, 44.0f) );
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    _label1 = [[[BeeUILabel alloc] init] autorelease];
    _label1.textColor = [UIColor blackColor];
    _label1.numberOfLines = 0;
    _label1.textAlignment = NSTextAlignmentRight;
    _label1.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_label1];
    
    _label2 = [[[BeeUILabel alloc] init] autorelease];
    _label2.textColor = [UIColor darkGrayColor];
    _label2.numberOfLines = 0;
    _label2.textAlignment = NSTextAlignmentLeft;
    _label2.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_label2];
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _label1.frame = CGRectMake( 0, 0, 100, self.contentView.height );
    _label2.frame = CGRectMake( 110, 0, 190, self.contentView.height );
}

- (void)setElement:(FormElement *)element
{
    _label1.text = element.title;
    _label2.text = element.subtitle;
}

- (void)dealloc
{
    _label1 = nil;
    _label2 = nil;
    [super dealloc];
}

@end

@implementation FormSubtitleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    
    if ( self )
    {
        self.accessoryView = [[[BeeUIImageView alloc] initWithImage:[UIImage imageNamed:@"accsessory-arrow-right.png"]] autorelease];
    }
    return self;
}

@end

@implementation FormButton

DEF_SIGNAL( TOUCHED )

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if ( self )
    {
        _button = [[[BeeUIButton alloc] initWithFrame:CGRectZero] autorelease];
        UIImage * image = [[UIImage imageNamed:@"button-red.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 30, 10, 30)];
        [_button setBackgroundImage:image forState:UIControlStateNormal];
        [self.contentView addSubview:_button];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _button.frame = CGRectMake( (self.contentView.width - self.element.size.width) / 2,
                               (self.contentView.height - self.element.size.height) / 2,
                               self.element.size.width, self.element.size.height );
}

- (void)setElement:(FormElement *)element
{
    [super setElement:element];
    
    if ( CGSizeEqualToSize( CGSizeZero, self.element.size ) )
    {
        self.element.size = self.frame.size;
    }
        
    self.textLabel.text = nil;

    [self.button setTitle:element.title forState:UIControlStateNormal];
    
    if ( self.element.backgroundImage )
    {
        UIImage * image = [UIImage imageFromString:self.element.backgroundImage
                                         stretched:UIEdgeInsetsMake(10, 10, 10, 10)];
        [self.button setBackgroundImage:image
                               forState:UIControlStateNormal];
    }
    
    if ( self.element.image )
    {
        UIImage * image = [UIImage imageNamed:self.element.image];
        [self.button setImage:image forState:UIControlStateNormal];
    }
    
    if ( element.signal )
    {
        [_button addSignal:element.signal forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [_button addSignal:self.TOUCHED forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)dealloc
{
    _button = nil;
    
    [super dealloc];
}

@end

@implementation FormInputCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if ( self )
    {
        _input = [[[BeeUITextField alloc] initWithFrame:CGRectZero] autorelease];
        _input.returnKeyType = UIReturnKeyDone;
        _input.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.contentView addSubview:_input];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    int padding = 10;
    _input.frame = CGRectMake( padding, padding, self.contentView.width - 2 * padding, self.contentView.height - 2 * padding );
}

- (void)setElement:(FormElement *)element
{
    [super setElement:element];
    
    _input.placeholder = element.placeholder;
    _input.keyboardType = element.keyboardType;
    _input.secureTextEntry = element.isSecure;
    
    if ( element.returnKeyType == UIReturnKeyDefault )
    {
        _input.returnKeyType = UIReturnKeyNext;
    }
    else
    {
        _input.returnKeyType = element.returnKeyType;
    }
}

- (void)dealloc
{
    _input = nil;
    
    [super dealloc];
}

@end

@implementation FormSwitchCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if ( self )
    {
        _switchr = [[[BeeUISwitch alloc] init] autorelease];
        [self.contentView addSubview:_switchr];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if ( IOS7_OR_LATER )
    {
        _switchr.frame = CGRectMake( self.contentView.width - 65 , 7 , 75, self.contentView.height );
    }
    else
    {
        _switchr.frame = CGRectMake( self.contentView.width - 85 , 10 , 75, self.contentView.height );
    }
}

- (void)setElement:(FormElement *)element
{
    [super setElement:element];
    
    _switchr.on = element.enable;
}

- (void)dealloc
{
    _switchr = nil;
    
    [super dealloc];
}

@end

@implementation FormCustomCell

- (void)setElement:(FormElement *)element
{
    [super setElement:element];
    
    if ( _customView == nil )
    {
        _customView = [[[[element customClazz] alloc] init] autorelease];
        _customView.data = element.data;
        [self addSubview:_customView];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _customView.frame = CGRectMake(0, 0, self.width, self.height);
}

- (void)dealloc
{
    _customView = nil;
    [super dealloc];
}

@end

@implementation FormCell

- (void)setElement:(FormElement *)element
{
	[element retain];
	[_element release];
	_element = element;
    
    self.tagString = element.tagString;
    
    if ( element.title )
    {
        self.textLabel.text = element.title;
		self.textLabel.font = [UIFont systemFontOfSize:16.0f];
    }
    
    if ( element.subtitle )
    {
        self.detailTextLabel.text  = element.subtitle;
        self.detailTextLabel.textColor = [UIColor blackColor];
		self.detailTextLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    
    if ( element.isNecessary )
    {
        UIImageView * icon = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-necessary.png"]] autorelease];
        CGSize size = [self.textLabel estimateUISizeByHeight:self.textLabel.height];
        icon.left = size.width + 20.0f;
        icon.top = ( self.contentView.height - icon.height ) / 2;
        [self.contentView addSubview:icon];
    }
}

+ (CGSize)estimateUISizeByWidth:(CGFloat)width forData:(id)data
{
    return [self estimateUISizeByHeight:44.f forData:data];
}

@end

@implementation FormViewBoard(private)

@end

@implementation FormViewBoard

DEF_INT(CELL_TYPE_MIXED, 0);
DEF_INT(CELL_TYPE_CHECK, 1);
DEF_INT(CELL_TYPE_RADIO, 2);
DEF_INT(CELL_TYPE_STACK, 3);
DEF_INT(CELL_TYPE_DETAIL, 4);

- (NSString *)valueByQuery:(NSString *)string
{
   return ((FormInputCell *)$(self.table).FIND(string).view).input.text;
}

- (void)load
{
	[super load];
    
    self.style = UITableViewStyleGrouped;
}

- (void)unload
{
//    [_datas removeAllObjects];
//    [_datas release];
    
	[super unload];
}

#pragma mark [B] UISignal

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        self.titleString = @"设置";
        
        [self showNavigationBarAnimated:NO];
        [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav-back.png"]];
        [self showBarButton:BeeUINavigationBar.RIGHT title:__TEXT(@"bill_save") image:[UIImage imageNamed:@"nav-right.png"]];

		self.view.backgroundColor = [UIImage imageNamed:@"body-bg.png"].patternColor;
        
        _table = [[UITableView alloc] initWithFrame:self.view.frame style:self.style];
        
        if ( !IOS7_OR_LATER )
        {
            if ( self.style == UITableViewStyleGrouped )
            {
                _table.backgroundView = nil;
                _table.backgroundColor = [UIImage imageNamed:@"index-body-bg.png"].patternColor;
            }
        }
        
        _table.delegate = self;
        _table.dataSource = self;
        [self.view addSubview:_table];
        
        [self observeNotification:BeeUIKeyboard.SHOWN];
        [self observeNotification:BeeUIKeyboard.HIDDEN];
        [self observeNotification:BeeUIKeyboard.HEIGHT_CHANGED];
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
		[self unobserveAllNotifications];
		
		SAFE_RELEASE_SUBVIEW( _table );
	}
	else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{
		_table.frame = self.viewBound;
	}
    else if ( [signal is:BeeUIBoard.DID_APPEAR] )
    {
    }
	else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
	{
	}
	else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
	{
	}
    else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
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
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeZero;
    
    FormElement * element = self.datas[indexPath.section][indexPath.row];

    if ( element )
    {
        if ( element.clazz == [FormCustomCell class] )
        {
            size = [element.customClazz estimateUISizeByWidth:tableView.width forData:element.data];
        }
        else
        {
            size = [element.clazz estimateUISizeByWidth:tableView.width forData:element.data];
        }
        return size.height;
    }
    else
    {
        return 44.0f;
    }

}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.titles safeObjectAtIndex:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return _datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return ((NSArray *)[_datas objectAtIndex:section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FormElement * element = [[_datas objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    Class clazz = [element clazz];
    
    NSString * cellIdentifier = [clazz description];
    
    FormCell * cell = (FormCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if (cell == nil)
    {   
        cell = [[[clazz alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.element = element;
        
        element.view = cell;
        element.enable = element.enable;
        
        if ( clazz == [FormCustomCell class] )
        {
            element.customView = ((FormCustomCell *)cell).customView;
            element.customView.data = element.data;
        }
    }
    
    // customize the cell's background
    
    if ( self.style == UITableViewStyleGrouped )
    {
        int cellCount = [(NSArray *)[_datas objectAtIndex:indexPath.section] count];
        
        if ( [clazz isSubclassOfClass:[FormButton class]] ||
            [clazz isSubclassOfClass:[FormCustomCell class]] )
        {
            cell.backgroundView = [[[UIView alloc] init] autorelease];
        }
        else
        {
            if ( cellCount == 1 )
            {
                UIImageView * backgroundView = [[[UIImageView alloc] initWithFrame:cell.frame] autorelease];
                backgroundView.image = [[UIImage imageNamed:@"cell-bg-single.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
                cell.backgroundView = backgroundView;
            }
            else
            {
                if ( IOS7_OR_LATER )
                {
                    CGRect frame = cell.accessoryView.frame;
                    frame.origin.x -= 10;
                    cell.accessoryView.frame = frame;
                }
                else
                {
                    UIImageView * backgroundView = [[[UIImageView alloc] initWithFrame:cell.frame] autorelease];
                    
                    if ( indexPath.row == 0 )
                    {
                        backgroundView.image = [[UIImage imageNamed:@"cell-bg-header.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
                        
                    }
                    else if ( indexPath.row == (cellCount - 1) )
                    {
                        backgroundView.image = [[UIImage imageNamed:@"cell-bg-footer.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
                    }
                    else
                    {
                        backgroundView.image = [[UIImage imageNamed:@"cell-bg-content.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
                    }
                    cell.backgroundView = backgroundView;
                }
            }
        }
        
        cell.backgroundColor = [UIColor clearColor];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

	return cell;
}

- (void)reloadData
{
    [self.table reloadData];
}

- (NSArray *)inputs
{
    NSMutableArray * inputs = [NSMutableArray array];

    for ( FormCell * cell in self.table.visibleCells )
    {
        if ( [cell isKindOfClass:[FormInputCell class]] )
        {
            [inputs addObject:((FormInputCell *)cell).input];
        }
    }
    
    return [NSArray arrayWithArray:inputs];
}


@end
