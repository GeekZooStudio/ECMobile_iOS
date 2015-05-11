//
//	 ______    ______    ______    
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_ 
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/ 
//
//	Powered by BeeFramework
//
//
//  E0_ProfileHelpBoard_iPhone.m
//  shop
//
//  Created by purplepeng on 14-2-28.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "E0_ProfileHelpBoard_iPhone.h"
#import "E0_ProfileHelpCell_iPhone.h"
#import "G1_HelpBoard_iPhone.h"
#import "CommonPullLoader.h"

#pragma mark -

@implementation E0_ProfileHelpBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( BeeUIScrollView, list )

DEF_MODEL( ArticleGroupModel,	articleGroupModel )

- (void)load
{
    self.articleGroupModel = [ArticleGroupModel modelWithObserver:self];
}

- (void)unload
{
    SAFE_RELEASE_MODEL( self.articleGroupModel );
}

#pragma mark -

ON_CREATE_VIEWS( signal )
{
    self.navigationBarTitle = __TEXT(@"profile_help");
    [self showNavigationBarAnimated:NO];
    [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav_back.png"]];
    
    @weakify(self);
    
    self.list.headerClass = [CommonPullLoader class];
    self.list.headerShown = YES;
    
    self.list.lineCount = 1;
    self.list.animationDuration = 0.25f;
    
    self.list.whenReloading = ^
    {
        @normalize(self);
        
        self.list.total = self.articleGroupModel.articleGroups.count;
        
        for ( int i = 0; i < self.articleGroupModel.articleGroups.count; i++ )
        {
            BeeUIScrollItem * item = self.list.items[ i ];
            item.clazz = [E0_ProfileHelpCell_iPhone class];
            item.size = CGSizeAuto;
            item.data = [self.articleGroupModel.articleGroups safeObjectAtIndex:i];
            item.rule = BeeUIScrollLayoutRule_Tile;
        }
    };
    self.list.whenHeaderRefresh = ^
    {
        @normalize(self);
        
        [self.articleGroupModel reload];
    };
}

ON_DELETE_VIEWS( signal )
{
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
    [self.articleGroupModel reload];
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

ON_SIGNAL2( E0_ProfileHelpCell_iPhone, signal )
{
    ARTICLE_GROUP * articleGroup = signal.sourceCell.data;
	if ( articleGroup )
	{
		G1_HelpBoard_iPhone * board = [G1_HelpBoard_iPhone board];
		board.articleGroup = articleGroup;
		[self.stack pushBoard:board animated:YES];
	}
}

#pragma mark - 

ON_MESSAGE3( API, shopHelp, msg )
{
    if ( msg.sending )
    {
        if ( NO == self.articleGroupModel.loaded )
        {
            [self presentLoadingTips:__TEXT(@"tips_loading")];
        }
    }
    else
    {
        [self.list setHeaderLoading:NO];
        
        [self dismissTips];
    }
    
    if ( msg.succeed )
    {
        [self.list asyncReloadData];
    }
}

@end
