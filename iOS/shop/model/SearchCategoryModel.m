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

#import "SearchCategoryModel.h"

#pragma mark -

@implementation SearchCategoryModel

DEF_SINGLETON( SearchCategoryModel )

@synthesize topCategories = _topCategories;

- (void)load
{
	[super load];
}

- (void)unload
{
	[self saveCache];
	
	self.topCategories = nil;

	[super unload];
}

#pragma mark -

- (void)loadCache
{
	NSString * string = [self userDefaultsRead:@"SearchCategoryModel.topCategories"];
	if ( string )
	{
		self.topCategories = [TOP_CATEGORY unserializeObject:[string objectFromJSONString]];
	}
}

- (void)saveCache
{
	NSString * string = [[self.topCategories serializeObject] JSONString];
	if ( string )
	{
		[self userDefaultsWrite:string forKey:@"SearchCategoryModel.topCategories"];
	}
}

- (void)clearCache
{
	self.topCategories = nil;
	self.loaded = NO;
}

#pragma mark -

- (void)fetchFromServer
{
	self.CANCEL_MSG( API.category );
	self.MSG( API.category );
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

		self.topCategories = msg.GET_OUTPUT( @"data" );
		self.loaded = YES;

		[self saveCache];
	}
}

@end
