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

#import "GoodsModel.h"

#pragma mark -

@implementation GoodsModel

@synthesize goods_desc = _goods_desc;
@synthesize goods_id = _goods_id;
@synthesize goods = _goods;

- (void)load
{
	[super load];
}

- (void)unload
{
    self.goods = nil;
	self.goods_id = nil;
    self.goods_desc = nil;
    
	[super unload];
}

#pragma mark -

- (void)loadCache
{
}

- (void)saveCache
{
}

- (void)clearCache
{
	self.goods = nil;
	self.goods_id = nil;
	self.loaded = NO;
}

#pragma mark -

- (void)update
{
	self.CANCEL_MSG( API.goods );
	self.MSG( API.goods ).INPUT( @"goods_id", self.goods_id );
}

#pragma mark -

- (void)desc
{
	self.CANCEL_MSG( API.goods_desc );
	self.MSG( API.goods_desc ).INPUT( @"goods_id", self.goods_id );
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
        
        if ( [msg is:API.goods_desc] )
        {
            self.goods_desc = msg.GET_OUTPUT(@"data");
        }
        else if ( [msg is:API.goods] )
        {
            self.goods = msg.GET_OUTPUT(@"data");
            self.loaded = YES;
        }
        
    }
}

@end
