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
	
#import "ShippingBoard_iPhone.h"
#import "CheckoutBoard_iPhone.h"
#import "AppBoard_iPhone.h"

#pragma mark -

@implementation ShippingBoard_iPhone

#pragma mark -

- (void)load
{
	[super load];
    self.datas = [NSMutableArray array];
}

- (void)unload
{
    self.datas = nil;
	[super unload];
}

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        self.titleString = __TEXT(@"balance_shipping");
        [self hideBarButton:BeeUINavigationBar.RIGHT];
	}
    else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
    }
    else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
    {
    }
    else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
    {
		[[AppBoard_iPhone sharedInstance] setTabbarHidden:YES];
    }
    else if ( [signal is:BeeUIBoard.DID_APPEAR] )
    {
        if ( self.shipping_list.count )
        {
            NSMutableArray * shippings = [NSMutableArray array];
            
            for ( SHIPPING * shipping in self.shipping_list )
            {
                FormElement * element = [FormElement check];
                element.title = shipping.shipping_name;
                element.subtitle = shipping.format_shipping_fee;
                element.data = shipping;
                
                [shippings addObject:element];
            }
            
            [self.datas addObject:shippings];
            [self reloadData];
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
    else if ( [signal is:BeeUINavigationBar.RIGHT_TOUCHED] )
    {
        // TODO
        [self.stack popBoardAnimated:YES];
    }
}

#pragma mark -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FormElement * element = self.datas[indexPath.section][indexPath.row];
    CheckoutBoard_iPhone * board = (CheckoutBoard_iPhone *)self.previousBoard;
    board.flowModel.done_shipping = element.data;
    self.selectedIndexPath = indexPath;
    [self.stack popBoardAnimated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FormCell * cell = (FormCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    SHIPPING * shipping = cell.element.data;
    CheckoutBoard_iPhone * board = (CheckoutBoard_iPhone *)self.previousBoard;
        
    if ( [board.flowModel.done_shipping.shipping_id isEqualToNumber:shipping.shipping_id] )
    {
        self.selectedIndexPath = indexPath;
    }
    
    cell.accessoryView.hidden = ( NSOrderedSame != [indexPath compare:self.selectedIndexPath] );
    
    return cell;
}

@end
