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

#import "ValidateModel.h"

#pragma mark -

@implementation ValidateModel

- (void)load
{
	[super load];
}

- (void)unload
{
	[self saveCache];
	
	self.data_bonus = nil;
	self.data_bonus_formated = nil;
	
	[super unload];
}

#pragma mark -

- (void)validateBonus
{
	self.CANCEL_MSG( API.validate_bonus );
	self.MSG( API.validate_bonus )
    .INPUT(@"bonus_sn", self.bonus);
}

- (void)validateIntegral
{
	self.CANCEL_MSG( API.validate_integral );
	self.MSG( API.validate_integral )
    .INPUT(@"integral", self.integral);
}

#pragma mark -

- (void)handleMessage:(BeeMessage *)msg
{
	if ( [msg is:API.validate_bonus] )
	{
		if ( msg.succeed )
		{
			STATUS * status = msg.GET_OUTPUT( @"status" );
			if ( NO == status.succeed.boolValue )
			{
				msg.failed = YES;
				return;
			}
            self.data_bonus = msg.GET_OUTPUT( @"data_bonus" );
			self.data_bonus_formated = msg.GET_OUTPUT( @"data_bonus_formated" );
		}
	}   
	else if ( [msg is:API.validate_integral] )
	{
		if ( msg.succeed )
		{
			STATUS * status = msg.GET_OUTPUT( @"status" );
			if ( NO == status.succeed.boolValue )
			{
				msg.failed = YES;
				return;
			}
            
            self.data_integral = msg.GET_OUTPUT( @"data_bonus" );
			self.data_integral_formated = msg.GET_OUTPUT( @"data_bonus_formated" );
		}
	}
}

@end
