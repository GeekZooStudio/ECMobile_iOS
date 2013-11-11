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

#import "BaseModel.h"

#pragma mark -

@implementation BaseModel

@synthesize loaded = _loaded;

- (void)load
{
	[super load];
	
	self.loaded = NO;
}

- (void)unload
{
	[super unload];
}

- (void)loadCache
{
}

- (void)saveCache
{
}

- (void)clearCache
{
	self.loaded = NO;
}

@end

#pragma mark -

@implementation SinglePageModel

- (void)fetchFromServer
{
}

@end

#pragma mark -

@implementation MultiPageModel

@synthesize more = _more;

- (void)load
{
	self.more = YES;
}

- (void)fetchFromServer
{
	[self prevPageFromServer];
}

- (void)prevPageFromServer
{
}

- (void)nextPageFromServer
{
}

@end
