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

#import "BannerModel.h"

#pragma mark -

@implementation BannerModel

@synthesize banners = _banners;
@synthesize goods = _goods;

- (void)load
{
	[super load];
}

- (void)unload
{
	[self saveCache];
	
	self.banners = nil;
	self.goods = nil;

	[super unload];
}

#pragma mark -

- (void)loadCache
{
	NSString * string = [self userDefaultsRead:@"BannerModel.banners"];
	if ( string )
	{
		self.banners = [BANNER unserializeObject:[string objectFromJSONString]];
	}

	NSString * string2 = [self userDefaultsRead:@"BannerModel.goods"];
	if ( string2 )
	{
		self.goods = [SIMPLE_GOODS unserializeObject:[string2 objectFromJSONString]];
	}
}

- (void)saveCache
{
	NSString * string = [[self.banners serializeObject] JSONString];
	if ( string )
	{
		[self userDefaultsWrite:string forKey:@"BannerModel.banners"];
	}

	NSString * string2 = [[self.goods serializeObject] JSONString];
	if ( string2 )
	{
		[self userDefaultsWrite:string2 forKey:@"BannerModel.goods"];
	}
}

- (void)clearCache
{
	self.banners = nil;
	self.goods = nil;
	
	self.loaded = NO;
}

#pragma mark -

- (void)fetchFromServer
{
	self.CANCEL_MSG( API.home_data );
	self.MSG( API.home_data );
}

#pragma mark -

- (void)handleMessage:(BeeMessage *)msg
{
	if ( [msg is:API.home_data] )
	{
		if ( msg.succeed )
		{
			STATUS * status = msg.GET_OUTPUT( @"status" );
			if ( NO == status.succeed.boolValue )
			{
				msg.failed = YES;
				return;
			}

			self.banners = msg.GET_OUTPUT( @"data_player" );
			self.goods = msg.GET_OUTPUT( @"data_promote_goods" );
			self.loaded = YES;
			
			[self saveCache];
		}
	}
}

@end
