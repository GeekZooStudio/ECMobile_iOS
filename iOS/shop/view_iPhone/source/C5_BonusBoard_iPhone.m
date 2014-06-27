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

#import "C5_BonusBoard_iPhone.h"
#import "C1_CheckOutBoard_iPhone.h"
#import "AppBoard_iPhone.h"

#pragma mark -

@implementation C5_BonusBoard_iPhone

DEF_MODEL( ValidateModel, validateModel )

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

@synthesize yourBonus = _yourBonus;
@synthesize maxBonus = _maxBonus;

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
    self.navigationBarTitle = __TEXT(@"balance_exp");
    
    [self showNavigationBarAnimated:NO];
    [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav_back.png"]];
    [self showBarButton:BeeUINavigationBar.RIGHT title:__TEXT(@"save") image:[UIImage imageNamed:@"nav_right.png"]];
}

ON_DID_APPEAR(signal)
{
    NSInteger integral = MIN( self.maxBonus, self.yourBonus );
    NSString * string =  [NSString stringWithFormat:@"%@ %d", __TEXT(@"avail_exp"), integral];
    
    $(@"#info").TEXT(string);
    $(@"#input").FOCUS();
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

ON_SIGNAL3( BeeUITextField, RETURN, signal )
{
	[self.view endEditing:YES];
}

#pragma mark -

- (void)checkin
{
    NSInteger usedBonus = $(@"#input").text.integerValue;
    if ( usedBonus <= self.maxBonus )
    {
        C1_CheckOutBoard_iPhone * board = (C1_CheckOutBoard_iPhone *)self.previousBoard;
        board.flowModel.done_integral = @(usedBonus);
        self.validateModel.integral = board.flowModel.done_integral;
        [self.validateModel validateIntegral];
    }
    else
    {
        [self presentFailureTips:__TEXT(@"warn_wrong_exp")];
    }
}

#pragma mark -

ON_MESSAGE3( API, validate_integral, msg )
{
	if ( msg.sending )
	{
		[self presentLoadingTips:__TEXT(@"tips_verifying")];
	}
	else
	{
		[self dismissTips];
	}

	if ( msg.succeed )
	{
		STATUS * status = msg.GET_OUTPUT( @"status" );
		
		if ( status.succeed.boolValue )
		{
			C1_CheckOutBoard_iPhone * board = (C1_CheckOutBoard_iPhone *)self.previousBoard;
			board.flowModel.done_integral = @($(@"#input").text.integerValue);
			board.flowModel.data_integral = self.validateModel.data_integral;
			board.flowModel.data_integral_formated = self.validateModel.data_integral_formated;
			[self.stack popBoardAnimated:YES];
		}
		else
		{
			[self showErrorTips:msg];
		}
	}
	else if ( msg.failed )
	{
		[self showErrorTips:msg];
	}
}

@end
