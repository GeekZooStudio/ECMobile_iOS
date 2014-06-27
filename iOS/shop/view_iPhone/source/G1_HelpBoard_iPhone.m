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
	
#import "G1_HelpBoard_iPhone.h"
#import "G3_HelpEntryBoard_iPhone.h"
#import "AppBoard_iPhone.h"
#import "G1_HelpCell_iPhone.h"

#pragma mark -

@implementation G1_HelpBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

ON_CREATE_VIEWS(signal)
{
    self.navigationBarTitle = __TEXT(@"profile_personal");
    self.navigationBarLeft  = [UIImage imageNamed:@"nav_back.png"];
    
    @weakify(self);
    
    self.list.whenReloading = ^{
        
        @normalize(self);
        
        NSArray * datas = self.articleGroup.article;
        
        self.list.total += datas.count;
        
        for ( int i=0; i < datas.count; i++ )
        {
            BeeUIScrollItem * item = self.list.items[i];
            item.clazz = [G1_HelpCell_iPhone class];
            item.rule  = BeeUIScrollLayoutRule_Line;
            item.size  = CGSizeAuto;
            item.data  = [datas safeObjectAtIndex:i];
        }
    };
}

ON_DID_APPEAR(signal)
{
    if ( 0 == self.articleGroup.article.count )
    {
        [self presentFailureTips:__TEXT(@"no_data")];
        [self.stack performSelector:@selector(popBoardAnimated:) withObject:@(YES) afterDelay:2.0f];
    }
	
	[self.list reloadData];
}

ON_WILL_APPEAR(signal)
{

    [bee.ui.appBoard hideTabbar];
    self.navigationBarTitle = self.articleGroup.name;
}

ON_LEFT_BUTTON_TOUCHED(signal)
{
    [self.stack popBoardAnimated:YES];
}

#pragma mark - G1_HelpCell_iPhone

ON_SIGNAL3( G1_HelpCell_iPhone, mask, signal )
{
    ARTICLE * article  = signal.sourceCell.data;
	
	G3_HelpEntryBoard_iPhone * board = [G3_HelpEntryBoard_iPhone board];
	board.articlePageModel.article_id = article.id;
	board.articlePageModel.article_title = article.title;
	[self.stack pushBoard:board animated:YES];
}

@end
