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
	
#import "H1_PayBoard_iPhone.h"

#pragma mark -

@implementation H1_PayBoard_iPhone

- (void)load
{
    self.orderModel = [[[OrderModel alloc] init] autorelease];
    [self.orderModel addObserver:self];
}

- (void)unload
{
    [self.orderModel removeObserver:self];
    self.orderModel = nil;
}

#pragma mark -

ON_SIGNAL2( BeeUIBoard, signal )
{
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        self.titleString		= __TEXT(@"pay");
		self.navigationBarLeft  = [UIImage imageNamed:@"nav_back.png"];
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
	}
	else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{
	}
    else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
    {
    }
    else if ( [signal is:BeeUIBoard.FREE_DATAS] )
    {
    }
    else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
    {
		[bee.ui.appBoard hideTabbar];
        
        if ( self.orderID )
        {
            ORDER * order = [[[ORDER alloc] init] autorelease];
            order.order_id = self.orderID;
            [self.orderModel pay:order];
        }
    }
    else if ( [signal is:BeeUIBoard.DID_APPEAR] )
    {
    }
    else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
    {
    }
    else if ( [signal is:BeeUIBoard.DID_DISAPPEAR] )
    {
    }
}

ON_LEFT_BUTTON_TOUCHED(signal)
{
}

#pragma mark -

ON_MESSAGE3( API, order_pay, msg )
{
	if ( msg.succeed )
	{
		self.htmlString = self.orderModel.html;
		
		[self refresh];
	}
	else if ( msg.failed )
	{
		[self showErrorTips:msg];
	}
}

@end
