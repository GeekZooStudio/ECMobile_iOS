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

#import "Bee.h"
#import "ecmobile.h"

#pragma mark -
    
@interface Slide_iPhone : BeeUICell
{
    BeeUIImageView *    _photo;
    BeeUIZoomView *     _zoomView;
}
@end

#pragma mark -

@interface SlideBoard_iPhone : BeeUIBoard
{
    BeeUIButton *       _navBackButton;
    BeeUICell *     _navBackground;

//    BeeUILabel *        _hoverTitle;
    BeeUILabel *        _hoverContent;
    BeeUICell *     _hoverBackground;
    
    BeeUIScrollView *	_scroll;
    
    NSObject *          _currentSlide;
    BOOL                _isHoverHidden;
}

@property (nonatomic, retain) NSArray *				data;
@property (nonatomic, retain) GOODS *				goods;
@property (nonatomic, assign) NSUInteger			pageIndex;
@property (nonatomic, retain) BeeUIPageControl *	pageControl;

@end
