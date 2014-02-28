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

@interface OrderModel : BeePagingViewModel

@property (nonatomic, retain) NSString *		type;
@property (nonatomic, retain) NSMutableArray *	orders;
@property (nonatomic, retain) NSString *		html;

- (void)affirmReceived:(ORDER *)order;
- (void)cancel:(ORDER *)order;
- (void)pay:(ORDER *)order;

@end
