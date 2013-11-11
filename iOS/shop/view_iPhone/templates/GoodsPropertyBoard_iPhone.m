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
	
#import "GoodsPropertyBoard_iPhone.h"
#import "AppBoard_iPhone.h"

#pragma mark -

@implementation GoodsPropertyBoard_iPhone

- (void)load
{
	[super load];
    
//    [[UIApplication sharedApplication] openURL:<#(NSURL *)#>]
    
    self.datas = [NSMutableArray array];
}

- (void)unload
{
    [self.datas removeAllObjects];
	self.datas = nil;
    
	[super unload];
}

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        [self showNavigationBarAnimated:YES];
        
        [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav-back.png"]];
        [self showBarButton:BeeUINavigationBar.RIGHT image:[UIImage imageNamed:@"item-info-header-share-icon.png"]];
        self.titleString = __TEXT(@"product_specification");
        
        [self hideBarButton:[BeeUINavigationBar RIGHT]];
	}
    else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
    }
    else if ( [signal is:BeeUIBoard.DID_APPEAR] )
    {
    }
    else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
    {
		[[AppBoard_iPhone sharedInstance] setTabbarHidden:YES];
    }
    else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
    {
        self.titleString = self.goods.goods_name;
        
        if ( self.goods.properties.count > 0 )
        {
            NSMutableArray * group = [NSMutableArray array];
            
            for ( GOOD_ATTR * goodAttr in self.goods.properties )
            {
                FormElement * element = [FormElement detailCell];
                element.title = goodAttr.name;
                element.subtitle = goodAttr.value;
                [group addObject:element];
            }
            
            [self.datas addObject:group];
        }
    }
}

ON_SIGNAL2( BeeUINavigationBar, signal )
{
	[super handleUISignal:signal];

    if ( [signal is:BeeUINavigationBar.LEFT_TOUCHED] )
    {
        [self.stack popBoardAnimated:YES];
    }
}

@end
