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

#import "HelpModel.h"

#pragma mark -

@implementation HelpModel

@synthesize articleGroups = _articleGroups;

- (void)load
{
	[super load];
}

- (void)unload
{
	self.articleGroups = nil;
	
	[super unload];
}

#pragma mark -

- (void)loadCache
{
	NSString * string = [self userDefaultsRead:@"HelpModel.articleGroups"];
	if ( string )
	{
		self.articleGroups = [ARTICLE_GROUP unserializeObject:[string objectFromJSONString]];
	}
}

- (void)saveCache
{
	NSString * string = [[self.articleGroups serializeObject] JSONString];
	if ( string )
	{
		[self userDefaultsWrite:string forKey:@"HelpModel.articleGroups"];
	}
}

- (void)clearCache
{
	self.articleGroups = nil;
	self.loaded = NO;
}

#pragma mark -

- (void)fetchFromServer
{
	self.CANCEL_MSG( API.shopHelp );
	self.MSG( API.shopHelp );
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

		self.articleGroups = msg.GET_OUTPUT(@"data");
		self.loaded = YES;
		
		[self saveCache];
	}
}

@end
