//
//  FormCell.h
//  shop
//
//  Created by QFish on 2/13/14.
//  Copyright (c) 2014 geek-zoo studio. All rights reserved.
//

#import "Bee.h"

#pragma mark -

@interface FormData : NSObject

@property (nonatomic, retain) id            data;

@property (nonatomic, assign) BOOL          isNecessary;
@property (nonatomic, assign) BOOL          enable;
@property (nonatomic, retain) NSString *    text;
@property (nonatomic, retain) NSString *    title;
@property (nonatomic, retain) NSString *    subtitle;
@property (nonatomic, retain) NSString *    tagString;         // used for query

@property (nonatomic, assign) CGSize        size;              // button
@property (nonatomic, retain) NSString *    image;             // button
@property (nonatomic, retain) NSString *    backgroundImage;   // button
@property (nonatomic, retain) NSString *    signal;

@property (nonatomic, assign) BOOL             isSecure;       // input
@property (nonatomic, retain) NSString *       placeholder;    // input
@property (nonatomic, assign) UIReturnKeyType  returnKeyType;  // input
@property (nonatomic, assign) UIKeyboardType   keyboardType;   // input

+ (instancetype)data;

@end
