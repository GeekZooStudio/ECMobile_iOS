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

#import "Bee.h"
#import "model.h"
#import "ErrorMsg.h"

@implementation ErrorMsg

//DEF_SINGLETON( ErrorMsg )

+ (void)presentErrorMsg:(BeeMessage *)msg inBoard:(BeeUIBoard *)board;
{
    STATUS * status = msg.GET_OUTPUT( @"status" );
	if ( status )
	{
		NSString * errorDesc = status.error_desc;
		if ( errorDesc )
		{
			[board presentFailureTips:errorDesc];
			return;
		}
	}
	
	NSString * errorDesc2 = msg.errorDesc;
    if ( errorDesc2 )
    {
        [board presentFailureTips:errorDesc2];
		return;
    }

	if ( status.error_code )
	{
		NSString * multiLang = [NSString stringWithFormat:@"error_%@", status.error_code];
		NSString * errorDesc3 = __TEXT( multiLang );
		if ( errorDesc3 )
		{
			[board presentFailureTips:errorDesc3];
			return;
		}
	}
	
	[self presentFailureTips:__TEXT(@"error_network")];
}

@end
