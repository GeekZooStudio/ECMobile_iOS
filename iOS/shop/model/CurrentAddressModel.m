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

#import "CurrentAddressModel.h"

#pragma mark -

@implementation CurrentAddressModel

DEF_SINGLETON( CurrentAddressModel )

@synthesize address = _address;
@synthesize defaultAddress = _defaultAddress;

- (void)load
{
	[super load];
}

- (void)unload
{	
    self.loaded = NO;
	self.address = nil;
    self.defaultAddress = nil;
	
	[super unload];
}

- (void)setAddress:(ADDRESS *)address
{
    [address retain];
    [_address release];
    _address = address;
}

- (void)clearCache
{
    self.address = nil;
}


@end
