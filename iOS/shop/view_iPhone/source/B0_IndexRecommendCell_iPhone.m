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

#import "B0_IndexRecommendCell_iPhone.h"
#import "B0_IndexRecommendGoodsCell_iPhone.h"

#pragma mark -

@implementation B0_IndexRecommendCell_iPhone

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
    NSArray * array = self.data;
	
    if ( array.count >= 1 )
	{
		$(@"#goods-1").SHOW();
		$(@"#goods-1").DATA( [array objectAtIndex:0] );
	}
	else
	{
		$(@"#goods-1").HIDE();
	}
    
    if ( array.count >= 2 )
	{
		$(@"#goods-2").SHOW();
		$(@"#goods-2").DATA( [array objectAtIndex:1] );
	}
	else
	{
		$(@"#goods-2").HIDE();
	}
    
    if ( array.count >= 3 )
	{
		$(@"#goods-3").SHOW();
		$(@"#goods-3").DATA( [array objectAtIndex:2] );
	}
	else
	{
		$(@"#goods-3").HIDE();
	}
    
	if ( array.count >= 4 )
	{
		$(@"#goods-4").SHOW();
		$(@"#goods-4").DATA( [array objectAtIndex:3] );
	}
	else
	{
		$(@"#goods-4").HIDE();
	}

}

@end
