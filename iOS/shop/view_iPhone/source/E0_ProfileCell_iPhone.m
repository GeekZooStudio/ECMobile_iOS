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

#import "E0_ProfileCell_iPhone.h"

#pragma mark -

@implementation E0_ProfileCell_iPhone

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
    if ( self.data )
    {
        UserModel * userModel = self.data;
        
		if ( [UserModel online] )
		{
			$(@"#name").TEXT(userModel.user.name);
		}
		else
		{
			$(@"#name").TEXT(__TEXT(@"click_to_login"));
		}
        
        if ( 0 == userModel.user.collection_num.intValue )
        {
            $(@"#fav-count").TEXT( __TEXT(@"no_product") );
        }
        else
        {
            $(@"#fav-count").TEXT( [NSString stringWithFormat:@"%@%@", userModel.user.collection_num, __TEXT(@"no_of_items")] );
        }
        
		NSNumber * num1 = [[userModel.user.order_num objectAtPath:@"await_pay"] asNSNumber];
		if ( num1 && num1.intValue )
		{
			$(@"#await_pay-bg").SHOW();
			$(@"#await_pay").SHOW().DATA( num1 );
		}
		else
		{
			$(@"#await_pay-bg").HIDE();
			$(@"#await_pay").HIDE();
		}
        
		NSNumber * num2 = [[userModel.user.order_num objectAtPath:@"await_ship"] asNSNumber];
		if ( num2 && num2.intValue )
		{
			$(@"#await_ship-bg").SHOW();
			$(@"#await_ship").SHOW().DATA( num2 );
		}
		else
		{
			$(@"#await_ship-bg").HIDE();
			$(@"#await_ship").HIDE();
		}
		
		NSNumber * num3 = [[userModel.user.order_num objectAtPath:@"shipped"] asNSNumber];
		if ( num3 && num3.intValue )
		{
			$(@"#shipped-bg").SHOW();
			$(@"#shipped").SHOW().DATA( num3 );
		}
		else
		{
			$(@"#shipped-bg").HIDE();
			$(@"#shipped").HIDE();
		}
		
		NSNumber * num4 = [[userModel.user.order_num objectAtPath:@"finished"] asNSNumber];
		if ( num4 && num4.intValue )
		{
			$(@"#finished-bg").SHOW();
			$(@"#finished").SHOW().DATA( num4 );
		}
		else
		{
			$(@"#finished-bg").HIDE();
			$(@"#finished").HIDE();
		}
		
		if ( [UserModel online] )
		{
			if ( [UserModel sharedInstance].avatar )
			{
				$(@"#header-avatar").IMAGE( [UserModel sharedInstance].avatar );
			}
			else
			{
				$(@"#header-avatar").IMAGE( [UIImage imageNamed:@"profile_no_avatar_icon.png"] );
			}
			
			$(@"#header-carema").SHOW();
			$(@"#carema").SHOW();
			$(@"#signin").HIDE();
            
            if ( userModel.user.rank_level.integerValue == RANK_LEVEL_NORMAL )
            {
                $(@"#header-level-icon").HIDE();
            }
            else
            {
                $(@"#header-level-icon").SHOW();
                $(@"#header-level-icon").DATA( @"profile_vip_icon.png" );
            }
            
            $(@"#header-level-name").SHOW();
            $(@"#header-level-name").DATA( userModel.user.rank_name );
		}
		else
		{
			$(@"#header-avatar").IMAGE( [UIImage imageNamed:@"profile_no_avatar_icon.png"] );
			$(@"#header-carema").HIDE();
			$(@"#carema").HIDE();
			$(@"#signin").SHOW();
            $(@"#header-level-icon").HIDE();
            $(@"#header-level-name").HIDE();
		}
    }
}

@end
