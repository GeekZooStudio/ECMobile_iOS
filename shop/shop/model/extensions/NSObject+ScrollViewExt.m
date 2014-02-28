//
//  NSObject+ScrollViewExt.m
//  shop
//
//  Created by QFish on 2/13/14.
//  Copyright (c) 2014 geek-zoo studio. All rights reserved.
//

#import "NSObject+ScrollViewExt.h"

#undef	KEY_SCROLL_EDITING
#define KEY_SCROLL_EDITING  "NSObject.scroll.editing"

#undef	KEY_SCROLL_INDEX
#define KEY_SCROLL_INDEX    "NSObject.scroll.index"

#undef  KEY_SCROLL_SECTION
#define KEY_SCROLL_SECTION  "NSObject.scroll.section"

#undef	KEY_SCROLL_SELECTED
#define KEY_SCROLL_SELECTED "NSObject.scroll.selected"

@implementation NSObject (ScrollViewExt)

@dynamic scrollIndex;
@dynamic scrollSection;
@dynamic scrollEditing;
@dynamic scrollSelected;

- (BOOL)scrollEditing
{
	return [objc_getAssociatedObject( self, KEY_SCROLL_EDITING ) boolValue];
}

- (void)setScrollEditing:(BOOL)editing
{
    objc_setAssociatedObject( self, KEY_SCROLL_EDITING, @(editing), OBJC_ASSOCIATION_ASSIGN );
}

- (BOOL)scrollSelected
{
	return [objc_getAssociatedObject( self, KEY_SCROLL_SELECTED ) boolValue];
}

- (void)setScrollSelected:(BOOL)selected
{
    objc_setAssociatedObject( self, KEY_SCROLL_SELECTED, @(selected), OBJC_ASSOCIATION_ASSIGN );
}

- (NSUInteger)scrollIndex
{
	return [objc_getAssociatedObject( self, KEY_SCROLL_INDEX ) integerValue];
}

- (void)setScrollIndex:(NSUInteger)index
{
    objc_setAssociatedObject( self, KEY_SCROLL_INDEX, @(index), OBJC_ASSOCIATION_ASSIGN );
}

- (NSUInteger)scrollSection
{
  return [objc_getAssociatedObject( self, KEY_SCROLL_SECTION ) integerValue];
}

- (void)setScrollSection:(NSUInteger)scrollSection
{
    objc_setAssociatedObject( self, KEY_SCROLL_SECTION, @(scrollSection), OBJC_ASSOCIATION_ASSIGN );
}

@end
