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

@interface CartModel : BeeOnceViewModel

AS_SINGLETON( CartModel )

AS_NOTIFICATION( UPDATED )

@property (nonatomic, retain) NSMutableArray *	goods;
@property (nonatomic, retain) TOTAL *			total;

- (void)create:(GOODS *)goods number:(NSNumber *)number spec:(NSArray *)spec;
- (void)remove:(CART_GOODS *)goods;
- (void)update:(CART_GOODS *)goods new_number:(NSNumber *)new_number;

@end
