//
//  DWTagList.m
//
//  Created by Dominic Wroblewski on 07/07/2012.
//  Copyright (c) 2012 Terracoding LTD. All rights reserved.
//

#import "CommonTagListCell.h"
#import "NSObject+TagList.h"

#pragma mark -

@implementation CommonTagListCell

SUPPORT_AUTOMATIC_LAYOUT(YES);
SUPPORT_RESOURCE_LOADING(YES);

+ (id)cellWithData:(id)data
{
    CommonTagListCell * cell = [[[CommonTagListCell alloc] init] autorelease];
    cell.selected = NO;
    cell.data = data;
    return cell;
}

- (void)load
{
    self.title.userInteractionEnabled = NO;
    [self.title setTextColor:[UIColor blackColor]];
    [self.title setShadowColor:[UIColor whiteColor]];
    [self.title setShadowOffset:CGSizeMake(0.0f, 1.0f)];
    [self.title setTextAlignment:NSTextAlignmentCenter];
    [self.title setBackgroundColor:[UIColor clearColor]];
}

- (void)dataDidChanged
{
    if ( self.data )
    {
        [self changeData:self.data];
    }
}

- (void)changeData:(id)data
{
    if ( [data isKindOfClass:[NSString class]] )
    {
        self.title.data = data;
    }
    else if ( [data isKindOfClass:[NSObject class]] )
    {
        if ( [data respondsToSelector:@selector(tagTitle)] )
        {
            self.title.data = [data performSelector:@selector(tagTitle) withObject:nil];
        }
    }
}

- (void)setSelected:(BOOL)selected
{
    self.button.selected = selected;
}

- (BOOL)selected
{
    return self.button.selected;
}

- (void)configWithImage:(UIImage *)normal selected:(UIImage *)selected
{
    [self.button setBackgroundImage:normal   forState:UIControlStateNormal];
    [self.button setBackgroundImage:selected forState:UIControlStateSelected];
}

- (NSString *)description
{
    return self.title.text;
}

@end
