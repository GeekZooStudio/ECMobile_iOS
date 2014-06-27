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

#import "B2_ProductSpecifyCell_iPhone.h"

#import "CommonTagList.h"

@implementation GoodsSpecifyBoardCellData
@end

#pragma mark -

@implementation B2_ProductSpecifyCell_iPhone

SUPPORT_RESOURCE_LOADING( YES );
SUPPORT_AUTOMATIC_LAYOUT( YES );

+ (CGSize)estimateUISizeByWidth:(CGFloat)width forData:(id)data expaned:(BOOL)expaned
{
    if ( expaned )
    {
        CGSize size = [B2_ProductSpecifyCell_iPhone estimateUISizeByWidth:width forData:data];
        return size;
    }
    else
    {
        return CGSizeMake( width, 60.0f );
    }
}

- (void)load
{
    UIImage * imageNoraml = [[UIImage imageNamed:@"item_info_buy_kinds_btn_grey.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 20, 5, 30)];
    UIImage * imageSelected = [[UIImage imageNamed:@"item_info_buy_kinds_active_btn.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 20, 5, 30)];
    
    self.taglist.normalImage = imageNoraml;
    self.taglist.selectedImage = imageSelected;
}

- (void)dataDidChanged
{
    if ( self.data )
    {
        GoodsSpecifyBoardCellData * data = self.data;
        
        self.taglist.data = data.tags;
        
        NSString * attrType = nil;
        
        if ( data.spec.attr_type.intValue == ATTR_TYPE_SINGLE )
        {
            self.taglist.isRadio = YES;
            attrType = __TEXT(@"single");
        }
        else if ( data.spec.attr_type.intValue == ATTR_TYPE_MULTI )
        {
            self.taglist.isRadio = NO;
            attrType = __TEXT(@"multiple");
        }
        else if ( data.spec.attr_type.intValue == ATTR_TYPE_UNIQUE )
        {
            self.taglist.isRadio = YES;
            attrType = __TEXT(@"unique");
        }
        
        NSString * title = [NSString stringWithFormat:@"%@(%@)", data.spec.name, attrType];
        
        self.title.data = title;
        
        self.taglist.selectedTags = data.selectedTags;
    }
}

@end
