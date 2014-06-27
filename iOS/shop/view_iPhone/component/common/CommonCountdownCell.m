//
//                       __
//                      /\ \   _
//    ____    ____   ___\ \ \_/ \           _____    ___     ___
//   / _  \  / __ \ / __ \ \    <     __   /\__  \  / __ \  / __ \
//  /\ \_\ \/\  __//\  __/\ \ \\ \   /\_\  \/_/  / /\ \_\ \/\ \_\ \
//  \ \____ \ \____\ \____\\ \_\\_\  \/_/   /\____\\ \____/\ \____/
//   \/____\ \/____/\/____/ \/_//_/         \/____/ \/___/  \/___/
//     /\____/
//     \/___/
//
//	Powered by BeeFramework
//

#import "CommonCountdownCell.h"

#pragma mark - NSDate category

@interface NSDate ( LeftTime )

- (NSString *)leftTime;

@end

@implementation NSDate( LeftTime )

- (NSString *)leftTime
{
	long int delta = lround( [self timeIntervalSinceDate:[NSDate date]] );
    
    NSMutableString * result = [NSMutableString string];
    
    if ( delta >= DAY )
    {
        NSInteger days = ( delta / DAY );
        [result appendFormat:@"%d天", days];
        delta -= days * DAY ;
    }
    
    if ( delta >= HOUR )
    {
        NSInteger hours = ( delta / HOUR );
        [result appendFormat:@"%d小时", hours];
        delta -= hours * HOUR ;
    }
    
    if ( delta >= MINUTE )
    {
        NSInteger minutes = ( delta / MINUTE );
        [result appendFormat:@"%d分钟", minutes];
        delta -= minutes * MINUTE ;
    }
    
	NSInteger seconds = ( delta / SECOND );
	[result appendFormat:@"%d秒", seconds];
    
	return result;
}

@end

#pragma mark - CommonCountdownCell

@interface CommonCountdownCell()
{
    BOOL _counting;
}
@end

@implementation CommonCountdownCell

//DEF_NOTIFICATION( COUNTDOWN_START );
//DEF_NOTIFICATION( COUNTDOWN_END );

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

- (void)load
{
}

- (void)unload
{
    [self stopCount];
}

#pragma mark - BindData

- (void)bindData:(id)data
{
    if ( data )
    {
        if ( [data isKindOfClass:[NSDate class]] )
        {
            self.endDate = (NSDate *)data;
        }
        else if ( [data isKindOfClass:[NSString class]] )
        {
            self.endDate = [(NSString *)data asNSDate];
        }
        
        [self beginCount];
    }
}

#pragma mark - Count

- (void)beginCount
{
    if ( NO == _counting )
    {
        _counting = YES;
        
        [self countdown];
//        [self postNotification:self.COUNTDOWN_START];
        [self observeTick];
    }
}

- (void)stopCount
{
    _counting = NO;
    [self unobserveTick];
}

- (void)handleTick:(NSTimeInterval)elapsed
{
    [self countdown];
}

- (void)countdown
{
    NSTimeInterval _left = [self.endDate timeIntervalSinceDate:[NSDate date]];
    
    if ( 0 >= _left )
    {
        [self stopCount];
        [self stopAnimation];
//        [self postNotification:self.COUNTDOWN_END];
    }
    else
    {
        [self countAnimation];
    }
}

- (void)countAnimation
{
    $(@"#countdown").DATA( [self.endDate leftTime] );
    self.RELAYOUT();
}

- (void)stopAnimation
{
    $(@".countdown-label").HIDE();
    $(@"#countdown").DATA( @"特价已结束" );
    self.RELAYOUT();
}

@end
