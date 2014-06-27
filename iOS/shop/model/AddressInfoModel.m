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

#import "AddressInfoModel.h"
#import "UserModel.h"

#pragma mark -

@implementation AddressInfoModel

@synthesize address_id = _address_id;
@synthesize address = _address;

- (void)load
{
}

- (void)unload
{
	self.address_id = nil;
	self.address = nil;
	self.loaded = NO;
}

#pragma mark -

- (void)loadCache
{
}

- (void)saveCache
{
}

- (void)clearCache
{
	self.address_id = nil;
	self.address = nil;
	
	self.loaded = NO;
}

#pragma mark -

- (void)reload
{
	if ( NO == [UserModel online] )
		return;

    self.CANCEL_MSG( API.address_info );
	self.MSG( API.address_info ).INPUT( @"address_id", self.address_id );
}

#pragma mark -

ON_MESSAGE3( API, address_info, msg )
{
	if ( msg.succeed )
	{
		STATUS * status = msg.GET_OUTPUT( @"status" );
		if ( NO == status.succeed.boolValue )
		{
			msg.failed = YES;
			return;
		}

		self.address = msg.GET_OUTPUT( @"data" );
	}
}

@end
