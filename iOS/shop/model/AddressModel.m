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

#import "AddressModel.h"

#pragma mark -

@implementation AddressModel

@synthesize address = _address;

- (void)load
{
	[super load];
}

- (void)unload
{
	[self saveCache];
	
	self.address = nil;
	self.loaded = NO;
	
	[super unload];
}

#pragma mark -

- (void)loadCache
{
	NSString * string = [self userDefaultsRead:@"AddressModel.address"];
	if ( string )
	{
		self.address = [ADDRESS unserializeObject:[string objectFromJSONString]];
	}
}

- (void)saveCache
{
	NSString * string = [[self.address serializeObject] JSONString];
	if ( string )
	{
		[self userDefaultsWrite:string forKey:@"AddressModel.address"];
	}
}

- (void)clearCache
{
	self.address = nil;
	self.loaded = NO;
}

#pragma mark -

- (void)fetchFromServer
{
	self.CANCEL_MSG( API.address_list );
	self.MSG( API.address_list );
}

#pragma mark -

- (void)info:(ADDRESS *)address
{
    self.CANCEL_MSG( API.address_info );
	self
	.MSG( API.address_info )
	.INPUT( @"address_id", address.id );
}

- (void)add:(ADDRESS *)address
{
	self.CANCEL_MSG( API.address_add );
	self
	.MSG( API.address_add )
	.INPUT( @"address", address );
}

- (void)update:(ADDRESS *)address
{
	self.CANCEL_MSG( API.address_update );
	self
	.MSG( API.address_update )
	.INPUT( @"address_id", address.id )
	.INPUT( @"address", address );
}

- (void)remove:(ADDRESS *)address
{
	self.CANCEL_MSG( API.address_delete );
	self
	.MSG( API.address_delete )
	.INPUT( @"address_id", address.id );
}

- (void)setDefault:(ADDRESS *)address
{
	self.CANCEL_MSG( API.address_setDefault );
	self
	.MSG( API.address_setDefault )
	.INPUT( @"address_id", address.id );
}

#pragma mark -

- (void)handleMessage:(BeeMessage *)msg
{
	if ( [msg is:API.address_list] )
	{
		if ( msg.succeed )
		{
			STATUS * status = msg.GET_OUTPUT( @"status" );
			if ( NO == status.succeed.boolValue )
			{
				msg.failed = YES;
				return;
			}

			self.address = [NSMutableArray arrayWithArray:msg.GET_OUTPUT( @"data" )];
			self.loaded = YES;
			
			[self saveCache];
		}
	}
    else if ( [msg is:API.address_info] )
	{
		if ( msg.succeed )
		{
			STATUS * status = msg.GET_OUTPUT( @"status" );
			if ( NO == status.succeed.boolValue )
			{
				msg.failed = YES;
				return;
			}

            self.singleAddress = msg.GET_OUTPUT( @"data" );
            
//			[self saveCache];
		}
	}
	else if ( [msg is:API.address_update] )
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

			for ( ADDRESS * address in self.address )
			{
				if ( [address.id isEqualToNumber:address_id] )
				{
					[self.address replaceObjectAtIndex:[self.address indexOfObject:address] withObject:newAddress];
					break;
				}
			}
			
			[self saveCache];
		}
	}
	else if ( [msg is:API.address_delete] )
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

			for ( ADDRESS * address in self.address )
			{
				if ( [address.id isEqualToNumber:address_id] )
				{
					[self.address removeObject:address];
					break;
				}
			}
			
			[self saveCache];
		}
	}
	else if ( [msg is:API.address_setDefault] )
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
			
			for ( ADDRESS * address in self.address )
			{
				if ( [address.id isEqualToNumber:address_id] )
				{
					address.default_address = @YES;
				}
				else
				{
					address.default_address = @NO;
				}
			}
			
			[self saveCache];
		}
	}
}

@end
