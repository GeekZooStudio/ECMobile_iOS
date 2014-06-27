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
	
#import "D1_CategoryBoard_iPhone.h"
#import "D0_SearchBoard_iPhone.h"
#import "B1_ProductListBoard_iPhone.h"

#import "controller.h"
#import "model.h"
#import "D0_SearchCategory_iPhone.h"

#pragma mark -

@implementation D1_CategoryBoard_iPhone

SUPPORT_RESOURCE_LOADING( YES );
SUPPORT_AUTOMATIC_LAYOUT( YES );

DEF_OUTLET( BeeUIScrollView, list )

@synthesize category = _category;

- (void)load
{
}

- (void)unload
{
	self.category = nil;
}

#pragma mark -

ON_CREATE_VIEWS( signal )
{
    self.navigationBarTitle = self.category.name;
    [self showNavigationBarAnimated:NO];
    [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav_back.png"]];

    @weakify(self);
    
    self.list.lineCount = 1;
    self.list.animationDuration = 0.25f;
    
    self.list.whenReloading = ^
    {
        @normalize(self);
        
        self.list.total = self.category.children.count;
                
        for ( int i = 0; i < self.category.children.count; i++ )
        {
            BeeUIScrollItem * item = self.list.items[i];
            item.clazz = [D0_SearchCategory_iPhone class];
            item.size = CGSizeMake( self.list.width, 44);
            item.data = [self.category.children safeObjectAtIndex:i];
            item.rule = BeeUIScrollLayoutRule_Tile;
        }
    };
}

ON_DELETE_VIEWS( signal )
{
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
    [self.list reloadData];
}

ON_DID_APPEAR( signal )
{
}

ON_WILL_DISAPPEAR( signal )
{
}

ON_DID_DISAPPEAR( signal )
{
}

#pragma mark -

ON_LEFT_BUTTON_TOUCHED( signal )
{
    [self.stack popBoardAnimated:YES];
}

ON_RIGHT_BUTTON_TOUCHED( signal )
{
}

#pragma mark - D0_SearchCategory_iPhone

ON_SIGNAL3( D0_SearchCategory_iPhone, mask, signal )
{
	CATEGORY * category = signal.sourceCell.data;
	
	B1_ProductListBoard_iPhone * board = [B1_ProductListBoard_iPhone board];
	board.category = category.name;
	board.searchByHotModel.filter.category_id = category.id;
	board.searchByCheapestModel.filter.category_id = category.id;
	board.searchByExpensiveModel.filter.category_id = category.id;
	[self.stack pushBoard:board animated:YES];
}

@end
