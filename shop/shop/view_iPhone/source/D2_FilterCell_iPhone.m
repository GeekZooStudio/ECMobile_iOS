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

#import "D2_FilterCell_iPhone.h"
#import "D2_FilterBoard_iPhone.h"

#pragma mark -

@implementation D2_FilterCell_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

+ (CGSize)estimateUISizeByWidth:(CGFloat)width forData:(id)data expaned:(BOOL)expaned
{
    if ( expaned )
    {
        CGSize size = [D2_FilterCell_iPhone estimateUISizeByWidth:width forData:data];
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
    
    self.taglist.isRadio = YES;
    self.taglist.normalImage = imageNoraml;
    self.taglist.selectedImage = imageSelected;
    
    _expaned = YES;
}

- (void)dataDidChanged
{
    if ( self.data )
    {
        FilterCellData * cellData = self.data;
        
        self.title.data = cellData.title;
        self.taglist.data = cellData.array;
        
        switch ( cellData.section )
        {
            case 1:
                if ( cellData.filter.brand_id )
                {
                    self.taglist.selectedTags = @[cellData.filter.brand_id];
                }
                else
                {
                     self.taglist.selectedTags = @[@0];
                }
                break;
            case 2:
                if ( cellData.filter.category_id )
                {
                    self.taglist.selectedTags = @[cellData.filter.category_id];
                }
                else
                {
                    self.taglist.selectedTags = @[@0];
                }
                break;
            case 3:
                if ( cellData.filter.price_range )
                {
                    self.taglist.selectedTags = @[cellData.filter.price_range];
                }
                else
                {
                    self.taglist.selectedTags = @[@0];
                }
                break;
            default:
                break;
        }
        
        self.expaned = cellData.expaned;
    }
    else
    {
        self.title.text = nil;
        self.expaned = NO;
    }
}

- (void)setExpaned:(BOOL)expaned
{
    if ( expaned != _expaned )
    {
        _expaned = expaned;
        
        if ( _expaned )
        {
            self.taglist.alpha = 1;
            self.taglist.hidden = NO;
            self.indictor.image = [UIImage imageNamed:@"accsessory_arrow_up.png"];
        }
        else
        {
            self.taglist.alpha = 0;
            self.taglist.hidden = YES;
            self.indictor.image = [UIImage imageNamed:@"accsessory_arrow_down.png"];
        }
    }
}

@end
