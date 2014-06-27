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

#import "D0_SearchCategory_iPhone.h"

#pragma mark -

@implementation D0_SearchCategory_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

- (void)load
{
}

- (void)unload
{
}

- (void)dataDidChanged
{
	NSObject * obj = self.data;
	
	if ( [obj isKindOfClass:[TOP_CATEGORY class]] )
	{
		TOP_CATEGORY * category = (TOP_CATEGORY *)obj;
		if ( category )
		{
			$(@"#title").DATA( category.name );
			
            if ( category.children.count )
            {
                $(@"#arrow").SHOW();
            }
            else
            {
                $(@"#arrow").HIDE();
            }
		}
	}
	else if ( [obj isKindOfClass:[CATEGORY class]] )
	{
		CATEGORY * category = (CATEGORY *)obj;
		if ( category )
		{
			$(@"#title").DATA( category.name );
			$(@"#arrow").HIDE();
		}		
	}
}

@end
