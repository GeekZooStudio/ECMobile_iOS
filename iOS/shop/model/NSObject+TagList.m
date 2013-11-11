/*
 *                                                                          
 *       _/_/_/                      _/        _/_/_/_/_/                     
 *    _/          _/_/      _/_/    _/  _/          _/      _/_/      _/_/    
 *   _/  _/_/  _/_/_/_/  _/_/_/_/  _/_/          _/      _/    _/  _/    _/   
 *  _/    _/  _/        _/        _/  _/      _/        _/    _/  _/    _/    
 *   _/_/_/    _/_/_/    _/_/_/  _/    _/  _/_/_/_/_/    _/_/      _/_/       
 *                                                                          
 *
 *  Copyright 2013-2014, Geek Zoo Studio
 *  http://www.ecmobile.cn/license.html
 *
 *  HQ China:
 *    2319 Est.Tower Van Palace 
 *    No.2 Guandongdian South Street 
 *    Beijing , China
 *
 *  U.S. Office:
 *    One Park Place, Elmira College, NY, 14901, USA
 *
 *  QQ Group:   329673575
 *  BBS:        bbs.ecmobile.cn
 *  Fax:        +86-10-6561-5510
 *  Mail:       info@geek-zoo.com
 */

#import "NSObject+TagList.h"
#import "model.h"

@implementation NSObject (TagList)
- (NSString *)tagTitle
{
    return nil;
}
- (NSString *)tagRecipt
{
    return nil;
}
@end

@implementation BRAND (TagList)

- (NSString *)tagTitle
{
    return self.brand_name;
}
- (NSString *)tagRecipt
{
    return [self.brand_id description];
}
@end

@implementation CATEGORY (TagList)

- (NSString *)tagTitle
{
    return self.name;
}
- (NSString *)tagRecipt
{
    return [self.id description];
}
@end

@implementation PRICE_RANGE (TagList)

- (NSString *)tagTitle
{
    return [NSString stringWithFormat:@"%@ - %@", self.price_min, self.price_max];
}
- (NSString *)tagRecipt
{
    return [self.price_min description];
}
@end

@implementation GOOD_SPEC_VALUE (TagList)

- (NSString *)tagTitle
{
    return [NSString stringWithFormat:@"%@( %@ )", self.value.label, self.value.format_price];
}

- (NSString *)tagRecipt
{
    return [self.value.id description];
}

@end
