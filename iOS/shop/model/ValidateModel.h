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
#import "ecmobile.h"

#pragma mark -

@interface ValidateModel : BeeOnceViewModel

@property (nonatomic, retain) NSString * bonus;
@property (nonatomic, retain) NSNumber * integral;

@property (nonatomic, retain) NSNumber * data_bonus;
@property (nonatomic, retain) NSString * data_bonus_formated;

@property (nonatomic, retain) NSNumber * data_integral;
@property (nonatomic, retain) NSString * data_integral_formated;

- (void)validateBonus;
- (void)validateIntegral;

@end
