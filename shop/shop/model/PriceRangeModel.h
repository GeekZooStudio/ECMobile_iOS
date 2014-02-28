//
//  PriceRangeModel.h
//  shop
//
//  Created by QFish on 9/11/13.
//  Copyright (c) 2013 geek-zoo studio. All rights reserved.
//

#import "Bee.h"
#import "ecmobile.h"

#pragma mark -

@interface PriceRangeModel : BeeOnceViewModel

@property (nonatomic, retain) NSNumber *	category_id;
@property (nonatomic, retain) NSArray *		price_ranges;

@end
