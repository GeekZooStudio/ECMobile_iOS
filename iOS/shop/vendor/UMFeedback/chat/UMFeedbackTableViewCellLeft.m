//
//  FeedbackTableViewCell.m
//  UMeng Analysis
//
//  Created by liuyu on 9/18/12.
//  Copyright (c) 2012 Realcent. All rights reserved.
//

#import "UMFeedbackTableViewCellLeft.h"

#define TOP_MARGIN 20.0f

@implementation UMFeedbackTableViewCellLeft

@synthesize timestampLabel = _timestampLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        if ([[UIDevice currentDevice].systemVersion floatValue] < 7.0f) {
            self.textLabel.backgroundColor = [UIColor whiteColor];
        }
        self.textLabel.font = [UIFont systemFontOfSize:14.0f];
        self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.textLabel.numberOfLines = 0;
        self.textLabel.textAlignment = UITextAlignmentLeft;
        self.textLabel.textColor = [UIColor blackColor];

        _timestampLabel = [[UILabel alloc] init];
        _timestampLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _timestampLabel.textAlignment = UITextAlignmentCenter;
        _timestampLabel.backgroundColor = [UIColor clearColor];
        _timestampLabel.font = [UIFont systemFontOfSize:12.0f];
        _timestampLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0];
        _timestampLabel.frame = CGRectMake(0.0f, 12, self.bounds.size.width, 18);

        [self.contentView addSubview:_timestampLabel];

        messageBackgroundView = [[UIImageView alloc] initWithFrame:self.textLabel.frame];
        messageBackgroundView.image = [[UIImage imageNamed:@"messages_left_bubble.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:16];
        [self.contentView insertSubview:messageBackgroundView belowSubview:self.textLabel];

        self.selectionStyle = UITableViewCellSelectionStyleNone;

    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGRect textLabelFrame = self.textLabel.frame;
    textLabelFrame.origin.x = 18;
    textLabelFrame.size.width = 226;

    CGSize labelSize = [self.textLabel.text sizeWithFont:[UIFont systemFontOfSize:14.0f]
                                       constrainedToSize:CGSizeMake(226.0f, MAXFLOAT)
                                           lineBreakMode:UILineBreakModeWordWrap];

    textLabelFrame.size.height = labelSize.height;
    textLabelFrame.origin.y = 20.0f + TOP_MARGIN;
    self.textLabel.frame = textLabelFrame;

    messageBackgroundView.frame = CGRectMake(10, textLabelFrame.origin.y - 12, labelSize.width + 16, labelSize.height + 18);;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1].CGColor);

    CGContextSetLineWidth(context, 1.0);
    CGContextMoveToPoint(context, 0, 21); //start at this point
    CGContextAddLineToPoint(context, (self.bounds.size.width - 120) / 2, 21); //draw to this point

    CGContextMoveToPoint(context, self.bounds.size.width, 21); //start at this point
    CGContextAddLineToPoint(context, self.bounds.size.width - (self.bounds.size.width - 120) / 2, 21); //draw to this point

    CGContextStrokePath(context);

}

@end
