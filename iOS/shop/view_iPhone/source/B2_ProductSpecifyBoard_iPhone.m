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
//  Powered by BeeFramework
//

#import "B2_ProductSpecifyBoard_iPhone.h"
#import "B2_ProductDetailBoard_iPhone.h"
#import "C0_ShoppingCartBoard_iPhone.h"

#import "AppBoard_iPhone.h"

#import "CommonTagList.h"

#import "B2_ProductSpecifyButton_iPhone.h"
#import "B2_ProductSpecifyCountCell_iPhone.h"
#import "B2_ProductSpecifyCell_iPhone.h"

@implementation B2_ProductSpecifyBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( NO )
SUPPORT_RESOURCE_LOADING( YES )

//DEF_SIGNAL( SPEC_DONE )
//DEF_SIGNAL( SPEC_SAVE )
//DEF_SIGNAL( SPEC_CANCEL )

DEF_OUTLET( BeeUIButton, mask )
DEF_OUTLET( BeeUIImageView, background )
DEF_OUTLET( BeeUIScrollView, list )

- (void)load
{
    self.taglistData = [[[NSMutableArray alloc] init] autorelease];
    self.specs = [[[NSMutableArray alloc] init] autorelease];
}

- (void)unload
{
    [self.taglistData removeAllObjects];
    self.taglistData = nil;
    
    [self.specs removeAllObjects];
    self.specs = nil;
}

#pragma mark -

ON_CREATE_VIEWS( signal )
{
    self.navigationBarTitle = __TEXT(@"select_specification");
    
    self.view.backgroundColor = HEX_RGBA( 0x000, 0.6f );

    @weakify(self);
    
    self.list.lineCount = 1;
    self.list.animationDuration = 0.25f;
	self.list.showsVerticalScrollIndicator = YES;
    self.list.backgroundColor = [UIColor whiteColor];
    self.list.layer.cornerRadius = 10.f;
	
    self.list.whenReloading = ^
    {
        @normalize(self);
        
        self.list.total += self.taglistData.count;
        self.list.total += 1;
        self.list.total += 1;
        
        int offset = 0;
        
        for ( int i = 0; i < self.taglistData.count; i++ )
        {
            BeeUIScrollItem * item = self.list.items[ i + offset ];
            item.clazz = [B2_ProductSpecifyCell_iPhone class];
            item.data = [self.taglistData safeObjectAtIndex:i];
            item.size = CGSizeAuto;
            item.rule = BeeUIScrollLayoutRule_Tile;
        }
        
        offset += self.taglistData.count;
        
        BeeUIScrollItem * countItem = self.list.items[offset];
        countItem.clazz = [B2_ProductSpecifyCountCell_iPhone class];
        countItem.data = @{ @"count": self.count ?: @"1",
                            @"maximum": self.goods.goods_number ?: @"1" };
        countItem.size = CGSizeMake( self.list.width, 64 );
        countItem.rule = BeeUIScrollLayoutRule_Tile;
        
        offset += 1;
        
        BeeUIScrollItem * buttonItem = self.list.items[offset];
        buttonItem.clazz = [B2_ProductSpecifyButton_iPhone class];
        buttonItem.size = CGSizeMake( self.list.width, 49 );
        buttonItem.rule = BeeUIScrollLayoutRule_Tile;
    };
}

ON_WILL_APPEAR( signal )
{
	[self.list reloadData];
}

ON_LOAD_DATAS( signal )
{
    [self buildData];
}

#pragma mark -

ON_SIGNAL3( B2_ProductSpecifyBoard_iPhone, mask, signal )
{
    if ( self.whenCanceled )
    {
        self.whenCanceled();
    }
}

#pragma mark - B2_ProductSpecifyButton_iPhone

ON_SIGNAL3( B2_ProductSpecifyButton_iPhone, confirm, signal )
{
    if ( self.whenSpecified )
    {
        self.whenSpecified( self.specs, self.count );
    }
}

#pragma mark - CommonTagListCell

ON_SIGNAL3( CommonTagListCell, button, signal )
{
    CommonTagListCell * cell = (CommonTagListCell *)signal.sourceCell;
    
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

#pragma mark - B2_ProductSpecifyCountCell_iPhone

ON_SIGNAL3( B2_ProductSpecifyCountCell_iPhone, COUNT_CHANGED, signal )
{
    self.count = ((B2_ProductSpecifyCountCell_iPhone *)signal.source).count;
    
    if ( [self.count integerValue] == [self.goods.goods_number integerValue] )
    {
        [self presentFailureTips:__TEXT(@"understock")];
    }
}

#pragma mark -

- (void)setSpecsFromArray:(NSArray *)specs
{
    [self.specs removeAllObjects];
    [self.specs addObjectsFromArray:specs];
}

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
            data.selectedTags = self.specs;
            [self.taglistData addObject:data];
        }
    }
}

@end
