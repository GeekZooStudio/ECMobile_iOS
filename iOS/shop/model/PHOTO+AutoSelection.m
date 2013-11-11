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

#import "PHOTO+AutoSelection.h"
#import "ConfigModel.h"

#pragma mark -

@implementation PHOTO(AutoSelection)

- (NSString *)largeURL
{
	if ( [ConfigModel sharedInstance].photoMode == ConfigModel.PHOTO_MODE_AUTO )
	{
		if ( [BeeReachability isReachableViaWIFI] )
		{
			return self.img ? self.img : (self.url ? self.url : self.thumb);
		}
		else
		{
			return self.thumb ? self.thumb : self.small;
		}
	}
	else if ( [ConfigModel sharedInstance].photoMode == ConfigModel.PHOTO_MODE_HIGH )
	{
		return self.img ? self.img : (self.url ? self.url : self.thumb);
	}
	else
	{
		return self.thumb ? self.thumb : (self.url ? self.url : self.img);
	}
}

- (NSString *)thumbURL
{
	if ( [ConfigModel sharedInstance].photoMode == ConfigModel.PHOTO_MODE_AUTO )
	{
		if ( [BeeReachability isReachableViaWIFI] )
		{
			return self.thumb ? self.thumb : self.small;
		}
		else
		{
			return self.small ? self.small : self.thumb;
		}
	}
	else if ( [ConfigModel sharedInstance].photoMode == ConfigModel.PHOTO_MODE_HIGH )
	{
		return self.thumb ? self.thumb : self.small;
	}
	else
	{
		return self.small ? self.small : self.thumb;
	}
}

@end
