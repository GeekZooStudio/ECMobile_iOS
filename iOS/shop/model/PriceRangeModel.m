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

#import "PriceRangeModel.h"

@implementation PriceRangeModel

- (void)load
{
	[super load];
}

- (void)unload
{
	[self saveCache];
	
	self.price_ranges = nil;
    
	[super unload];
}

#pragma mark -

- (void)loadCache
{
	NSString * string = [self userDefaultsRead:@"PriceRangeModel.ranges"];
	if ( string )
	{
		self.price_ranges = [PRICE_RANGE unserializeObject:[string objectFromJSONString]];
	}
}

- (void)saveCache
{
	NSString * string = [[self.price_ranges serializeObject] JSONString];
	if ( string )
	{
		[self userDefaultsWrite:string forKey:@"PriceRangeModel.ranges"];
	}
}

- (void)clearCache
{
	self.price_ranges= nil;
	self.loaded = NO;
}

#pragma mark -

- (void)fetchFromServer
{
	self.CANCEL_MSG( API.price_range );
	self
    .MSG( API.price_range )
    .INPUT( @"category_id", self.category_id );
}

#pragma mark -

- (void)handleMessage:(BeeMessage *)msg
{
	if ( msg.succeed )
	{
		STATUS * status = msg.GET_OUTPUT( @"status" );
		if ( NO == status.succeed.boolValue )
		{
			msg.failed = YES;
			return;
		}
        
		self.price_ranges = msg.GET_OUTPUT( @"data" );
		self.loaded = YES;
		
		[self saveCache];
	}
}

@end
