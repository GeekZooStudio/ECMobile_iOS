//
//  FormCell.m
//  shop
//
//  Created by QFish on 2/13/14.
//  Copyright (c) 2014 geek-zoo studio. All rights reserved.
//

#import "FormInputCell.h"

@implementation FormInputCell

- (void)dataDidChanged
{
    FormData * data = self.data;
    
    self.input.text = data.text;
    self.input.placeholder = data.placeholder;
    self.input.returnKeyType = data.returnKeyType;
}

@end
