//
//                       __
//                      /\ \   _
//    ____    ____   ___\ \ \_/ \           _____    ___     ___
//   / _  \  / __ \ / __ \ \    <     __   /\__  \  / __ \  / __ \
//  /\ \_\ \/\  __//\  __/\ \ \\ \   /\_\  \/_/  / /\ \_\ \/\ \_\ \
//  \ \____ \ \____\ \____\\ \_\\_\  \/_/   /\____\\ \____/\ \____/
//   \/____\ \/____/\/____/ \/_//_/         \/____/ \/___/  \/___/
//     /\____/
//     \/___/
//
//	Powered by BeeFramework
//

#import "controller.h"
#import "model.h"

#pragma mark -

@implementation ErrorController

DEF_SINGLETON( ErrorController )

+ (void)load
{
	[BeeMessage setGlobalExecuter:[ErrorController sharedInstance]];
}

- (void)index:(BeeMessage *)msg
{
	if ( msg.succeed )
	{
		NSDictionary * dict = msg.responseJSONDictionary;
		if ( dict )
		{
			NSNumber * code = [dict numberAtPath:@"status.error_code"];
			NSString * desc = [dict stringAtPath:@"status.error_desc"];
			
			msg.errorCode = code.intValue;
			msg.errorDesc = desc;

			if ( code.intValue == 100 || code.intValue == 1 )
			{
				[[UserModel sharedInstance] kickout];
				
				msg.failed = YES;
				return;
			}
		}
	}
}

@end
