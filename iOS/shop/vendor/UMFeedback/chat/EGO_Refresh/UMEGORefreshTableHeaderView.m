//
//  UMEGORefreshTableHeaderView.m
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "UMEGORefreshTableHeaderView.h"

#define TEXT_COLOR   [UIColor colorWithRed:128.0/255.0 green:140.0/255.0 blue:146.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f

#define HEADERVIEW_HEIGHT 50.0f

@interface UMEGORefreshTableHeaderView (Private)
- (void)setState:(UMEGOPullRefreshState)aState;
@end

@implementation UMEGORefreshTableHeaderView

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 20.0f, self.frame.size.width, 16.0f)];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        label.font = [UIFont systemFontOfSize:11.0f];
        label.textColor = TEXT_COLOR;
        label.shadowColor = [[UIColor whiteColor] colorWithAlphaComponent:0.75];
        label.shadowOffset = CGSizeMake(0.0f, 1.0f);
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        [self addSubview:label];
        _lastUpdatedLabel = label;
        [label release];

        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 40.0f, self.frame.size.width, 16.0f)];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textColor = TEXT_COLOR;
        label.shadowColor = [[UIColor whiteColor] colorWithAlphaComponent:0.75];
        label.shadowOffset = CGSizeMake(0.0f, 1.0f);
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        [self addSubview:label];
        _statusLabel = label;
        [label release];

        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(30.0f, frame.size.height - 45.0f, 30.0f, 40.0f);
        layer.contentsGravity = kCAGravityResizeAspect;
        layer.contents = (id) [UIImage imageNamed:@"blueArrow"].CGImage;

        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
            layer.contentsScale = [[UIScreen mainScreen] scale];
        }

        [[self layer] addSublayer:layer];
        _arrowImage = layer;

        CALayer *umengLogolayer = [CALayer layer];
        umengLogolayer.frame = CGRectMake(frame.size.width / 2 - 60, frame.size.height - 65.0f, 123.0, 17.0);
        umengLogolayer.contentsGravity = kCAGravityResizeAspect;
//        umengLogolayer.contents = (id) [UIImage imageNamed:@"umeng_logo.png"].CGImage;

        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
            umengLogolayer.contentsScale = [[UIScreen mainScreen] scale];
        }

        [[self layer] addSublayer:umengLogolayer];
        _umengLogo = umengLogolayer;

        UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        view.frame = CGRectMake(30.0f, frame.size.height - 30.0f, 16.0f, 16.0f);
        [self addSubview:view];
        _activityView = view;
        [view release];

        [self setState:UMEGOOPullRefreshNormal];

    }

    return self;

}


#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate {

    if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceLastUpdated:)]) {

        NSDate *date = [_delegate egoRefreshTableHeaderDataSourceLastUpdated:self];

        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setAMSymbol:NSLocalizedString(@"a_m", @"上午")];
        [formatter setPMSymbol:NSLocalizedString(@"p_m", @"下午")];
        [formatter setDateFormat:@"MM.dd ahh:mm"];
        _lastUpdatedLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Last_updated", @"最后更新"),[formatter stringFromDate:date]];
        [[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"EGORefreshTableView_LastRefresh"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [formatter release];

    } else {

        _lastUpdatedLabel.text = nil;

    }

}

- (void)setState:(UMEGOPullRefreshState)aState {

    switch (aState) {
        case UMEGOOPullRefreshPulling:

            _statusLabel.text = NSLocalizedString(@"Release_to_refresh", @"松开即可刷新...");
            [CATransaction begin];
            [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
            _arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
            [CATransaction commit];

            break;
        case UMEGOOPullRefreshNormal:

            if (_state == UMEGOOPullRefreshPulling) {
                [CATransaction begin];
                [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
                _arrowImage.transform = CATransform3DIdentity;
                [CATransaction commit];
            }

            _statusLabel.text = NSLocalizedString(@"Pull down to refresh", @"下拉可以刷新...");
            [_activityView stopAnimating];
            [CATransaction begin];
            [CATransaction setValue:(id) kCFBooleanTrue forKey:kCATransactionDisableActions];
            _arrowImage.hidden = NO;
            _arrowImage.transform = CATransform3DIdentity;
            [CATransaction commit];

            [self refreshLastUpdatedDate];

            break;
        case UMEGOOPullRefreshLoading:

            _statusLabel.text = NSLocalizedString(@"Loading", @"刷新中...");
            [_activityView startAnimating];
            [CATransaction begin];
            [CATransaction setValue:(id) kCFBooleanTrue forKey:kCATransactionDisableActions];
            _arrowImage.hidden = YES;
            [CATransaction commit];

            break;
        default:
            break;
    }

    _state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView {

    if (_state == UMEGOOPullRefreshLoading) {

        CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
        offset = MIN(offset, HEADERVIEW_HEIGHT - 5);
        scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);

    }
    else if (scrollView.isDragging) {

        BOOL _loading = NO;
        if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
            _loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
        }

        if (_state == UMEGOOPullRefreshPulling && scrollView.contentOffset.y > -HEADERVIEW_HEIGHT && scrollView.contentOffset.y < 0.0f && !_loading) {
            [self setState:UMEGOOPullRefreshNormal];
        } else if (_state == UMEGOOPullRefreshNormal && scrollView.contentOffset.y < -HEADERVIEW_HEIGHT && !_loading) {
            [self setState:UMEGOOPullRefreshPulling];
        }

        if (scrollView.contentInset.top != 0) {
            scrollView.contentInset = UIEdgeInsetsZero;
        }

    }

}

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {

    BOOL _loading = NO;
    if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
        _loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
    }

    if (scrollView.contentOffset.y <= -HEADERVIEW_HEIGHT && !_loading) {

        if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:)]) {
            [_delegate egoRefreshTableHeaderDidTriggerRefresh:self];
        }

        [self setState:UMEGOOPullRefreshLoading];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        scrollView.contentInset = UIEdgeInsetsMake(HEADERVIEW_HEIGHT- 5, 0.0f, 0.0f, 0.0f);
        [UIView commitAnimations];

    }

}

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.3];
    [scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
    [UIView commitAnimations];

    [self setState:UMEGOOPullRefreshNormal];

}

- (void)egoRefreshScrollViewShowLoadingManual:(UIScrollView *)scrollView {
    [self setState:UMEGOOPullRefreshLoading];

    [UIView animateWithDuration:0.3
                     animations:^{
                         scrollView.contentInset = UIEdgeInsetsMake(HEADERVIEW_HEIGHT, 0.0f, 0.0f, 0.0f);
                         scrollView.contentOffset = CGPointMake(0, -HEADERVIEW_HEIGHT);
                     }
    ];
}

- (void)egoRefreshScrollViewDataSourceStartManualLoading:(UIScrollView *)scrollView {

    if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:)]) {
        [_delegate egoRefreshTableHeaderDidTriggerRefresh:self];
    }
}


#pragma mark -
#pragma mark Dealloc

- (void)dealloc {

    _delegate = nil;
    _activityView = nil;
    _statusLabel = nil;
    _arrowImage = nil;
    _umengLogo = nil;
    _lastUpdatedLabel = nil;
    [super dealloc];
}

@end
