//
//  B3_ProductPhotoBoard_iPhone.m
//

#import "AppBoard_iPhone.h"
#import "B3_ProductPhotoBoard_iPhone.h"
#import "C0_ShoppingCartBoard_iPhone.h"
#import "D2_FilterBoard_iPhone.h"
#import "B2_ProductDetailBoard_iPhone.h"
#import "B3_ProductPhotoSlideCell_iPhone.h"

@implementation B3_ProductPhotoBoard_iPhone
{
    BeeUICell *		_navBackground;
    BeeUICell *		_hoverBackground;
    BOOL			_isHoverHidden;
}

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( BeeUIScrollView, list )
DEF_OUTLET( BeeUIPageControl, pager )

@synthesize goods = _goods;
@synthesize pageIndex = _pageIndex;

#pragma mark -

ON_CREATE_VIEWS( signal )
{
    self.navigationBarTitle = __TEXT(@"large_photo");
    
    [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav_back.png"]];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    @weakify(self);
    
    self.list.animationDuration = 0.25f;
    
    self.list.whenReloading = ^
    {
        @normalize(self);
        
        self.list.total = self.goods.pictures.count;
        
        for ( BeeUIScrollItem * item in self.list.items )
        {
            item.clazz = [B3_ProductPhotoSlideCell_iPhone class];
            item.size = self.list.size;
            item.data = [self.goods.pictures safeObjectAtIndex:item.index];
            item.rule = BeeUIScrollLayoutRule_Tile;
        }
    };
    self.list.whenReloaded = ^
    {
        @normalize(self);
        
        self.pager.numberOfPages = self.list.total;
        self.pager.currentPage = self.list.pageIndex;
    };
    self.list.whenStop = ^
    {
        @normalize(self);;
        
        self.pager.numberOfPages = self.list.total;
        self.pager.currentPage = self.list.pageIndex;
    };
}

ON_DELETE_VIEWS( signal )
{
    self.list = nil;
    
    self.pager = nil;
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
}

ON_DID_APPEAR( signal )
{
    [bee.ui.appBoard hideLogin];
	[self.list reloadData];
}

ON_WILL_DISAPPEAR( signal )
{
}

ON_DID_DISAPPEAR( signal )
{
}

ON_LOAD_DATAS( signal )
{
    self.navigationBarTitle = self.goods.goods_name;
}

#pragma mark -

ON_LEFT_BUTTON_TOUCHED( signal )
{
    [self.stack popBoardAnimated:YES];
}

ON_RIGHT_BUTTON_TOUCHED( signal )
{
}

#pragma mark - BeeUIZoomView

//ON_SIGNAL2( BeeUIZoomView, signal )
//{
//    if ( [signal is:BeeUIZoomView.SINGLE_TAPPED] )
//    {
//		CATransition * transition = [CATransition animation];
//		[transition setDuration:0.3f];
//		[transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
//		[transition setType:kCATransitionFade];
//		[self.view.layer addAnimation:transition forKey:nil];
//		
//        if ( _isHoverHidden )
//        {
//            _navBackground.hidden = YES;
//            _hoverBackground.hidden = YES;
//        }
//        else
//        {
//            _navBackground.hidden = NO;
//            _hoverBackground.hidden = NO;
//        }
//		
//        _isHoverHidden = !_isHoverHidden;
//    }
//}

@end
