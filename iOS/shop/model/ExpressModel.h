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

@interface ExpressModel : BeeOnceViewModel

@property (nonatomic, retain) ORDER *			order;
@property (nonatomic, retain) NSString *		shipping_name;
@property (nonatomic, retain) NSMutableArray *	content;

+ (NSString *)kuaidi100Key;
+ (void)setKuaidi100Key:(NSString *)key;

@end
