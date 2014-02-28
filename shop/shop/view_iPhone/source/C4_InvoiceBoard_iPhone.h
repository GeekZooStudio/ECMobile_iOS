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
//  Powered by BeeFramework
//
	
#import "Bee.h"
#import "FormCell.h"
#import "FormPlainInputCell.h"

#import "BaseBoard_iPhone.h"

@interface C4_InvoiceBoard_iPhone : BaseBoard_iPhone

AS_INT( SECTION_TYPE );
AS_INT( SECTION_CONTENT );

AS_OUTLET( BeeUITextField, input )
AS_OUTLET( BeeUIScrollView, list )

@property (nonatomic, assign) FlowModel * flowModel;
@property (nonatomic, retain) NSString * inv_title;
@property (nonatomic, retain) NSNumber * inv_type;
@property (nonatomic, retain) NSString * inv_content;

@end