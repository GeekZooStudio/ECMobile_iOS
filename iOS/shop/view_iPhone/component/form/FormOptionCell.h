//
//  FormCell.h
//  shop
//
//  Created by QFish on 2/13/14.
//  Copyright (c) 2014 geek-zoo studio. All rights reserved.
//

#import "Bee.h"
#import "FormCell.h"
#import "FormData.h"

#pragma mark -

@interface FormOptionCell : FormCell
AS_OUTLET( BeeUILabel, title );
AS_OUTLET( BeeUIImageView, accessory );
@end
