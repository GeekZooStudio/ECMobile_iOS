//
//  FormCell.m
//  shop
//
//  Created by QFish on 2/13/14.
//  Copyright (c) 2014 geek-zoo studio. All rights reserved.
//

#import "FormPlainInputCell.h"

@implementation FormPlainInputCell

- (void)dataDidChanged
{
    FormData * data = self.data;
    
    self.input.text = data.text;
    self.input.placeholder = data.placeholder;
}

@end
