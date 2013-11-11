/*
 *                                                                          
 *       _/_/_/                      _/        _/_/_/_/_/                     
 *    _/          _/_/      _/_/    _/  _/          _/      _/_/      _/_/    
 *   _/  _/_/  _/_/_/_/  _/_/_/_/  _/_/          _/      _/    _/  _/    _/   
 *  _/    _/  _/        _/        _/  _/      _/        _/    _/  _/    _/    
 *   _/_/_/    _/_/_/    _/_/_/  _/    _/  _/_/_/_/_/    _/_/      _/_/       
 *                                                                          
 *
 *  Copyright 2013-2014, Geek Zoo Studio
 *  http://www.ecmobile.cn/license.html
 *
 *  HQ China:
 *    2319 Est.Tower Van Palace 
 *    No.2 Guandongdian South Street 
 *    Beijing , China
 *
 *  U.S. Office:
 *    One Park Place, Elmira College, NY, 14901, USA
 *
 *  QQ Group:   329673575
 *  BBS:        bbs.ecmobile.cn
 *  Fax:        +86-10-6561-5510
 *  Mail:       info@geek-zoo.com
 */

#import "CountdownCell.h"

#pragma mark - 

@interface CountdownCell()
{
    BOOL _counting;
}
@end

@implementation CountdownCell

//DEF_NOTIFICATION( COUNTDOWN_START );
//DEF_NOTIFICATION( COUNTDOWN_END );

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

- (void)load
{
    [super load];
}

- (void)unload
{
    [self stopCount];
    [super unload];
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
    $(@"#countdown").DATA( [self.endDate timeLeft] );
    self.RELAYOUT();
}

- (void)stopAnimation
{
    $(@".countdown-label").HIDE();
    $(@"#countdown").DATA( @"特价已结束" );
    self.RELAYOUT();
}

@end
