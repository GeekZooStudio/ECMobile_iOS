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

#import "G2_MessageCell_iPhone.h"
#import "ECMobileProtocol.h"

#pragma mark -

@implementation G2_MessageCell_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_SIGNAL( TOUCHED )

- (void)load
{
}

- (void)unload
{
}

- (void)dataDidChanged
{
	ECM_MESSAGE * message = self.data;
    if ( message )
    {
		$(@"#notifi-content").TEXT( message.content );
		$(@"#notifi-time").TEXT( [[message.created_at asNSDate] stringWithDateFormat:@"yyyy-MM-dd HH:mm"] );
    }
}

@end
