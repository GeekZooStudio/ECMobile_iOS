//
//   ______    ______    ______    
//  /\  __ \  /\  ___\  /\  ___\
//  \ \  __<  \ \  __\_ \ \  __\_ 
//   \ \_____\ \ \_____\ \ \_____\
//    \/_____/  \/_____/  \/_____/ 
//
//  Powered by BeeFramework
//
//
//  E0_ProfileHelpBoard_iPhone.h
//  shop
//
//  Created by purplepeng on 14-2-28.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "Bee.h"
#import "BaseBoard_iPhone.h"

#pragma mark -

@interface E0_ProfileHelpBoard_iPhone : BaseBoard_iPhone

AS_OUTLET( BeeUIScrollView, list )

AS_MODEL( ArticleGroupModel,	articleGroupModel )

@end
