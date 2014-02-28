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

#import "Bee.h"

#pragma mark -

@interface CommonCountdownCell : BeeUICell

//AS_NOTIFICATION( COUNTDOWN_END );
//AS_NOTIFICATION( COUNTDOWN_START );

@property (nonatomic, retain) NSTimer * timer;
@property (nonatomic, retain) NSDate *  endDate;
@property (nonatomic, retain) NSDate *  startDate;

- (void)beginCount;
- (void)stopCount;
- (void)countdown;

@end
