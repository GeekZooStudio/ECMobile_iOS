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

#import "ValidateModel.h"

#pragma mark -

@implementation ValidateModel

- (void)load
{
}

- (void)unload
{
	[self saveCache];
	
	self.data_bonus = nil;
	self.data_bonus_formated = nil;
}

#pragma mark -

- (void)validateBonus
{
	if ( NO == [UserModel online] )
		return;

	self.CANCEL_MSG( API.validate_bonus );
	self.MSG( API.validate_bonus ).INPUT(@"bonus_sn", self.bonus);
}

- (void)validateIntegral
{
	if ( NO == [UserModel online] )
		return;

	self.CANCEL_MSG( API.validate_integral );
	self.MSG( API.validate_integral ).INPUT(@"integral", self.integral);
}

#pragma mark -

ON_MESSAGE3( API, validate_bonus, msg )
{
	if ( msg.succeed )
	{
		STATUS * status = msg.GET_OUTPUT( @"status" );
		if ( NO == status.succeed.boolValue )
		{
			msg.failed = YES;
			return;
		}
		self.data_bonus = msg.GET_OUTPUT( @"data_bonus" );
		self.data_bonus_formated = msg.GET_OUTPUT( @"data_bonus_formated" );
	}
}

ON_MESSAGE3( API, validate_integral, msg )
{
	if ( msg.succeed )
	{
		STATUS * status = msg.GET_OUTPUT( @"status" );
		if ( NO == status.succeed.boolValue )
		{
			msg.failed = YES;
			return;
		}
		
		self.data_integral = msg.GET_OUTPUT( @"data_bonus" );
		self.data_integral_formated = msg.GET_OUTPUT( @"data_bonus_formated" );
	}
}

@end
