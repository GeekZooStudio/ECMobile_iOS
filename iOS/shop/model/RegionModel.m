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

#import "RegionModel.h"

#pragma mark -

@implementation RegionModel

DEF_SINGLETON( RegionModel )

- (NSString *)region
{
    NSString * string = @"";
    
    if ( self.address.country_name && self.address.province_name.length)
    {
        string = [string stringByAppendingFormat:@"%@ ", self.address.country_name];
    }
    
    if ( self.address.province_name && self.address.province_name.length )
    {
        string = [string stringByAppendingFormat:@"%@ ", self.address.province_name];
    }
    
    if ( self.address.city_name && self.address.province_name.length)
    {
        string = [string stringByAppendingFormat:@"%@ ", self.address.city_name];
    }
    
    if ( self.address.district_name && self.address.province_name.length)
    {
        string = [string stringByAppendingFormat:@"%@ ", self.address.district_name];
    }
    
    return string;
}

+ (NSString *)regionFromAddress:(ADDRESS *)address
{
    NSString * string = @"";
    
    if ( address.country_name && address.province_name.length)
    {
        string = [string stringByAppendingFormat:@"%@ ", address.country_name];
    }
    
    if ( address.province_name && address.province_name.length )
    {
        string = [string stringByAppendingFormat:@"%@ ", address.province_name];
    }
    
    if ( address.city_name && address.province_name.length)
    {
        string = [string stringByAppendingFormat:@"%@ ", address.city_name];
    }
    
    if ( address.district_name && address.province_name.length)
    {
        string = [string stringByAppendingFormat:@"%@ ", address.district_name];
    }
    
    return string;
}

- (void)load
{
	[super load];
    
    self.level = 0;
    self.address = [[[ADDRESS alloc] init] autorelease];
    self.tempAddress = [[[ADDRESS alloc] init] autorelease];
    
	[self loadCache];
}

- (void)unload
{
    
	[self saveCache];
	
    self.address = nil;
    self.tempAddress = nil;
	self.regions = nil;

	[super unload];
}

#pragma mark -

- (void)loadCache
{
	NSString * string = [self userDefaultsRead:@"RegionModel.regions"];
	if ( string )
	{
		self.regions = [REGION unserializeObject:[string objectFromJSONString]];
	}
}

- (void)saveCache
{
	NSString * string = [[self.regions serializeObject] JSONString];
	if ( string )
	{
		[self userDefaultsWrite:string forKey:@"RegionModel.regions"];
	}
}

- (void)clearCache
{
	self.regions = nil;
	self.loaded = NO;
}

#pragma mark -

- (void)fetchFromServer
{
	self.CANCEL_MSG( API.region );
	self.MSG( API.region )
    .INPUT( @"parent_id", self.parent_id );
}

#pragma mark -

- (void)handleMessage:(BeeMessage *)msg
{
	if ( [msg is:API.region] )
	{
		if ( msg.succeed )
		{
			STATUS * status = msg.GET_OUTPUT( @"status" );
			if ( NO == status.succeed.boolValue )
			{
				msg.failed = YES;
				return;
			}

			self.regions = msg.GET_OUTPUT( @"data" );
			self.loaded = YES;
			
			[self saveCache];
		}
	}
}


- (BOOL)isValid
{
    BOOL _isValid = NO;
    
//    if ( self.address.country )
//    {
//        if ( self.address.country_name.length )
//        {
//            _isValid = YES;
//        }
//        else
//        {
//            return NO;
//        }
//    }
    
    if ( self.address.province.boolValue )
    {
        if ( self.address.province_name.length )
        {
            _isValid = YES;
        }
        else
        {
            return NO;
        }
    }
    
    if ( self.address.city.boolValue )
    {
        if ( self.address.city_name.length )
        {
            _isValid = YES;
        }
        else
        {
            return NO;
        }
    }
    
    if ( self.address.district.boolValue )
    {
        if ( self.address.district_name.length )
        {
            _isValid = YES;
        }
        else
        {
            return NO;
        }
    }
    
    return _isValid;
}

- (void)setRegionFromAddress:(ADDRESS *)address
{
    self.address.country = address.country;
    self.address.country_name = address.country_name;
    self.address.province = address.province;
    self.address.province_name = address.province_name;
    self.address.city = address.city;
    self.address.city_name = address.city_name;
    self.address.district = address.district;
    self.address.district_name = address.district_name;
}

- (void)clearRegion
{
    self.address.country = nil;
    self.address.country_name = nil;
    self.address.province = nil;
    self.address.province_name = nil;
    self.address.city = nil;
    self.address.city_name = nil;
    self.address.district = nil;
    self.address.district_name = nil;
}

- (void)clearTempRegion
{
    self.tempAddress.country = nil;
    self.tempAddress.country_name = nil;
    self.tempAddress.province = nil;
    self.tempAddress.province_name = nil;
    self.tempAddress.city = nil;
    self.tempAddress.city_name = nil;
    self.tempAddress.district = nil;
    self.tempAddress.district_name = nil;
}

@end
