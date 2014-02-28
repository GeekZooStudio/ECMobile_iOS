//
//  B3_ProductPhotoBoard_iPhone.h
//

#import "Bee.h"
#import "ecmobile.h"

#pragma mark -

@interface B3_ProductPhotoBoard_iPhone : BeeUIBoard

AS_OUTLET( BeeUIScrollView, list )
AS_OUTLET( BeeUIPageControl, pager )

@property (nonatomic, retain) GOODS *				goods;
@property (nonatomic, assign) NSUInteger			pageIndex;

@end
