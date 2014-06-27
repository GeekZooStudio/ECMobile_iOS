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
//  Powered by BeeFramework
//

#import "B5_ProductCommentBoard_iPhone.h"
#import "B5_ProductCommentCell_iPhone.h"

#import "AppBoard_iPhone.h"

#import "CommonPullLoader.h"
#import "CommonFootLoader.h"
#import "CommonNoResultCell.h"

#import "NSObject+ScrollViewExt.h"

#pragma mark -

@implementation B5_ProductCommentBoard_iPhone

SUPPORT_RESOURCE_LOADING( YES );
SUPPORT_AUTOMATIC_LAYOUT( YES );

DEF_OUTLET( BeeUIScrollView, list )

- (void)load
{
    self.commentModel = [CommentModel modelWithObserver:self];
}

- (void)unload
{
    SAFE_RELEASE_MODEL( self.commentModel );
}

#pragma mark -

ON_CREATE_VIEWS( signal )
{
    self.navigationBarTitle = __TEXT(@"gooddetail_commit");
    [self showNavigationBarAnimated:NO];
    [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav_back.png"]];
    
    @weakify(self);
    
    self.list.headerClass = [CommonPullLoader class];
    self.list.headerShown = YES;
    
    self.list.footerClass = [CommonFootLoader class];
    self.list.footerShown = YES;
    
    self.list.lineCount = 1;
    self.list.animationDuration = 0.25f;
    
    self.list.whenReloading = ^
    {
        @normalize(self);
        
        if ( self.commentModel.loaded )
        {
            self.list.total = self.commentModel.comments.count;
            
            if ( 0 == self.commentModel.comments.count )
            {
                self.list.total = 1;
                
                BeeUIScrollItem * item = self.list.items[0];
                item.clazz = [CommonNoResultCell class];
                item.size = self.list.size;
                item.rule = BeeUIScrollLayoutRule_Tile;
            }
            else
            {
                for ( int i = 0; i < self.commentModel.comments.count; i++ )
                {
                    COMMENT * comment = [self.commentModel.comments safeObjectAtIndex:i];
                    
                    if ( i == 0 )
                    {
                        if ( 1 == self.commentModel.comments.count )
                        {
                            comment.scrollIndex = UIScrollViewIndexSingle;
                        }
                        else
                        {
                            comment.scrollIndex = UIScrollViewIndexFirst;
                        }
                    }
                    else if ( i == self.commentModel.comments.count - 1 )
                    {
                        comment.scrollIndex = UIScrollViewIndexLast;
                    }
                    else
                    {
                        comment.scrollIndex = UIScrollViewIndexDefault;
                    }
                    
                    BeeUIScrollItem * item = self.list.items[i];
                    item.clazz = [B5_ProductCommentCell_iPhone class];
                    item.size = CGSizeAuto;
                    item.data = comment;
                    item.rule = BeeUIScrollLayoutRule_Tile;
                }
            }
        }
        else
        {
            // do nothing
        }

    };
    self.list.whenHeaderRefresh = ^
    {
        @normalize(self);
        
        [self.commentModel firstPage];
    };
    self.list.whenFooterRefresh = ^
    {
        @normalize(self);
        
        [self.commentModel nextPage];
    };
    self.list.whenReachBottom = ^
    {
        @normalize(self);
        
        [self.commentModel nextPage];
    };
}

ON_DELETE_VIEWS( signal )
{
    self.list = nil;
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
    if ( NO == self.commentModel.loaded )
    {
       [self.commentModel firstPage];
    }
    
    [bee.ui.appBoard hideTabbar];

}

ON_DID_APPEAR( signal )
{
}

ON_WILL_DISAPPEAR( signal )
{
}

ON_DID_DISAPPEAR( signal )
{
}

#pragma mark -

ON_LEFT_BUTTON_TOUCHED( signal )
{
    [self.stack popBoardAnimated:YES];
}

ON_RIGHT_BUTTON_TOUCHED( signal )
{
}

#pragma mark -

ON_MESSAGE3( API, comments, msg )
{
	if ( msg.sending )
	{
		[self.list setFooterLoading:(self.commentModel.comments.count ? YES: NO)];
	}
	else
	{
		[self.list setFooterLoading:NO];
		[self.list setHeaderLoading:NO];

		[self dismissTips];
	}

	if ( msg.succeed )
	{
		STATUS * status = msg.GET_OUTPUT(@"status");
		
		if ( status && status.succeed.boolValue )
		{
			[self.list asyncReloadData];
			[self.list setFooterMore:[self commentModel].more];
		}
		else
		{
			[self showErrorTips:msg];
		}
	}
	else if( msg.failed )
	{
		[self showErrorTips:msg];
	}
}

@end
