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

#import "AppBoard_iPhone.h"

#import "C4_InvoiceBoard_iPhone.h"
#import "C1_CheckOutBoard_iPhone.h"

#import "C4_InvoiceCell_iPhone.h"

@implementation C4_InvoiceBoard_iPhone

SUPPORT_RESOURCE_LOADING( YES );
SUPPORT_AUTOMATIC_LAYOUT( YES );

DEF_INT( SECTION_TYPE, 1 );
DEF_INT( SECTION_CONTENT, 2 );

DEF_OUTLET( BeeUITextField, input )
DEF_OUTLET( BeeUIScrollView, list )

#pragma mark -

ON_CREATE_VIEWS(signal)
{
    self.navigationBarShown = YES;
    self.navigationBarTitle = __TEXT(@"balance_bill");
    self.navigationBarLeft  = [UIImage imageNamed:@"nav_back.png"];
    [self showBarButton:BeeUINavigationBar.RIGHT title:__TEXT(@"save") image:[UIImage imageNamed:@"nav_right.png"]];
    
    [self observeNotification:BeeUIKeyboard.SHOWN];
    [self observeNotification:BeeUIKeyboard.HIDDEN];
    [self observeNotification:BeeUIKeyboard.HEIGHT_CHANGED];
    
    self.inv_type = self.flowModel.done_inv_type;
    self.inv_content = self.flowModel.done_inv_content;
    self.inv_title = self.flowModel.done_inv_payee;
    
    @weakify(self);
    
    self.list.whenReloading = ^{
        
        @normalize(self);
        
        NSArray * datas = self.flowModel.inv_type_list;
        NSArray * datas2 = self.flowModel.inv_content_list;

        int offset = 0;
        
        self.list.total += datas.count;
        
        for ( int i=0; i < datas.count; i++ )
        {
            CGSize size = ((datas.count - 1) == i) ? CGSizeMake( self.list.width, 70 ) :  CGSizeAuto;
            
            INVOICE * invoice      = [datas safeObjectAtIndex:i];
            invoice.scrollIndex    = i;
            invoice.scrollSection  = self.SECTION_TYPE;
            invoice.scrollSelected = self.inv_type && [invoice.id isEqualToNumber:self.inv_type];
            
            BeeUIScrollItem * item = self.list.items[i];
            item.clazz = [C4_InvoiceCell_iPhone class];
            item.rule  = BeeUIScrollLayoutRule_Line;
            item.size  = size;
            item.data  = invoice;
        }
        
        offset += datas.count;
        
        self.list.total += datas2.count;
        
        for ( int i=0; i < datas2.count; i++ )
        {
            INVOICE * invoice      = [datas2 safeObjectAtIndex:i];
            invoice.scrollIndex    = i;
            invoice.scrollSection  = self.SECTION_CONTENT;
            invoice.scrollSelected = self.inv_content && [invoice.value isEqualToString:self.inv_content];
            
            BeeUIScrollItem * item = self.list.items[(offset+i)];
            item.clazz = [C4_InvoiceCell_iPhone class];
            item.rule  = BeeUIScrollLayoutRule_Line;
            item.size  = CGSizeAuto;
            item.data  = invoice;
        }
        
        offset += datas2.count;
        
        self.list.total += 1;
        
        FormData * data = [FormData data];
        data.placeholder = __TEXT(@"bill_title");
        data.text = self.inv_title;
        
        BeeUIScrollItem * item = self.list.items[offset];
        item.clazz = [FormPlainInputCell class];
        item.rule  = BeeUIScrollLayoutRule_Line;
        item.size  = CGSizeAuto;
        item.data  = data;
    };
}

ON_DELETE_VIEWS(signal)
{
    [self unobserveAllNotifications];
}

ON_WILL_APPEAR(signal)
{
    [bee.ui.appBoard hideTabbar];
}

ON_DID_APPEAR( signal )
{
	[self.list reloadData];
}

ON_SIGNAL2( BeeUINavigationBar, signal )
{
    if ( [signal is:BeeUINavigationBar.LEFT_TOUCHED] )
    {
        [self.stack popBoardAnimated:YES];
    }
}

ON_SIGNAL3( BeeUITextField, WILL_ACTIVE, signal )
{
    self.input = ((FormPlainInputCell *)signal.sourceCell).input;
}

ON_RIGHT_BUTTON_TOUCHED(signal)
{
    self.inv_title = self.input.text;
    
    self.flowModel.done_inv_type = self.inv_type;
    self.flowModel.done_inv_payee = self.inv_title;
    self.flowModel.done_inv_content = self.inv_content;
    
    [self.stack popBoardAnimated:YES];
}

#pragma mark - BeeUITextField

ON_SIGNAL3( BeeUITextField, RETURN, signal )
{
    [self.view endEditing:YES];
}

#pragma mark - FormPlainOptionCell

ON_SIGNAL3( FormPlainOptionCell, mask, signal )
{
    INVOICE * invoice = signal.sourceCell.data;
    
    if ( 1 == invoice.scrollSection )
    {
        self.inv_type = invoice.id;
    }
    else if ( 2 == invoice.scrollSection )
    {
        self.inv_content = invoice.value;
    }
    
    self.inv_title = self.input.text;

    [self.list reloadData];
}

#pragma mark -

ON_NOTIFICATION3( BeeUIKeyboard, SHOWN, notification )
{
    CGFloat keyboardHeight = [BeeUIKeyboard sharedInstance].height;
    [self.list setBaseInsets:UIEdgeInsetsMake( 0, 0, keyboardHeight, 0)];
}

ON_NOTIFICATION3( BeeUIKeyboard, HEIGHT_CHANGED, notification )
{
    CGFloat keyboardHeight = [BeeUIKeyboard sharedInstance].height;
    [self.list setBaseInsets:UIEdgeInsetsMake( 0, 0, keyboardHeight, 0)];
}

ON_NOTIFICATION3( BeeUIKeyboard, HIDDEN, notification )
{
    [self.list setBaseInsets:UIEdgeInsetsZero];
}

@end
