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
	
#import "HelpBoard_iPhone.h"
#import "HelpEntryBoard_iPhone.h"
#import "AppBoard_iPhone.h"

#pragma mark -

@implementation HelpBoard_iPhone

- (void)load
{
	[super load];
    
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
        self.titleString = __TEXT(@"balance_pay");
        [self hideBarButton:[BeeUINavigationBar RIGHT]];
	}
    else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
    }
    else if ( [signal is:BeeUIBoard.DID_APPEAR] )
    {
        if ( 0 == self.articleGroup.article.count )
        {
            [self presentFailureTips:__TEXT(@"no_data")];
            [self.stack performSelector:@selector(popBoardAnimated:) withObject:@(YES) afterDelay:2.0f];
        }
    }
    else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
    {
		[[AppBoard_iPhone sharedInstance] setTabbarHidden:YES];
    }
    else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
    {
        self.titleString = self.articleGroup.name;
        
        if ( self.articleGroup.article.count )
        {
            NSMutableArray * group = [NSMutableArray array];
            
            for ( ARTICLE * article in self.articleGroup.article )
            {
                FormElement * element = [FormElement subtitleCell];
                element.title = article.title;
                element.data = article;
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

#pragma mark -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ARTICLE * article  = ((FormElement *)self.datas[indexPath.section][indexPath.row]).data;
	HelpEntryBoard_iPhone * board = [HelpEntryBoard_iPhone board];
	board.articleModel.article_id = article.id;
	board.articleModel.article_title = article.title;
	[self.stack pushBoard:board animated:YES];
}

@end
