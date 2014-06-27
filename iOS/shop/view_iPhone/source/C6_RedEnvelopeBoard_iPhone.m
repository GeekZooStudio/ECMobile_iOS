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
//	Powered by BeeFramework
//

#import "C6_RedEnvelopeBoard_iPhone.h"
#import "C1_CheckOutBoard_iPhone.h"
#import "AppBoard_iPhone.h"

#pragma mark -

@implementation C6_RedEnvelopeBoard_iPhone

SUPPORT_RESOURCE_LOADING( YES );
SUPPORT_AUTOMATIC_LAYOUT( YES );

DEF_MODEL( ValidateModel, validateModel )

- (void)load
{    
    self.validateModel = [ValidateModel modelWithObserver:self];
}

- (void)unload
{
	SAFE_RELEASE_MODEL( self.validateModel );
}

#pragma mark -

ON_CREATE_VIEWS(signal)
{
    self.navigationBarTitle = __TEXT(@"redpaper");
    self.navigationBarShown = YES;
}

ON_DID_APPEAR(signal)
{
    _input.placeholder = [NSString stringWithFormat:__TEXT(@"remain_redpacks"), self.bonus];
    [_input becomeFirstResponder];
}

ON_WILL_APPEAR(signal)
{
    [bee.ui.appBoard hideTabbar];
}

ON_LEFT_BUTTON_TOUCHED(signal)
{
    [self.stack popBoardAnimated:YES];
}

ON_RIGHT_BUTTON_TOUCHED(signal)
{
    [self checkin];
}

ON_SIGNAL2( BeeUITextField, signal )
{
    if ( [signal is:BeeUITextField.RETURN] )
    {
        [self.view endEditing:YES];
    }
}

- (void)checkin
{
	C1_CheckOutBoard_iPhone * board = (C1_CheckOutBoard_iPhone *)self.previousBoard;
	board.flowModel.done_bonus = self.input.text;
	self.validateModel.bonus = board.flowModel.done_bonus;
	[self.validateModel validateBonus];
}

@end
