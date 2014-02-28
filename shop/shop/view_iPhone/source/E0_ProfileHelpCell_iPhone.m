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

#import "E0_ProfileHelpCell_iPhone.h"

#pragma mark -

@implementation E0_ProfileHelpCell_iPhone

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
    self.tapEnabled = YES;
    self.tapSignal = self.TOUCHED;
    
	ARTICLE_GROUP * articleGroup = self.data;
	if ( articleGroup )
	{
		$(@"#helper-title").TEXT( articleGroup.name );
		$(@"#helper-subtitle").TEXT( nil );
	}
}

@end
