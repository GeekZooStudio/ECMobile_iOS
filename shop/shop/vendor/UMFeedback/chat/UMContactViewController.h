//
//  UMContactViewController.h
//  Demo
//
//  Created by liuyu on 4/2/13.
//  Copyright (c) 2013 iOS@Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UMContactViewControllerDelegate;

@interface UMContactViewController : UIViewController

@property(nonatomic, retain) IBOutlet UITextView *textView;
@property(nonatomic, assign) id <UMContactViewControllerDelegate> delegate;

@end

@protocol UMContactViewControllerDelegate <NSObject>

@optional

- (void)updateContactInfo:(UMContactViewController *)controller contactInfo:(NSString *)info;

@end