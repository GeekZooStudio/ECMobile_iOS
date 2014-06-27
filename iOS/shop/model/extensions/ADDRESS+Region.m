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

#import "ADDRESS+Region.h"

@implementation ADDRESS(Region)

- (BOOL)isRegionValid
{
//    if ( !self.country_name || [self.country_name empty] )
//        return NO;
    
    if ( !self.province_name || [self.province_name empty] )
        return NO;

//    if ( !self.city_name || [self.city_name empty] )
//        return NO;
//
//    if ( !self.district_name || [self.district_name empty] )
//        return NO;
    
    return YES;
}

- (NSString *)availabelName
{
    if ( self.country_name && self.province_name.length )
    {
        return [NSString stringWithFormat:@"%@ ", self.country_name];
    }
    else if ( self.province_name && self.province_name.length )
    {
        return [NSString stringWithFormat:@"%@ ", self.province_name];
    }
    else if ( self.city_name && self.province_name.length )
    {
        return [NSString stringWithFormat:@"%@ ", self.city_name];
    }
    else if ( self.district_name && self.province_name.length )
    {
        return [NSString stringWithFormat:@"%@ ", self.district_name];
    }

	return @"";
}

- (NSString *)region
{
    NSString * string = @"";
    
    if ( self.country_name && self.province_name.length)
    {
        string = [string stringByAppendingFormat:@"%@ ", self.country_name];
    }
    
    if ( self.province_name && self.province_name.length )
    {
        string = [string stringByAppendingFormat:@"%@ ", self.province_name];
    }
    
    if ( self.city_name && self.province_name.length)
    {
        string = [string stringByAppendingFormat:@"%@ ", self.city_name];
    }
    
    if ( self.district_name && self.province_name.length)
    {
        string = [string stringByAppendingFormat:@"%@ ", self.district_name];
    }
    
    return string;
}

- (void)setRegion:(REGION *)region level:(NSUInteger)level
{
    switch ( level )
    {
        case 0:
            self.country = region.id;
            self.country_name = region.name;
            break;
        case 1:
            self.province = region.id;
            self.province_name = region.name;
            break;
        case 2:
            self.city = region.id;
            self.city_name = region.name;
            break;
        case 3:
            self.district = region.id;
            self.district_name = region.name;
            break;
            
        default:
            break;
    }
}

- (void)setRegionValueWithAddress:(ADDRESS *)address
{
    self.country = address.country;
    self.country_name = address.country_name;
    self.province = address.province;
    self.province_name = address.province_name;
    self.city = address.city;
    self.city_name = address.city_name;
    self.district = address.district;
    self.district_name = address.district_name;
}

@end
