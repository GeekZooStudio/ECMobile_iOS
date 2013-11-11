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
	
#import "InvoiceBoard_iPhone.h"
#import "CheckoutBoard_iPhone.h"
#import "AppBoard_iPhone.h"

#pragma mark -

@interface InvoiceBoard_iPhone()
{
    FormElement * _input;
}

@end

@implementation InvoiceBoard_iPhone

#pragma mark -
- (void)load
{
	[super load];
        
    self.selectedIndexPathes = [NSMutableArray array];
}

- (void)unload
{
//    [self.datas removeAllObjects];
//    [self.datas release];
//    
    [self.selectedIndexPathes removeAllObjects];
	self.selectedIndexPathes = nil;

	self.datas = nil;
    
	[super unload];
}

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{		
        self.titleString = __TEXT(@"balance_bill");
        
        [self observeNotification:BeeUIKeyboard.SHOWN];
        [self observeNotification:BeeUIKeyboard.HIDDEN];
        [self observeNotification:BeeUIKeyboard.HEIGHT_CHANGED];
	}
    else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
        [self unobserveAllNotifications];
        
        SAFE_RELEASE( _input );
    }
    else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
    {
    }
	else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
	{
		[[AppBoard_iPhone sharedInstance] setTabbarHidden:YES];
        
        if ( self.inv_type_list.count )
        {
            NSMutableArray * group1 = [NSMutableArray array];
            
            for ( INVOICE * invoice in self.inv_type_list )
            {
                FormElement * element = [FormElement check];
                element.title = invoice.value;
                element.data = invoice;
                [group1 addObject:element];
            }
            
            NSMutableArray * group2 = [NSMutableArray array];
            
            for ( INVOICE * invoice in self.inv_content_list )
            {
                FormElement * element = [FormElement check];
                element.title = invoice.value;
                element.data = invoice;
                [group2 addObject:element];
            }
            
            _input = [FormElement input];
            _input.placeholder = __TEXT(@"bill_title");
            _input.returnKeyType = UIReturnKeyDone;
            NSArray * group3 = @[ _input ];
            
            self.datas = [NSMutableArray arrayWithObjects:group1, group2, group3,nil];
            
            [self reloadData];
        }

	}
    else if ( [signal is:BeeUIBoard.DID_APPEAR] )
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
        CheckoutBoard_iPhone * board = (CheckoutBoard_iPhone *)self.previousBoard;
        board.flowModel.done_inv_payee = _input.text;
        [self.stack popBoardAnimated:YES];
    }
}

ON_SIGNAL2( BeeUITextField, signal )
{
	[super handleUISignal:signal];
    
    if ( [signal is:BeeUITextField.WILL_ACTIVE] )
    {
        [self.table setContentOffset:CGPointMake(0, 140) animated:YES];
    }
    else
    if ( [signal is:BeeUITextField.RETURN] )
    {    
        [self.view endEditing:YES];
    }
}

#pragma mark -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CheckoutBoard_iPhone * board = (CheckoutBoard_iPhone *)self.previousBoard;
    
    FormElement * element = [[self.datas objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    INVOICE * invoice = element.data;
    
    if ( 0 == indexPath.section )
    {
        board.flowModel.done_inv_type = invoice.id;
    }
    else if ( 1 == indexPath.section )
    {
        board.flowModel.done_inv_content = invoice.value;
    }
    
    [self reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CheckoutBoard_iPhone * board = (CheckoutBoard_iPhone *)self.previousBoard;

    FormCell * cell = (FormCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    FormElement * element = [[self.datas objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    INVOICE * invoice = element.data;
    
    if ( 0 == indexPath.section )
    {
        if ( board.flowModel.done_inv_type == invoice.id )
        {
            cell.accessoryView.hidden = NO;
        }
        else
        {
            cell.accessoryView.hidden = YES;
        }
    }
    else if ( 1 == indexPath.section )
    {
        if ( [board.flowModel.done_inv_content isEqualToString:invoice.value] )
        {
            cell.accessoryView.hidden = NO;
        }
        else
        {
            cell.accessoryView.hidden = YES;
        }
    }
    else if ( 2 == indexPath.section )
    {
        _input.text = board.flowModel.done_inv_payee;
    }
    
    return cell;
}

- (void)handleNotification_BeeUIKeyboard_SHOWN:(NSNotification *)notification
{
    [super handleNotification:notification];
    
    CGFloat keyboardHeight = [BeeUIKeyboard sharedInstance].height;
    
    CGFloat offsetHeight = [BeeSystemInfo isPhoneRetina4] ? 140 : 10;
    
    [UIView animateWithDuration:0.35f animations:^{
        [self.table setContentInset:UIEdgeInsetsMake(0, 0, keyboardHeight - offsetHeight, 0)];
    }];
}

- (void)handleNotification_BeeUIKeyboard_HEIGHT_CHANGED:(NSNotification *)notification
{
    [super handleNotification:notification];
    
    CGFloat keyboardHeight = [BeeUIKeyboard sharedInstance].height;
    
    CGFloat offsetHeight = [BeeSystemInfo isPhoneRetina4] ? 140 : 10;
    
    [UIView animateWithDuration:0.35f animations:^{
        [self.table setContentInset:UIEdgeInsetsMake(0, 0, keyboardHeight - offsetHeight, 0)];
    }];
}

- (void)handleNotification_BeeUIKeyboard_HIDDEN:(NSNotification *)notification
{
    [super handleNotification:notification];
    
    [UIView animateWithDuration:0.35f animations:^{
        [self.table setContentInset:UIEdgeInsetsZero];
    }];
}



@end
