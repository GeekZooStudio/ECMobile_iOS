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

#import "AddressListModel.h"
#import "UserModel.h"

#pragma mark -

@implementation AddressListModel

//DEF_SINGLETON( AddressListModel )

@synthesize addresses = _addresses;

- (void)load
{
	self.addresses = [NSMutableArray array];

	[self loadCache];
}

- (void)unload
{
	[self saveCache];

	self.addresses = nil;
	self.loaded = NO;
}

#pragma mark -

- (void)loadCache
{
	[self.addresses removeAllObjects];
	[self.addresses addObjectsFromArray:[ADDRESS readFromUserDefaults:@"AddressListModel.address"]];
}

- (void)saveCache
{
	[ADDRESS userDefaultsWrite:[self.addresses objectToString] forKey:@"AddressListModel.address"];
}

- (void)clearCache
{
	[ADDRESS userDefaultsRemove:@"AddressListModel.address"];
	[self.addresses removeAllObjects];

	self.loaded = NO;
}

#pragma mark -

- (void)reload
{
	self.CANCEL_MSG( API.address_list );
	self.MSG( API.address_list );
}

#pragma mark -

- (void)add:(ADDRESS *)address
{
	if ( NO == [UserModel online] )
		return;

	self.CANCEL_MSG( API.address_add );
	self.MSG( API.address_add ).INPUT( @"address", address );
}

- (void)update:(ADDRESS *)address
{
	if ( NO == [UserModel online] )
		return;

	self.CANCEL_MSG( API.address_update );
	self.MSG( API.address_update )
	.INPUT( @"address_id", address.id )
	.INPUT( @"address", address );
}

- (void)remove:(ADDRESS *)address
{
	if ( NO == [UserModel online] )
		return;

	self.CANCEL_MSG( API.address_delete );
	self.MSG( API.address_delete ).INPUT( @"address_id", address.id );
}

- (void)setDefault:(ADDRESS *)address
{
	if ( NO == [UserModel online] )
		return;

	self.CANCEL_MSG( API.address_setDefault );
	self.MSG( API.address_setDefault ).INPUT( @"address_id", address.id );
}

#pragma mark -

ON_MESSAGE3( API, address_add, msg )
{
    if ( msg.succeed )
    {
        STATUS * status = msg.GET_OUTPUT( @"status" );
		if ( NO == status.succeed.boolValue )
		{
			msg.failed = YES;
			return;
		}
		
		NSArray * array = msg.GET_OUTPUT( @"data" );
		
		[self.addresses removeAllObjects];
		[self.addresses addObjectsFromArray:array];
        
		self.loaded = YES;
		
		[self saveCache];
    }
}

ON_MESSAGE3( API, address_list, msg )
{
	if ( msg.succeed )
	{
		STATUS * status = msg.GET_OUTPUT( @"status" );
		if ( NO == status.succeed.boolValue )
		{
			msg.failed = YES;
			return;
		}
		
		NSArray * array = msg.GET_OUTPUT( @"data" );
		
		[self.addresses removeAllObjects];
		[self.addresses addObjectsFromArray:array];

		self.loaded = YES;
		
		[self saveCache];
	}
}

ON_MESSAGE3( API, address_update, msg )
{
	if ( msg.succeed )
	{
		STATUS * status = msg.GET_OUTPUT( @"status" );
		if ( NO == status.succeed.boolValue )
		{
			msg.failed = YES;
			return;
		}

		NSNumber *	address_id = msg.GET_INPUT( @"address_id" );
		ADDRESS *	newAddress = msg.GET_OUTPUT( @"data" );

        if ( newAddress )
        {
            for ( ADDRESS * address in self.addresses )
            {
                if ( [address.id isEqualToNumber:address_id] )
                {
                    [self.addresses replaceObjectAtIndex:[self.addresses indexOfObject:address] withObject:newAddress];
                    break;
                }
            }
            
            [self saveCache];
        }
	}
}

ON_MESSAGE3( API, address_delete, msg )
{
	if ( msg.succeed )
	{
		STATUS * status = msg.GET_OUTPUT( @"status" );
		if ( NO == status.succeed.boolValue )
		{
			msg.failed = YES;
			return;
		}

		NSNumber *	address_id = msg.GET_INPUT( @"address_id" );

		for ( ADDRESS * address in self.addresses )
		{
			if ( [address.id isEqualToNumber:address_id] )
			{
				[self.addresses removeObject:address];
				break;
			}
		}
		
		[self saveCache];
	}
}

ON_MESSAGE3( API, address_setDefault, msg )
{
	if ( msg.succeed )
	{
		STATUS * status = msg.GET_OUTPUT( @"status" );
		if ( NO == status.succeed.boolValue )
		{
			msg.failed = YES;
			return;
		}

		NSNumber * address_id = msg.GET_INPUT( @"address_id" );

		for ( ADDRESS * address in self.addresses )
		{
			if ( [address.id isEqualToNumber:address_id] )
			{
				address.default_address = @YES;

				self.defaultAddress = address;
			}
			else
			{
				address.default_address = @NO;
			}
		}
		
		[self saveCache];
	}
}

@end
