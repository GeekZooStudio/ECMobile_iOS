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

#import "ExpressModel.h"

#pragma mark -

@implementation ExpressModel

DEF_SINGLETON( ExpressModel )

- (void)load
{
	[super load];
	
	self.content = [NSMutableArray array];
}

- (void)unload
{
    [super unload];
}

- (void)loadCache
{
	NSString * string = [self userDefaultsRead:@"ExpressModel.content"];
	if ( string )
	{
		[self.content removeAllObjects];

		NSArray * array = [REGION unserializeObject:[string objectFromJSONString]];
		if ( array )
		{
			[self.content addObjectsFromArray:array];
		}
	}
}

- (void)saveCache
{
	NSString * string = [[self.content serializeObject] JSONString];
	if ( string )
	{
		[self userDefaultsWrite:string forKey:@"ExpressModel.content"];
	}
}

- (void)fetchFromServer
{
    self.CANCEL_MSG( API.order_express );
	self.MSG( API.order_express ).INPUT( @"order_id", self.order.order_id );
}

#pragma mark -

- (void)handleMessage:(BeeMessage *)msg
{
	if ( [msg is:API.order_express] )
	{
		if ( msg.succeed )
		{
			STATUS * status = msg.GET_OUTPUT( @"status" );
			if ( NO == status.succeed.boolValue )
			{
				msg.failed = YES;
				return;
			}
            
			[self.content removeAllObjects];
			
			NSArray * array = msg.GET_OUTPUT( @"data_content" );
			if ( array )
			{
				[self.content addObjectsFromArray:array];
				[self.content sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
					NSDate * date1 = [((EXPRESS *)obj1).time asNSDate];
					NSDate * date2 = [((EXPRESS *)obj2).time asNSDate];
					return -[date1 compare:date2];
				}];
			}

            self.shipping_name = msg.GET_OUTPUT( @"data_shipping_name" );
            
            [self saveCache];
        }
	}
}

@end
