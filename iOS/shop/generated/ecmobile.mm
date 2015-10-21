//
// ECMobile (Geek-Zoo Studio)
//
// generated at 2013-06-17 05:47:47 +0000
//

#import "ecmobile.h"

#pragma mark - models

@implementation ADDRESS

@synthesize id = _id;
@synthesize address = _address;
@synthesize best_time = _best_time;
@synthesize city = _city;
@synthesize country = _country;
@synthesize default_address = _default_address;
@synthesize district = _district;
@synthesize email = _email;
@synthesize mobile = _mobile;
@synthesize name = _name;
@synthesize province = _province;
@synthesize sign_building = _sign_building;
@synthesize tel = _tel;
@synthesize zipcode = _zipcode;

@end

@implementation ARTICLE

@synthesize id = _id;
@synthesize short_title = _short_title;
@synthesize title = _title;

@end

@implementation ARTICLE_GROUP

@synthesize article = _article;
@synthesize name = _name;

CONVERT_PROPERTY_CLASS( article, ARTICLE );

@end

@implementation BANNER

@synthesize action = _action;
@synthesize action_id = _action_id;
@synthesize description = _description;
@synthesize photo = _photo;
@synthesize url = _url;

@end

@implementation BONUS
@synthesize type_id = _type_id;
@synthesize type_name = _type_name;
@synthesize type_money = _type_money;
@synthesize bonus_id = _bonus_id;
@synthesize bonus_money_formated = _bonus_money_formated;
@end

@implementation BRAND
@synthesize url = _url;
@synthesize brand_id = _brand_id;
@synthesize brand_name = _brand_name;
@end

@implementation CART_GOODS

@synthesize rec_id = _rec_id;
@synthesize can_handsel = _can_handsel;
@synthesize extension_code = _extension_code;
@synthesize formated_goods_price = _formated_goods_price;
@synthesize formated_market_price = _formated_market_price;
@synthesize formated_subtotal = _formated_subtotal;
@synthesize goods_attr = _goods_attr;
@synthesize goods_attr_id = _goods_attr_id;
@synthesize goods_id = _goods_id;
@synthesize goods_name = _goods_name;
@synthesize goods_number = _goods_number;
@synthesize goods_price = _goods_price;
@synthesize goods_sn = _goods_sn;
@synthesize img = _img;
@synthesize is_gift = _is_gift;
@synthesize is_real = _is_real;
@synthesize is_shipping = _is_shipping;
@synthesize market_price = _market_price;
@synthesize parent_id = _parent_id;
@synthesize pid = _pid;
@synthesize rec_type = _rec_type;
@synthesize subtotal = _subtotal;

CONVERT_PROPERTY_CLASS( goods_attr, GOOD_ATTR );

@end

@implementation CATEGORY

@synthesize id = _id;
@synthesize goods = _goods;
@synthesize name = _name;

CONVERT_PROPERTY_CLASS( goods, SIMPLE_GOODS );

@end

@implementation TOP_CATEGORY

@synthesize children = _children;
@synthesize name = _name;
@synthesize id = _id;

CONVERT_PROPERTY_CLASS( children, CATEGORY );

@end

@implementation COMMENT

@synthesize id = _id;
@synthesize author = _author;
@synthesize content = _content;
@synthesize create = _create;
@synthesize re_content = _re_content;

@end

@implementation CONFIG

@synthesize close_comment = _close_comment;
@synthesize service_phone = _service_phone;
@synthesize shop_closed = _shop_closed;
@synthesize shop_desc = _shop_desc;
@synthesize shop_reg_closed = _shop_reg_closed;
@synthesize site_url = _site_url;
@synthesize goods_url = _goods_url;

@end

@implementation EXPRESS

@synthesize context = _context;
@synthesize time = _time;

@end

@implementation FILTER

@synthesize brand_id = _brand_id;
@synthesize category_id = _category_id;
@synthesize keywords = _keywords;
@synthesize price_range = _price_range;
@synthesize sort_by = _sort_by;

@end

@implementation GOODS

@synthesize id = _id;
@synthesize brand_id = _brand_id;
@synthesize cat_id = _cat_id;
@synthesize click_count = _click_count;
@synthesize goods_name = _goods_name;
@synthesize goods_number = _goods_number;
@synthesize goods_sn = _goods_sn;
@synthesize goods_weight = _goods_weight;
@synthesize img = _img;
@synthesize collected = _collected;
@synthesize integral = _integral;
@synthesize is_shipping = _is_shipping;
@synthesize market_price = _market_price;
@synthesize pictures = _pictures;
@synthesize promote_end_date = _promote_end_date;
@synthesize promote_price = _promote_price;
@synthesize promote_start_date = _promote_start_date;
@synthesize properties = _properties;
@synthesize rank_prices = _rank_prices;
@synthesize shop_price = _shop_price;
@synthesize specification = _specification;

CONVERT_PROPERTY_CLASS( pictures, PHOTO );
CONVERT_PROPERTY_CLASS( properties, GOOD_ATTR );
CONVERT_PROPERTY_CLASS( rank_prices, GOOD_RANK_PRICE );
CONVERT_PROPERTY_CLASS( specification, GOOD_SPEC );

@end

@implementation GOOD_ATTR

@synthesize name = _name;
@synthesize value = _value;

@end

@implementation GOOD_RANK_PRICE

@synthesize id = _id;
@synthesize price = _price;
@synthesize rank_name = _rank_name;

@end

@implementation GOOD_SPEC

@synthesize attr_type = _attr_type;
@synthesize name = _name;
@synthesize value = _value;

CONVERT_PROPERTY_CLASS( value, GOOD_VALUE );

@end

@implementation GOOD_VALUE

@synthesize format_price = _format_price;
@synthesize id = _id;
@synthesize label = _label;
@synthesize price = _price;

@end

@implementation GOOD_SPEC_VALUE
@synthesize spec = _spec;
@synthesize value = _value;
@end

@implementation INVOICE

@synthesize id = _id;
@synthesize value = _value;

@end

@implementation ORDER_INFO

@synthesize pay_code = _pay_code;
@synthesize order_sn = _order_sn;
@synthesize order_amount = _order_amount;
@synthesize order_id = _order_id;
@synthesize subject = _subject;
@synthesize desc = _desc;

@end

@implementation ORDER

@synthesize order_id = _order_id;
@synthesize goods_list = _goods_list;
@synthesize order_sn = _order_sn;
@synthesize order_time = _order_time;
@synthesize total_fee = _total_fee;
@synthesize order_info = _order_info;

CONVERT_PROPERTY_CLASS( goods_list, ORDER_GOODS );

@end

@implementation ORDER_GOODS

@synthesize goods_id = _goods_id;
@synthesize formated_shop_price = _formated_shop_price;
@synthesize goods_number = _goods_number;
@synthesize img = _img;
@synthesize name = _name;
@synthesize subtotal = _subtotal;

@end

@implementation PAGINATED

@synthesize count = _count;
@synthesize more = _more;
@synthesize total = _total;

@end

@implementation PAGINATION

@synthesize count = _count;
@synthesize page = _page;

@end

@implementation PAYMENT

@synthesize pay_id = _pay_id;
@synthesize format_pay_fee = _format_pay_fee;
@synthesize is_cod = _is_cod;
@synthesize pay_code = _pay_code;
@synthesize pay_desc = _pay_desc;
@synthesize pay_fee = _pay_fee;
@synthesize pay_name = _pay_name;

@end

@implementation PHOTO

@synthesize img = _img;
@synthesize thumb = _thumb;
@synthesize url = _url;
@synthesize small = _small;

@end

@implementation PRICE_RANGE

@synthesize price_min = _price_min;
@synthesize price_max = _price_max;

@end

@implementation REGION

@synthesize id = _id;
@synthesize more = _more;
@synthesize name = _name;
@synthesize parent_id = _parent_id;

@end

@implementation SESSION

@synthesize sid = _sid;
@synthesize uid = _uid;

@end

@implementation SHIPPING

@synthesize shipping_id = _shipping_id;
@synthesize format_shipping_fee = _format_shipping_fee;
@synthesize free_money = _free_money;
@synthesize insure = _insure;
@synthesize insure_formated = _insure_formated;
@synthesize shipping_code = _shipping_code;
@synthesize shipping_desc = _shipping_desc;
@synthesize shipping_fee = _shipping_fee;
@synthesize shipping_name = _shipping_name;
@synthesize support_cod = _support_cod;

@end

@implementation SIGNUP_FIELD

@synthesize id = _id;
@synthesize name = _name;
@synthesize need = _need;

@end

@implementation SIGNUP_FIELD_VALUE

@synthesize id = _id;
@synthesize value = _value;

@end

@implementation SIMPLE_GOODS

@synthesize goods_id = _goods_id;
@synthesize id = _id;
@synthesize brief = _brief;
@synthesize img = _img;
@synthesize market_price = _market_price;
@synthesize name = _name;
@synthesize promote_price = _promote_price;
@synthesize shop_price = _shop_price;

@end

@implementation STATUS

@synthesize error_code = _error_code;
@synthesize error_desc = _error_desc;
@synthesize succeed = _succeed;

@end

@implementation TOTAL

@synthesize goods_amount = _goods_amount;
@synthesize goods_price = _goods_price;
@synthesize market_price = _market_price;
@synthesize real_goods_count = _real_goods_count;
@synthesize save_rate = _save_rate;
@synthesize saving = _saving;
@synthesize virtual_goods_count = _virtual_goods_count;

@end

@implementation USER

@synthesize id = _id;
@synthesize collection_num = _collection_num;
@synthesize name = _name;
@synthesize email = _email;
@synthesize order_num = _order_num;
@synthesize rank_name = _rank_name;
@synthesize rank_level = _rank_level;

@end

@implementation COLLECT_GOODS

@synthesize rec_id = _rec_id;
@synthesize isEditing = _isEditing; // TODO:

@end

#pragma mark - controllers

@implementation API

#pragma mark - POST address/add

DEF_MESSAGE_( address_add, msg )
{
	if ( msg.sending )
	{
		SESSION * session = msg.GET_INPUT( @"session" );
		ADDRESS * address = msg.GET_INPUT( @"address" );

		if ( nil == session || NO == [session isKindOfClass:[SESSION class]] )
		{
			msg.failed = YES;
			return;
		}

		NSMutableDictionary * requestBody = [NSMutableDictionary dictionary];
		requestBody.APPEND( @"session", session );
		requestBody.APPEND( @"address", address );

//		NSString * requestURI = @"http://shop.ecmobile.me/ecmobile/?url=address/add";
		NSString * requestURI = [NSString stringWithFormat:@"%@/address/add", [ServerConfig sharedInstance].url];

		msg.HTTP_POST( requestURI ).PARAM( @"json", requestBody.objectToString );
	}
	else if ( msg.succeed )
	{
		NSDictionary * response = msg.responseJSONDictionary;
		STATUS * status = [STATUS objectFromDictionary:[response dictAtPath:@"status"]];
		ADDRESS * data = [ADDRESS objectFromDictionary:[response dictAtPath:@"data"]];

		if ( nil == status || NO == [status isKindOfClass:[STATUS class]] )
		{
			msg.failed = YES;
			return;
		}

		msg.OUTPUT( @"status", status );
		msg.OUTPUT( @"data", data );

	}
	else if ( msg.failed )
	{
	}
	else if ( msg.cancelled )
	{
	}
}

#pragma mark - POST address/delete

DEF_MESSAGE_( address_delete, msg )
{
	if ( msg.sending )
	{
		NSNumber * address_id = msg.GET_INPUT( @"address_id" );
		SESSION * session = msg.GET_INPUT( @"session" );

		if ( nil == address_id || NO == [address_id isKindOfClass:[NSNumber class]] )
		{
			msg.failed = YES;
			return;
		}
		if ( nil == session || NO == [session isKindOfClass:[SESSION class]] )
		{
			msg.failed = YES;
			return;
		}

		NSMutableDictionary * requestBody = [NSMutableDictionary dictionary];
		requestBody.APPEND( @"address_id", address_id );
		requestBody.APPEND( @"session", session );

//		NSString * requestURI = @"http://shop.ecmobile.me/ecmobile/?url=address/delete";
		NSString * requestURI = [NSString stringWithFormat:@"%@/address/delete", [ServerConfig sharedInstance].url];

		msg.HTTP_POST( requestURI ).PARAM( @"json", requestBody.objectToString );
	}
	else if ( msg.succeed )
	{
		NSDictionary * response = msg.responseJSONDictionary;
		STATUS * status = [STATUS objectFromDictionary:[response dictAtPath:@"status"]];

		if ( nil == status || NO == [status isKindOfClass:[STATUS class]] )
		{
			msg.failed = YES;
			return;
		}

		msg.OUTPUT( @"status", status );

	}
	else if ( msg.failed )
	{
	}
	else if ( msg.cancelled )
	{
	}
}

#pragma mark - POST address/info

DEF_MESSAGE_( address_info, msg )
{
	if ( msg.sending )
	{
		NSNumber * address_id = msg.GET_INPUT( @"address_id" );
		SESSION * session = msg.GET_INPUT( @"session" );

		if ( nil == address_id || NO == [address_id isKindOfClass:[NSNumber class]] )
		{
			msg.failed = YES;
			return;
		}
		if ( nil == session || NO == [session isKindOfClass:[SESSION class]] )
		{
			msg.failed = YES;
			return;
		}

		NSMutableDictionary * requestBody = [NSMutableDictionary dictionary];
		requestBody.APPEND( @"address_id", address_id );
		requestBody.APPEND( @"session", session );

//		NSString * requestURI = @"http://shop.ecmobile.me/ecmobile/?url=address/info";
		NSString * requestURI = [NSString stringWithFormat:@"%@/address/info", [ServerConfig sharedInstance].url];
		
		msg.HTTP_POST( requestURI ).PARAM( @"json", requestBody.objectToString );
	}
	else if ( msg.succeed )
	{
		NSDictionary * response = msg.responseJSONDictionary;
		STATUS * status = [STATUS objectFromDictionary:[response dictAtPath:@"status"]];
		ADDRESS * data = [ADDRESS objectFromDictionary:[response dictAtPath:@"data"]];

		if ( nil == status || NO == [status isKindOfClass:[STATUS class]] )
		{
			msg.failed = YES;
			return;
		}

		msg.OUTPUT( @"status", status );
		msg.OUTPUT( @"data", data );

	}
	else if ( msg.failed )
	{
	}
	else if ( msg.cancelled )
	{
	}
}

#pragma mark - POST address/list

DEF_MESSAGE_( address_list, msg )
{
	if ( msg.sending )
	{
		SESSION * session = msg.GET_INPUT( @"session" );

		if ( nil == session || NO == [session isKindOfClass:[SESSION class]] )
		{
			msg.failed = YES;
			return;
		}

		NSMutableDictionary * requestBody = [NSMutableDictionary dictionary];
		requestBody.APPEND( @"session", session );

//		NSString * requestURI = @"http://shop.ecmobile.me/ecmobile/?url=address/list";
		NSString * requestURI = [NSString stringWithFormat:@"%@/address/list", [ServerConfig sharedInstance].url];
		
		msg.HTTP_POST( requestURI ).PARAM( @"json", requestBody.objectToString );
	}
	else if ( msg.succeed )
	{
		NSDictionary * response = msg.responseJSONDictionary;
		STATUS * status = [STATUS objectFromDictionary:[response dictAtPath:@"status"]];
		NSArray * data = [ADDRESS objectsFromArray:[response arrayAtPath:@"data"]];

		if ( nil == status || NO == [status isKindOfClass:[STATUS class]] )
		{
			msg.failed = YES;
			return;
		}

		msg.OUTPUT( @"status", status );
		msg.OUTPUT( @"data", data );

	}
	else if ( msg.failed )
	{
	}
	else if ( msg.cancelled )
	{
	}
}

#pragma mark - POST address/setDefault

DEF_MESSAGE_( address_setDefault, msg )
{
	if ( msg.sending )
	{
		NSNumber * address_id = msg.GET_INPUT( @"address_id" );
		SESSION * session = msg.GET_INPUT( @"session" );

		if ( nil == address_id || NO == [address_id isKindOfClass:[NSNumber class]] )
		{
			msg.failed = YES;
			return;
		}
		if ( nil == session || NO == [session isKindOfClass:[SESSION class]] )
		{
			msg.failed = YES;
			return;
		}

		NSMutableDictionary * requestBody = [NSMutableDictionary dictionary];
		requestBody.APPEND( @"address_id", address_id );
		requestBody.APPEND( @"session", session );

//		NSString * requestURI = @"http://shop.ecmobile.me/ecmobile/?url=address/setDefault";
		NSString * requestURI = [NSString stringWithFormat:@"%@/address/setDefault", [ServerConfig sharedInstance].url];
		
		msg.HTTP_POST( requestURI ).PARAM( @"json", requestBody.objectToString );
	}
	else if ( msg.succeed )
	{
		NSDictionary * response = msg.responseJSONDictionary;
		STATUS * status = [STATUS objectFromDictionary:[response dictAtPath:@"status"]];

		if ( nil == status || NO == [status isKindOfClass:[STATUS class]] )
		{
			msg.failed = YES;
			return;
		}

		msg.OUTPUT( @"status", status );

	}
	else if ( msg.failed )
	{
	}
	else if ( msg.cancelled )
	{
	}
}

#pragma mark - POST address/update

DEF_MESSAGE_( address_update, msg )
{
	if ( msg.sending )
	{
		ADDRESS * address = msg.GET_INPUT( @"address" );
		NSNumber * address_id = msg.GET_INPUT( @"address_id" );
		SESSION * session = msg.GET_INPUT( @"session" );

		if ( nil == address || NO == [address isKindOfClass:[ADDRESS class]] )
		{
			msg.failed = YES;
			return;
		}
		if ( nil == address_id || NO == [address_id isKindOfClass:[NSNumber class]] )
		{
			msg.failed = YES;
			return;
		}
		if ( nil == session || NO == [session isKindOfClass:[SESSION class]] )
		{
			msg.failed = YES;
			return;
		}

		NSMutableDictionary * requestBody = [NSMutableDictionary dictionary];
		requestBody.APPEND( @"address", address );
		requestBody.APPEND( @"address_id", address_id );
		requestBody.APPEND( @"session", session );

//		NSString * requestURI = @"http://shop.ecmobile.me/ecmobile/?url=address/update";
		NSString * requestURI = [NSString stringWithFormat:@"%@/address/update", [ServerConfig sharedInstance].url];
		
		msg.HTTP_POST( requestURI ).PARAM( @"json", requestBody.objectToString );
	}
	else if ( msg.succeed )
	{
		NSDictionary * response = msg.responseJSONDictionary;
		STATUS * status = [STATUS objectFromDictionary:[response dictAtPath:@"status"]];
		ADDRESS * data = [ADDRESS objectFromDictionary:[response dictAtPath:@"data"]];

		if ( nil == status || NO == [status isKindOfClass:[STATUS class]] )
		{
			msg.failed = YES;
			return;
		}

		msg.OUTPUT( @"status", status );
		msg.OUTPUT( @"data", data );

	}
	else if ( msg.failed )
	{
	}
	else if ( msg.cancelled )
	{
	}
}

#pragma mark - POST article

DEF_MESSAGE_( article, msg )
{
	if ( msg.sending )
	{
		NSNumber * article_id = msg.GET_INPUT( @"article_id" );

		if ( nil == article_id || NO == [article_id isKindOfClass:[NSNumber class]] )
		{
			msg.failed = YES;
			return;
		}

		NSMutableDictionary * requestBody = [NSMutableDictionary dictionary];
		requestBody.APPEND( @"article_id", article_id );

//		NSString * requestURI = @"http://shop.ecmobile.me/ecmobile/?url=article";
		NSString * requestURI = [NSString stringWithFormat:@"%@/article", [ServerConfig sharedInstance].url];
		
		msg.HTTP_POST( requestURI ).PARAM( @"json", requestBody.objectToString );
	}
	else if ( msg.succeed )
	{
		NSDictionary * response = msg.responseJSONDictionary;
		STATUS * status = [STATUS objectFromDictionary:[response dictAtPath:@"status"]];
		NSString * data = [response stringAtPath:@"data"];

		if ( nil == status || NO == [status isKindOfClass:[STATUS class]] )
		{
			msg.failed = YES;
			return;
		}

		msg.OUTPUT( @"status", status );
		msg.OUTPUT( @"data", data );
	}
	else if ( msg.failed )
	{
	}
	else if ( msg.cancelled )
	{
	}
}

#pragma mark - POST cart/create

DEF_MESSAGE_( cart_create, msg )
{
	if ( msg.sending )
	{
		NSNumber * goods_id = msg.GET_INPUT( @"goods_id" );
		NSString * number = msg.GET_INPUT( @"number" );
		SESSION * session = msg.GET_INPUT( @"session" );
		NSArray * spec = msg.GET_INPUT( @"spec" );

		if ( nil == goods_id || NO == [goods_id isKindOfClass:[NSNumber class]] )
		{
			msg.failed = YES;
			return;
		}
		if ( nil == number || NO == [number isKindOfClass:[NSNumber class]] )
		{
			msg.failed = YES;
			return;
		}
		if ( nil == session || NO == [session isKindOfClass:[SESSION class]] )
		{
			msg.failed = YES;
			return;
		}

		NSMutableDictionary * requestBody = [NSMutableDictionary dictionary];
		requestBody.APPEND( @"goods_id", goods_id );
		requestBody.APPEND( @"number", number );
		requestBody.APPEND( @"session", session );
		requestBody.APPEND( @"spec", spec );

//		NSString * requestURI = @"http://shop.ecmobile.me/ecmobile/?url=cart/create";
		NSString * requestURI = [NSString stringWithFormat:@"%@/cart/create", [ServerConfig sharedInstance].url];
		
		msg.HTTP_POST( requestURI ).PARAM( @"json", requestBody.objectToString );
	}
	else if ( msg.succeed )
	{
		NSDictionary * response = msg.responseJSONDictionary;
		STATUS * status = [STATUS objectFromDictionary:[response dictAtPath:@"status"]];

		if ( nil == status || NO == [status isKindOfClass:[STATUS class]] )
		{
			msg.failed = YES;
			return;
		}

		msg.OUTPUT( @"status", status );
	}
	else if ( msg.failed )
	{
	}
	else if ( msg.cancelled )
	{
	}
}

#pragma mark - POST cart/delete

DEF_MESSAGE_( cart_delete, msg )
{
	if ( msg.sending )
	{
		NSNumber * rec_id = msg.GET_INPUT( @"rec_id" );
		SESSION * session = msg.GET_INPUT( @"session" );

		if ( nil == rec_id || NO == [rec_id isKindOfClass:[NSNumber class]] )
		{
			msg.failed = YES;
			return;
		}
		if ( nil == session || NO == [session isKindOfClass:[SESSION class]] )
		{
			msg.failed = YES;
			return;
		}

		NSMutableDictionary * requestBody = [NSMutableDictionary dictionary];
		requestBody.APPEND( @"rec_id", rec_id );
		requestBody.APPEND( @"session", session );

//		NSString * requestURI = @"http://shop.ecmobile.me/ecmobile/?url=cart/delete";
		NSString * requestURI = [NSString stringWithFormat:@"%@/cart/delete", [ServerConfig sharedInstance].url];
		
		msg.HTTP_POST( requestURI ).PARAM( @"json", requestBody.objectToString );
	}
	else if ( msg.succeed )
	{
		NSDictionary * response = msg.responseJSONDictionary;
		STATUS * status = [STATUS objectFromDictionary:[response dictAtPath:@"status"]];
		TOTAL * total = [TOTAL objectFromDictionary:[response dictAtPath:@"total"]];

		if ( nil == status || NO == [status isKindOfClass:[STATUS class]] )
		{
			msg.failed = YES;
			return;
		}

		msg.OUTPUT( @"status", status );
		msg.OUTPUT( @"total", total );

	}
	else if ( msg.failed )
	{
	}
	else if ( msg.cancelled )
	{
	}
}

#pragma mark - POST cart/list

DEF_MESSAGE_( cart_list, msg )
{
	if ( msg.sending )
	{
        SESSION * session = msg.GET_INPUT( @"session" );
        
		if ( nil == session || NO == [session isKindOfClass:[SESSION class]] )
		{
			msg.failed = YES;
			return;
		}

        NSMutableDictionary * requestBody = [NSMutableDictionary dictionary];
		requestBody.APPEND( @"session", session );

//		NSString * requestURI = @"http://shop.ecmobile.me/ecmobile/?url=cart/list";
		NSString * requestURI = [NSString stringWithFormat:@"%@/cart/list", [ServerConfig sharedInstance].url];
		
		
		msg.HTTP_POST( requestURI ).PARAM( @"json", requestBody.objectToString );;
	}
	else if ( msg.succeed )
	{
		NSDictionary * response = msg.responseJSONDictionary;
		STATUS * status = [STATUS objectFromDictionary:[response dictAtPath:@"status"]];
		NSDictionary * data = [response dictAtPath:@"data"];
		NSArray * data_goods_list = [CART_GOODS objectsFromArray:[response arrayAtPath:@"data.goods_list"]];
		TOTAL * data_total = [TOTAL objectFromDictionary:[response dictAtPath:@"data.total"]];

		if ( nil == status || NO == [status isKindOfClass:[STATUS class]] )
		{
			msg.failed = YES;
			return;
		}

	 	msg.OUTPUT( @"status", status );
		msg.OUTPUT( @"data", data );
        msg.OUTPUT( @"data_goods_list", data_goods_list );
        msg.OUTPUT( @"data_total", data_total );

	}
	else if ( msg.failed )
	{
	}
	else if ( msg.cancelled )
	{
	}
}

#pragma mark - POST cart/update

DEF_MESSAGE_( cart_update, msg )
{
	if ( msg.sending )
	{
		NSNumber * new_number = msg.GET_INPUT( @"new_number" );
		NSNumber * rec_id = msg.GET_INPUT( @"rec_id" );
		SESSION * session = msg.GET_INPUT( @"session" );

		if ( nil == new_number || NO == [new_number isKindOfClass:[NSNumber class]] )
		{
			msg.failed = YES;
			return;
		}
		if ( nil == rec_id || NO == [rec_id isKindOfClass:[NSNumber class]] )
		{
			msg.failed = YES;
			return;
		}
		if ( nil == session || NO == [session isKindOfClass:[SESSION class]] )
		{
			msg.failed = YES;
			return;
		}

		NSMutableDictionary * requestBody = [NSMutableDictionary dictionary];
		requestBody.APPEND( @"new_number", new_number );
		requestBody.APPEND( @"rec_id", rec_id );
		requestBody.APPEND( @"session", session );

//		NSString * requestURI = @"http://shop.ecmobile.me/ecmobile/?url=cart/update";
		NSString * requestURI = [NSString stringWithFormat:@"%@/cart/update", [ServerConfig sharedInstance].url];
		
		msg.HTTP_POST( requestURI ).PARAM( @"json", requestBody.objectToString );
	}
	else if ( msg.succeed )
	{
		NSDictionary * response = msg.responseJSONDictionary;
		STATUS * status = [STATUS objectFromDictionary:[response dictAtPath:@"status"]];
		TOTAL * total = [TOTAL objectFromDictionary:[response dictAtPath:@"total"]];

		if ( nil == status || NO == [status isKindOfClass:[STATUS class]] )
		{
			msg.failed = YES;
			return;
		}

		msg.OUTPUT( @"status", status );
		msg.OUTPUT( @"total", total );

	}
	else if ( msg.failed )
	{
	}
	else if ( msg.cancelled )
	{
	}
}

#pragma mark - POST category

DEF_MESSAGE_( category, msg )
{
	if ( msg.sending )
	{
		NSString * requestURI = [NSString stringWithFormat:@"%@/category", [ServerConfig sharedInstance].url];
		msg.HTTP_POST( requestURI );
	}
	else if ( msg.succeed )
	{
		NSDictionary * response = msg.responseJSONDictionary;
		STATUS * status = [STATUS objectFromDictionary:[response dictAtPath:@"status"]];
		NSArray * data = [TOP_CATEGORY objectsFromArray:[response arrayAtPath:@"data"]];
		
		if ( nil == status || NO == [status isKindOfClass:[STATUS class]] )
		{
			msg.failed = YES;
			return;
		}
		
		msg.OUTPUT( @"status", status );
		msg.OUTPUT( @"data", data );
	}
	else if ( msg.failed )
	{
	}
	else if ( msg.cancelled )
	{
	}
}

#pragma mark - POST comments

DEF_MESSAGE_( comments, msg )
{
	if ( msg.sending )
	{
		NSNumber * goods_id = msg.GET_INPUT( @"goods_id" );
		PAGINATION * pagination = msg.GET_INPUT( @"pagination" );

		if ( nil == goods_id || NO == [goods_id isKindOfClass:[NSNumber class]] )
		{
			msg.failed = YES;
			return;
		}

		NSMutableDictionary * requestBody = [NSMutableDictionary dictionary];
		requestBody.APPEND( @"goods_id", goods_id );
		requestBody.APPEND( @"pagination", pagination );

//		NSString * requestURI = @"http://shop.ecmobile.me/ecmobile/?url=comments";
		NSString * requestURI = [NSString stringWithFormat:@"%@/comments", [ServerConfig sharedInstance].url];
		
		msg.HTTP_POST( requestURI ).PARAM( @"json", requestBody.objectToString );
	}
	else if ( msg.succeed )
	{
		NSDictionary * response = msg.responseJSONDictionary;
		STATUS * status = [STATUS objectFromDictionary:[response dictAtPath:@"status"]];
		NSArray * data = [COMMENT objectsFromArray:[response arrayAtPath:@"data"]];
		PAGINATED * paginated = [PAGINATED objectFromDictionary:[response dictAtPath:@"paginated"]];

		if ( nil == status || NO == [status isKindOfClass:[STATUS class]] )
		{
			msg.failed = YES;
			return;
		}

		msg.OUTPUT( @"status", status );
		msg.OUTPUT( @"data", data );
		msg.OUTPUT( @"paginated", paginated );

	}
	else if ( msg.failed )
	{
	}
	else if ( msg.cancelled )
	{
	}
}

#pragma mark - POST config

DEF_MESSAGE_( config, msg )
{
	if ( msg.sending )
	{
//		NSString * requestURI = @"http://shop.ecmobile.me/ecmobile/?url=config";
		NSString * requestURI = [NSString stringWithFormat:@"%@/config", [ServerConfig sharedInstance].url];
		
		msg.HTTP_POST( requestURI );
	}
	else if ( msg.succeed )
	{
		NSDictionary * response = msg.responseJSONDictionary;
		CONFIG * config = [CONFIG objectFromDictionary:[response dictAtPath:@"data"]];
		STATUS * status = [STATUS objectFromDictionary:[response dictAtPath:@"status"]];

		if ( nil == config || NO == [config isKindOfClass:[CONFIG class]] )
		{
			msg.failed = YES;
			return;
		}
		if ( nil == status || NO == [status isKindOfClass:[STATUS class]] )
		{
			msg.failed = YES;
			return;
		}

		msg.OUTPUT( @"config", config );
		msg.OUTPUT( @"status", status );

	}
	else if ( msg.failed )
	{
	}
	else if ( msg.cancelled )
	{
	}
}

#pragma mark - POST flow/checkOrder

DEF_MESSAGE_( flow_checkOrder, msg )
{
	if ( msg.sending )
	{
		SESSION * session = msg.GET_INPUT( @"session" );

		if ( nil == session || NO == [session isKindOfClass:[SESSION class]] )
		{
			msg.failed = YES;
			return;
		}

		NSMutableDictionary * requestBody = [NSMutableDictionary dictionary];
		requestBody.APPEND( @"session", session );

//		NSString * requestURI = @"http://shop.ecmobile.me/ecmobile/?url=flow/checkOrder";
		NSString * requestURI = [NSString stringWithFormat:@"%@/flow/checkOrder", [ServerConfig sharedInstance].url];
		
		msg.HTTP_POST( requestURI ).PARAM( @"json", requestBody.objectToString );
	}
	else if ( msg.succeed )
	{
		NSDictionary * response = msg.responseJSONDictionary;
		STATUS * status = [STATUS objectFromDictionary:[response dictAtPath:@"status"]];
		NSDictionary * data = [response dictAtPath:@"data"];
        NSArray * data_bonus = [BONUS objectsFromArray:[response arrayAtPath:@"data.bonus"]];
		NSNumber * data_allow_use_bonus = [response numberAtPath:@"data.allow_use_bonus"];
		NSNumber * data_allow_use_integral = [response numberAtPath:@"data.allow_use_integral"];
		ADDRESS * data_consignee = [ADDRESS objectFromDictionary:[response dictAtPath:@"data.consignee"]];
		NSArray * data_goods_list = [CART_GOODS objectsFromArray:[response arrayAtPath:@"data.goods_list"]];
		NSArray * data_inv_content_list = [INVOICE objectsFromArray:[response arrayAtPath:@"data.inv_content_list"]];
		NSArray * data_inv_type_list = [INVOICE objectsFromArray:[response arrayAtPath:@"data.inv_type_list"]];
		NSNumber * data_order_max_integral = [response numberAtPath:@"data.order_max_integral"];
		NSArray * data_payment_list = [PAYMENT objectsFromArray:[response arrayAtPath:@"data.payment_list"]];
		NSArray * data_shipping_list = [SHIPPING objectsFromArray:[response arrayAtPath:@"data.shipping_list"]];
		NSNumber * data_your_integral = [response numberAtPath:@"data.your_integral"];

		if ( nil == status || NO == [status isKindOfClass:[STATUS class]] )
		{
			msg.failed = YES;
			return;
		}

        msg.OUTPUT( @"status", status );
        msg.OUTPUT( @"data", data );
        msg.OUTPUT( @"data_bonus", data_bonus );        
        msg.OUTPUT( @"data_allow_use_bonus", data_allow_use_bonus );
        msg.OUTPUT( @"data_allow_use_integral", data_allow_use_integral );
        msg.OUTPUT( @"data_consignee", data_consignee );
        msg.OUTPUT( @"data_goods_list", data_goods_list );
        msg.OUTPUT( @"data_inv_content_list", data_inv_content_list );
        msg.OUTPUT( @"data_inv_type_list", data_inv_type_list );
        msg.OUTPUT( @"data_order_max_integral", data_order_max_integral );
        msg.OUTPUT( @"data_payment_list", data_payment_list );
        msg.OUTPUT( @"data_shipping_list", data_shipping_list );
        msg.OUTPUT( @"data_your_integral", data_your_integral );

	}
	else if ( msg.failed )
	{
	}
	else if ( msg.cancelled )
	{
	}
}

#pragma mark - POST flow/done

DEF_MESSAGE_( flow_done, msg )
{
	if ( msg.sending )
	{
		NSNumber * pay_id = msg.GET_INPUT( @"pay_id" );
		SESSION * session = msg.GET_INPUT( @"session" );
		NSNumber * shipping_id = msg.GET_INPUT( @"shipping_id" );
		NSNumber * bonus = msg.GET_INPUT( @"bonus" );
		NSNumber * integral = msg.GET_INPUT( @"integral" );
		NSString * inv_content = msg.GET_INPUT( @"inv_content" );
		NSString * inv_payee = msg.GET_INPUT( @"inv_payee" );
		NSNumber * inv_type = msg.GET_INPUT( @"inv_type" );

		if ( nil == pay_id || NO == [pay_id isKindOfClass:[NSNumber class]] )
		{
			msg.failed = YES;
			return;
		}
		if ( nil == session || NO == [session isKindOfClass:[SESSION class]] )
		{
			msg.failed = YES;
			return;
		}
		if ( nil == shipping_id || NO == [shipping_id isKindOfClass:[NSNumber class]] )
		{
			msg.failed = YES;
			return;
		}

		NSMutableDictionary * requestBody = [NSMutableDictionary dictionary];
		requestBody.APPEND( @"pay_id", pay_id );
		requestBody.APPEND( @"session", session );
		requestBody.APPEND( @"shipping_id", shipping_id );
		requestBody.APPEND( @"bonus", bonus );
		requestBody.APPEND( @"integral", integral );
		requestBody.APPEND( @"inv_content", inv_content );
		requestBody.APPEND( @"inv_payee", inv_payee );
		requestBody.APPEND( @"inv_type", inv_type );

//		NSString * requestURI = @"http://shop.ecmobile.me/ecmobile/?url=flow/done";
		NSString * requestURI = [NSString stringWithFormat:@"%@/flow/done", [ServerConfig sharedInstance].url];
		
		msg.HTTP_POST( requestURI ).PARAM( @"json", requestBody.objectToString );
	}
	else if ( msg.succeed )
	{
		NSDictionary * response = msg.responseJSONDictionary;
		STATUS * status = [STATUS objectFromDictionary:[response dictAtPath:@"status"]];
		NSDictionary * data = [response dictAtPath:@"data"];
		NSString * data_order_sn = [response stringAtPath:@"data.order_sn"];
        NSNumber * data_order_id = [response numberAtPath:@"data.order_id"];
		ORDER_INFO * order_info = [ORDER_INFO objectFromDictionary:[response dictAtPath:@"data.order_info"]];

		if ( nil == status || NO == [status isKindOfClass:[STATUS class]] )
		{
			msg.failed = YES;
			return;
		}

		msg.OUTPUT( @"status", status );
		msg.OUTPUT( @"data", data );
        msg.OUTPUT( @"data_order_sn", data_order_sn);
        msg.OUTPUT( @"data_order_id", data_order_id );
		msg.OUTPUT( @"order_info", order_info );
	}
	else if ( msg.failed )
	{
	}
	else if ( msg.cancelled )
	{
	}
}

#pragma mark - POST goods

DEF_MESSAGE_( goods, msg )
{
	if ( msg.sending )
	{
		SESSION * session = msg.GET_INPUT( @"session" );
		NSNumber * goods_id = msg.GET_INPUT( @"goods_id" );

		if ( nil == goods_id || NO == [goods_id isKindOfClass:[NSNumber class]] )
		{
			msg.failed = YES;
			return;
		}

		NSMutableDictionary * requestBody = [NSMutableDictionary dictionary];
		requestBody.APPEND( @"session", session );
		requestBody.APPEND( @"goods_id", goods_id );

//		NSString * requestURI = @"http://shop.ecmobile.me/ecmobile/?url=goods";
		NSString * requestURI = [NSString stringWithFormat:@"%@/goods", [ServerConfig sharedInstance].url];
		
		msg.HTTP_POST( requestURI ).PARAM( @"json", requestBody.objectToString );
	}
	else if ( msg.succeed )
	{
		NSDictionary * response = msg.responseJSONDictionary;
		STATUS * status = [STATUS objectFromDictionary:[response dictAtPath:@"status"]];
		GOODS * data = [GOODS objectFromDictionary:[response dictAtPath:@"data"]];

		if ( nil == status || NO == [status isKindOfClass:[STATUS class]] )
		{
			msg.failed = YES;
			return;
		}

		msg.OUTPUT( @"status", status );
		msg.OUTPUT( @"data", data );

	}
	else if ( msg.failed )
	{
	}
	else if ( msg.cancelled )
	{
	}
}

#pragma mark - POST goods/desc

DEF_MESSAGE_( goods_desc, msg )
{
	if ( msg.sending )
	{
		NSNumber * goods_id = msg.GET_INPUT( @"goods_id" );

		if ( nil == goods_id || NO == [goods_id isKindOfClass:[NSNumber class]] )
		{
			msg.failed = YES;
			return;
		}

		NSMutableDictionary * requestBody = [NSMutableDictionary dictionary];
		requestBody.APPEND( @"goods_id", goods_id );

//		NSString * requestURI = @"http://shop.ecmobile.me/ecmobile/?url=goods/desc";
		NSString * requestURI = [NSString stringWithFormat:@"%@/goods/desc", [ServerConfig sharedInstance].url];
		
		msg.HTTP_POST( requestURI ).PARAM( @"json", requestBody.objectToString );
	}
	else if ( msg.succeed )
	{
		NSDictionary * response = msg.responseJSONDictionary;
		STATUS * status = [STATUS objectFromDictionary:[response dictAtPath:@"status"]];
		NSString * data = [response stringAtPath:@"data"];

		if ( nil == status || NO == [status isKindOfClass:[STATUS class]] )
		{
			msg.failed = YES;
			return;
		}

		msg.OUTPUT( @"status", status );
		msg.OUTPUT( @"data", data );

	}
	else if ( msg.failed )
	{
	}
	else if ( msg.cancelled )
	{
	}
}

#pragma mark - POST home/category

DEF_MESSAGE_( home_category, msg )
{
	if ( msg.sending )
	{
//		NSString * requestURI = @"http://shop.ecmobile.me/ecmobile/?url=home/category";
		NSString * requestURI = [NSString stringWithFormat:@"%@/home/category", [ServerConfig sharedInstance].url];
		
		msg.HTTP_POST( requestURI );
	}
	else if ( msg.succeed )
	{
		NSDictionary * response = msg.responseJSONDictionary;
		STATUS * status = [STATUS objectFromDictionary:[response dictAtPath:@"status"]];
		NSArray * data = [CATEGORY objectsFromArray:[response arrayAtPath:@"data"]];

		if ( nil == status || NO == [status isKindOfClass:[STATUS class]] )
		{
			msg.failed = YES;
			return;
		}

		msg.OUTPUT( @"status", status );
		msg.OUTPUT( @"data", data );
	}
	else if ( msg.failed )
	{
	}
	else if ( msg.cancelled )
	{
	}
}

#pragma mark - POST home/data

DEF_MESSAGE_( home_data, msg )
{
	if ( msg.sending )
	{
//		NSString * requestURI = @"http://shop.ecmobile.me/ecmobile/?url=home/data";
		NSString * requestURI = [NSString stringWithFormat:@"%@/home/data", [ServerConfig sharedInstance].url];
		
		msg.HTTP_POST( requestURI );
	}
	else if ( msg.succeed )
	{
		NSDictionary * response = msg.responseJSONDictionary;
		STATUS * status = [STATUS objectFromDictionary:[response dictAtPath:@"status"]];
		NSDictionary * data = [response dictAtPath:@"data"];
		NSArray * data_player = [BANNER objectsFromArray:[response arrayAtPath:@"data.player"]];
		NSArray * data_promote_goods = [SIMPLE_GOODS objectsFromArray:[response arrayAtPath:@"data.promote_goods"]];
        
		if ( nil == status || NO == [status isKindOfClass:[STATUS class]] )
		{
			msg.failed = YES;
			return;
		}

		msg.OUTPUT( @"status", status );
		msg.OUTPUT( @"data", data );
	msg.OUTPUT( @"data_player", data_player );
	msg.OUTPUT( @"data_promote_goods", data_promote_goods );

	}
	else if ( msg.failed )
	{
	}
	else if ( msg.cancelled )
	{
	}
}

#pragma mark - POST order/affirmReceived

DEF_MESSAGE_( order_affirmReceived, msg )
{
	if ( msg.sending )
	{
		NSNumber * order_id = msg.GET_INPUT( @"order_id" );
		SESSION * session = msg.GET_INPUT( @"session" );

		if ( nil == order_id || NO == [order_id isKindOfClass:[NSNumber class]] )
		{
			msg.failed = YES;
			return;
		}
		if ( nil == session || NO == [session isKindOfClass:[SESSION class]] )
		{
			msg.failed = YES;
			return;
		}

		NSMutableDictionary * requestBody = [NSMutableDictionary dictionary];
		requestBody.APPEND( @"order_id", order_id );
		requestBody.APPEND( @"session", session );

//		NSString * requestURI = @"http://shop.ecmobile.me/ecmobile/?url=order/affirmReceived";
		NSString * requestURI = [NSString stringWithFormat:@"%@/order/affirmReceived", [ServerConfig sharedInstance].url];
		
		msg.HTTP_POST( requestURI ).PARAM( @"json", requestBody.objectToString );
	}
	else if ( msg.succeed )
	{
		NSDictionary * response = msg.responseJSONDictionary;
		STATUS * status = [STATUS objectFromDictionary:[response dictAtPath:@"status"]];

		if ( nil == status || NO == [status isKindOfClass:[STATUS class]] )
		{
			msg.failed = YES;
			return;
		}

		msg.OUTPUT( @"status", status );

	}
	else if ( msg.failed )
	{
	}
	else if ( msg.cancelled )
	{
	}
}

#pragma mark - POST order/cancel

DEF_MESSAGE_( order_cancel, msg )
{
	if ( msg.sending )
	{
		NSNumber * order_id = msg.GET_INPUT( @"order_id" );
		SESSION * session = msg.GET_INPUT( @"session" );

		if ( nil == order_id || NO == [order_id isKindOfClass:[NSNumber class]] )
		{
			msg.failed = YES;
			return;
		}
		if ( nil == session || NO == [session isKindOfClass:[SESSION class]] )
		{
			msg.failed = YES;
			return;
		}

		NSMutableDictionary * requestBody = [NSMutableDictionary dictionary];
		requestBody.APPEND( @"order_id", order_id );
		requestBody.APPEND( @"session", session );

//		NSString * requestURI = @"http://shop.ecmobile.me/ecmobile/?url=order/cancel";
		NSString * requestURI = [NSString stringWithFormat:@"%@order/cancel", [ServerConfig sharedInstance].url];
		
		msg.HTTP_POST( requestURI ).PARAM( @"json", requestBody.objectToString );
	}
	else if ( msg.succeed )
	{
		NSDictionary * response = msg.responseJSONDictionary;
		STATUS * status = [STATUS objectFromDictionary:[response dictAtPath:@"status"]];

		if ( nil == status || NO == [status isKindOfClass:[STATUS class]] )
		{
			msg.failed = YES;
			return;
		}

		msg.OUTPUT( @"status", status );

	}
	else if ( msg.failed )
	{
	}
	else if ( msg.cancelled )
	{
	}
}

#pragma mark - POST order/list

DEF_MESSAGE_( order_list, msg )
{
	if ( msg.sending )
	{
		SESSION * session = msg.GET_INPUT( @"session" );
		NSString * type = msg.GET_INPUT( @"type" );
		PAGINATION * pagination = msg.GET_INPUT( @"pagination" );

		if ( nil == session || NO == [session isKindOfClass:[SESSION class]] )
		{
			msg.failed = YES;
			return;
		}
		if ( nil == type || NO == [type isKindOfClass:[NSString class]] )
		{
			msg.failed = YES;
			return;
		}

		NSMutableDictionary * requestBody = [NSMutableDictionary dictionary];
		requestBody.APPEND( @"session", session );
		requestBody.APPEND( @"type", type );
		requestBody.APPEND( @"pagination", pagination );

//		NSString * requestURI = @"http://shop.ecmobile.me/ecmobile/?url=order/list";
		NSString * requestURI = [NSString stringWithFormat:@"%@/order/list", [ServerConfig sharedInstance].url];
		
		msg.HTTP_POST( requestURI ).PARAM( @"json", requestBody.objectToString );
	}
	else if ( msg.succeed )
	{
		NSDictionary * response = msg.responseJSONDictionary;
		PAGINATED * paginated = [PAGINATED objectFromDictionary:[response dictAtPath:@"paginated"]];
		STATUS * status = [STATUS objectFromDictionary:[response dictAtPath:@"status"]];
		NSArray * data = [ORDER objectsFromArray:[response arrayAtPath:@"data"]];

		if ( nil == paginated || NO == [paginated isKindOfClass:[PAGINATED class]] )
		{
			msg.failed = YES;
			return;
		}
		if ( nil == status || NO == [status isKindOfClass:[STATUS class]] )
		{
			msg.failed = YES;
			return;
		}

		msg.OUTPUT( @"paginated", paginated );
		msg.OUTPUT( @"status", status );
		msg.OUTPUT( @"data", data );

	}
	else if ( msg.failed )
	{
	}
	else if ( msg.cancelled )
	{
	}
}

#pragma mark - POST order/pay

DEF_MESSAGE_( order_pay, msg )
{
	if ( msg.sending )
	{
		NSNumber * order_id = msg.GET_INPUT( @"order_id" );
		SESSION * session 	= msg.GET_INPUT( @"session" );

		if ( nil == order_id || NO == [order_id isKindOfClass:[NSNumber class]] )
		{
			msg.failed = YES;
			return;
		}
		if ( nil == session || NO == [session isKindOfClass:[SESSION class]] )
		{
			msg.failed = YES;
			return;
		}

		NSMutableDictionary * requestBody = [NSMutableDictionary dictionary];

		requestBody.APPEND( @"order_id", order_id );
		requestBody.APPEND( @"session", session );

		NSString * requestURI = [NSString stringWithFormat:@"%@/order/pay", [ServerConfig sharedInstance].url];

		msg.HTTP_POST( requestURI ).PARAM( @"json", requestBody.objectToString );
	}
	else if ( msg.succeed )
	{
		NSDictionary * response = msg.responseJSONDictionary;

		STATUS * status 	 = [STATUS objectFromDictionary:[response dictAtPath:@"status"]];
        NSDictionary * data  = [response dictAtPath:@"data"];
		NSString * paywap 	 = [data stringAtPath:@"pay_wap"];
		NSString * upoptn 	 = [data stringAtPath:@"upop_tn"];
		NSString * payonline = [data stringAtPath:@"pay_online"];

		if ( nil == status || NO == [status isKindOfClass:[STATUS class]] )
		{
			msg.failed = YES;
			return;
		}

		msg.OUTPUT( @"status", status );
		msg.OUTPUT( @"data", data );
		msg.OUTPUT( @"pay_wap", paywap );
		msg.OUTPUT( @"upop_tn", upoptn );
		msg.OUTPUT( @"pay_online", payonline );

	}
	else if ( msg.failed )
	{
	}
	else if ( msg.cancelled )
	{
	}
}

#pragma mark - POST order/express

DEF_MESSAGE_( order_express, msg )
{
	if ( msg.sending )
	{
		NSNumber * order_id = msg.GET_INPUT( @"order_id" );
		NSString * app_key = msg.GET_INPUT( @"app_key" );
		SESSION * session = msg.GET_INPUT( @"session" );
        
        
		NSMutableDictionary * requestBody = [NSMutableDictionary dictionary];
		requestBody.APPEND( @"order_id", order_id );
		requestBody.APPEND( @"session", session );
		requestBody.APPEND( @"app_key", app_key );
        
//		NSString * requestURI = @"http://shop.ecmobile.me/ecmobile/?url=order/express";
		NSString * requestURI = [NSString stringWithFormat:@"%@/order/express", [ServerConfig sharedInstance].url];
		
		msg.HTTP_POST( requestURI ).PARAM( @"json", requestBody.objectToString );
	}
	else if ( msg.succeed )
	{
        // TDDO remove this test data;
		NSDictionary * response = msg.responseJSONDictionary;
//        NSString * s = @"{\"data\": {\"content\": [{\"time\": \"2014-01-19 18:24:00\",\"context\": \"快件已【签收】,签收人是【草签】,签收网点【河北唐山公司】\"},{\"time\": \"2014-01-19 18:12:10\",\"context\": \"快件已到达【河北唐山公司】，上一站是： 【】 扫描员是： 【王柏灵】\"},{\"time\": \"2014-01-18 18:25:55\",\"context\": \"【河北唐山公司】 已进行疑难件扫描，,疑难件原因 送无人,电话联系不上明日送，扫描员是： 【王柏灵】\"},{\"time\": \"2014-01-17 15:08:54\",\"context\": \"【河北唐山公司】 的派件员 【发往燕新路】 正在派件，扫描员是： 【陈艳】\"},{\"time\": \"2014-01-17 15:07:34\",\"context\": \"快件已到达【河北唐山公司】，上一站是： 【】 扫描员是： 【朱东芝】\"},{\"time\": \"2014-01-16 11:52:17\",\"context\": \"快件在 【北京中转部】 由 【网二扫描74】 扫描发往 【河北唐山公司】\"},{\"time\": \"2014-01-14 23:53:18\",\"context\": \"快件在 【上海航空部】 由 【郑刚强】 扫描发往 【河北唐山航空部】\"},{\"time\": \"2014-01-14 21:01:47\",\"context\": \"【上海松江公司】 已做装袋扫描，袋号： 900168437681，单号：768089232106\"},{\"time\": \"2014-01-14 21:01:47\",\"context\": \"快件在 【上海松江公司】 由 【航空2E】 扫描发往 【上海航空部】\"},{\"time\": \"2014-01-14 20:37:15\",\"context\": \"【上海松江公司】 的收件员 【茸北A线】已收件，扫描员是： 【3松江小件】\"}],\"shipping_name\": \"申通快递\"},\"status\": {\"succeed\": 1}}" ;
//        NSDictionary * response = [s objectFromJSONString];
		NSDictionary * data = [response dictAtPath:@"data"];
		NSArray * data_content = [EXPRESS objectsFromArray:[response arrayAtPath:@"data.content"]];
		NSString * data_shipping_name = [response stringAtPath:@"data.shipping_name"];
		STATUS * status = [STATUS objectFromDictionary:[response dictAtPath:@"status"]];
        
		msg.OUTPUT( @"data", data );
        msg.OUTPUT( @"data_content", data_content );
        msg.OUTPUT( @"data_shipping_name", data_shipping_name );
		msg.OUTPUT( @"status", status );
        
	}
	else if ( msg.failed )
	{
	}
	else if ( msg.cancelled )
	{
	}
}

#pragma mark - POST region

DEF_MESSAGE_( region, msg )
{
	if ( msg.sending )
	{
		NSNumber * parent_id = msg.GET_INPUT( @"parent_id" );

		if ( nil == parent_id || NO == [parent_id isKindOfClass:[NSNumber class]] )
		{
			msg.failed = YES;
			return;
		}

		NSMutableDictionary * requestBody = [NSMutableDictionary dictionary];
		requestBody.APPEND( @"parent_id", parent_id );

//		NSString * requestURI = @"http://shop.ecmobile.me/ecmobile/?url=region";
		NSString * requestURI = [NSString stringWithFormat:@"%@/region", [ServerConfig sharedInstance].url];
		
		msg.HTTP_POST( requestURI ).PARAM( @"json", requestBody.objectToString );
	}
	else if ( msg.succeed )
	{
		NSDictionary * response = msg.responseJSONDictionary;
		STATUS * status = [STATUS objectFromDictionary:[response dictAtPath:@"status"]];
		NSArray * data = [REGION objectsFromArray:[response arrayAtPath:@"data.regions"]];

		if ( nil == status || NO == [status isKindOfClass:[STATUS class]] )
		{
			msg.failed = YES;
			return;
		}

		msg.OUTPUT( @"status", status );
		msg.OUTPUT( @"data", data );

	}
	else if ( msg.failed )
	{
	}
	else if ( msg.cancelled )
	{
	}
}

#pragma mark - POST search

DEF_MESSAGE_( search, msg )
{
	if ( msg.sending )
	{
		FILTER * filter = msg.GET_INPUT( @"filter" );
		PAGINATION * pagination = msg.GET_INPUT( @"pagination" );

		if ( nil == filter || NO == [filter isKindOfClass:[FILTER class]] )
		{
			msg.failed = YES;
			return;
		}

		NSMutableDictionary * requestBody = [NSMutableDictionary dictionary];
		
		requestBody.APPEND( @"filter", filter );
		requestBody.APPEND( @"pagination", pagination );

//		NSString * requestURI = @"http://shop.ecmobile.me/ecmobile/?url=search";
		NSString * requestURI = [NSString stringWithFormat:@"%@/search", [ServerConfig sharedInstance].url];
		
		msg.HTTP_POST( requestURI ).PARAM( @"json", requestBody.objectToString );
	}
	else if ( msg.succeed )
	{
		NSDictionary * response = msg.responseJSONDictionary;
		STATUS * status = [STATUS objectFromDictionary:[response dictAtPath:@"status"]];
		NSArray * data = [SIMPLE_GOODS objectsFromArray:[response arrayAtPath:@"data"]];
		PAGINATED * paginated = [PAGINATED objectFromDictionary:[response dictAtPath:@"paginated"]];

		if ( nil == status || NO == [status isKindOfClass:[STATUS class]] )
		{
			msg.failed = YES;
			return;
		}

		msg.OUTPUT( @"status", status );
		msg.OUTPUT( @"data", data );
		msg.OUTPUT( @"paginated", paginated );

	}
	else if ( msg.failed )
	{
	}
	else if ( msg.cancelled )
	{
	}
}

#pragma mark - POST searchKeywords

DEF_MESSAGE_( searchKeywords, msg )
{
	if ( msg.sending )
	{
//		NSString * requestURI = @"http://shop.ecmobile.me/ecmobile/?url=searchKeywords";
		NSString * requestURI = [NSString stringWithFormat:@"%@/searchKeywords", [ServerConfig sharedInstance].url];
		
		msg.HTTP_POST( requestURI );
	}
	else if ( msg.succeed )
	{
		NSDictionary * response = msg.responseJSONDictionary;
		STATUS * status = [STATUS objectFromDictionary:[response dictAtPath:@"status"]];
		NSArray * data = [response arrayAtPath:@"data"];

		if ( nil == status || NO == [status isKindOfClass:[STATUS class]] )
		{
			msg.failed = YES;
			return;
		}

		msg.OUTPUT( @"status", status );
		msg.OUTPUT( @"data", data );

	}
	else if ( msg.failed )
	{
	}
	else if ( msg.cancelled )
	{
	}
}

#pragma mark - POST shopHelp

DEF_MESSAGE_( shopHelp, msg )
{
	if ( msg.sending )
	{
//		NSString * requestURI = @"http://shop.ecmobile.me/ecmobile/?url=shopHelp";
		NSString * requestURI = [NSString stringWithFormat:@"%@/shopHelp", [ServerConfig sharedInstance].url];
		
		msg.HTTP_POST( requestURI );
	}
	else if ( msg.succeed )
	{
		NSDictionary * response = msg.responseJSONDictionary;
		STATUS * status = [STATUS objectFromDictionary:[response dictAtPath:@"status"]];
		NSArray * data = [ARTICLE_GROUP objectsFromArray:[response arrayAtPath:@"data"]];

		if ( nil == status || NO == [status isKindOfClass:[STATUS class]] )
		{
			msg.failed = YES;
			return;
		}

		msg.OUTPUT( @"status", status );
		msg.OUTPUT( @"data", data );

	}
	else if ( msg.failed )
	{
	}
	else if ( msg.cancelled )
	{
	}
}

#pragma mark - POST user/collect/create

DEF_MESSAGE_( user_collect_create, msg )
{
	if ( msg.sending )
	{
		NSNumber * goods_id = msg.GET_INPUT( @"goods_id" );
		SESSION * session = msg.GET_INPUT( @"session" );

		if ( nil == goods_id || NO == [goods_id isKindOfClass:[NSNumber class]] )
		{
			msg.failed = YES;
			return;
		}
		if ( nil == session || NO == [session isKindOfClass:[SESSION class]] )
		{
			msg.failed = YES;
			return;
		}

		NSMutableDictionary * requestBody = [NSMutableDictionary dictionary];
		requestBody.APPEND( @"goods_id", goods_id );
		requestBody.APPEND( @"session", session );

//		NSString * requestURI = @"http://shop.ecmobile.me/ecmobile/?url=user/collect/create";
		NSString * requestURI = [NSString stringWithFormat:@"%@/user/collect/create", [ServerConfig sharedInstance].url];
		
		msg.HTTP_POST( requestURI ).PARAM( @"json", requestBody.objectToString );
	}
	else if ( msg.succeed )
	{
		NSDictionary * response = msg.responseJSONDictionary;
		STATUS * status = [STATUS objectFromDictionary:[response dictAtPath:@"status"]];
		NSDictionary * data = [response dictAtPath:@"data"];

		if ( nil == status || NO == [status isKindOfClass:[STATUS class]] )
		{
			msg.failed = YES;
			return;
		}

		msg.OUTPUT( @"status", status );
		msg.OUTPUT( @"data", data );

	}
	else if ( msg.failed )
	{
	}
	else if ( msg.cancelled )
	{
	}
}

#pragma mark - POST user/collect/delete

DEF_MESSAGE_( user_collect_delete, msg )
{
	if ( msg.sending )
	{
		NSNumber * rec_id = msg.GET_INPUT( @"rec_id" );
		SESSION * session = msg.GET_INPUT( @"session" );

		if ( nil == rec_id || NO == [rec_id isKindOfClass:[NSNumber class]] )
		{
			msg.failed = YES;
			return;
		}
		if ( nil == session || NO == [session isKindOfClass:[SESSION class]] )
		{
			msg.failed = YES;
			return;
		}

		NSMutableDictionary * requestBody = [NSMutableDictionary dictionary];
		requestBody.APPEND( @"rec_id", rec_id );
		requestBody.APPEND( @"session", session );

//		NSString * requestURI = @"http://shop.ecmobile.me/ecmobile/?url=user/collect/delete";
		NSString * requestURI = [NSString stringWithFormat:@"%@/user/collect/delete", [ServerConfig sharedInstance].url];
		
		msg.HTTP_POST( requestURI ).PARAM( @"json", requestBody.objectToString );
	}
	else if ( msg.succeed )
	{
		NSDictionary * response = msg.responseJSONDictionary;
		STATUS * status = [STATUS objectFromDictionary:[response dictAtPath:@"status"]];
		NSDictionary * data = [response dictAtPath:@"data"];

		if ( nil == status || NO == [status isKindOfClass:[STATUS class]] )
		{
			msg.failed = YES;
			return;
		}

		msg.OUTPUT( @"status", status );
		msg.OUTPUT( @"data", data );

	}
	else if ( msg.failed )
	{
	}
	else if ( msg.cancelled )
	{
	}
}

#pragma mark - POST user/collect/list

DEF_MESSAGE_( user_collect_list, msg )
{
	if ( msg.sending )
	{
		SESSION * session = msg.GET_INPUT( @"session" );
		PAGINATION * pagination = msg.GET_INPUT( @"pagination" );

		if ( nil == session || NO == [session isKindOfClass:[SESSION class]] )
		{
			msg.failed = YES;
			return;
		}

		NSMutableDictionary * requestBody = [NSMutableDictionary dictionary];
		requestBody.APPEND( @"session", session );
		requestBody.APPEND( @"pagination", pagination );

//		NSString * requestURI = @"http://shop.ecmobile.me/ecmobile/?url=user/collect/list";
		NSString * requestURI = [NSString stringWithFormat:@"%@/user/collect/list", [ServerConfig sharedInstance].url];
		
		msg.HTTP_POST( requestURI ).PARAM( @"json", requestBody.objectToString );
	}
	else if ( msg.succeed )
	{
		NSDictionary * response = msg.responseJSONDictionary;
		STATUS * status = [STATUS objectFromDictionary:[response dictAtPath:@"status"]];
		NSArray * data = [COLLECT_GOODS objectsFromArray:[response arrayAtPath:@"data"]];
		PAGINATED * paginated = [PAGINATED objectFromDictionary:[response dictAtPath:@"paginated"]];

		if ( nil == status || NO == [status isKindOfClass:[STATUS class]] )
		{
			msg.failed = YES;
			return;
		}

		msg.OUTPUT( @"status", status );
		msg.OUTPUT( @"data", data );
		msg.OUTPUT( @"paginated", paginated );

	}
	else if ( msg.failed )
	{
	}
	else if ( msg.cancelled )
	{
	}
}

#pragma mark - POST user/info

DEF_MESSAGE_( user_info, msg )
{
	if ( msg.sending )
	{
		SESSION * session = msg.GET_INPUT( @"session" );

		if ( nil == session || NO == [session isKindOfClass:[SESSION class]] )
		{
			msg.failed = YES;
			return;
		}

		NSMutableDictionary * requestBody = [NSMutableDictionary dictionary];
		requestBody.APPEND( @"session", session );

//		NSString * requestURI = @"http://shop.ecmobile.me/ecmobile/?url=user/info";
		NSString * requestURI = [NSString stringWithFormat:@"%@/user/info", [ServerConfig sharedInstance].url];
		
		msg.HTTP_POST( requestURI ).PARAM( @"json", requestBody.objectToString );
	}
	else if ( msg.succeed )
	{
		NSDictionary * response = msg.responseJSONDictionary;
		STATUS * status = [STATUS objectFromDictionary:[response dictAtPath:@"status"]];
		USER * data = [USER objectFromDictionary:[response dictAtPath:@"data"]];

		if ( nil == status || NO == [status isKindOfClass:[STATUS class]] )
		{
			msg.failed = YES;
			return;
		}

		msg.OUTPUT( @"status", status );
		msg.OUTPUT( @"data", data );

	}
	else if ( msg.failed )
	{
	}
	else if ( msg.cancelled )
	{
	}
}

#pragma mark - POST user/signin

DEF_MESSAGE_( user_signin, msg )
{
	if ( msg.sending )
	{
		NSString * name = msg.GET_INPUT( @"name" );
		NSString * password = msg.GET_INPUT( @"password" );

		if ( nil == name || NO == [name isKindOfClass:[NSString class]] )
		{
			msg.failed = YES;
			return;
		}
		if ( nil == password || NO == [password isKindOfClass:[NSString class]] )
		{
			msg.failed = YES;
			return;
		}

		NSMutableDictionary * requestBody = [NSMutableDictionary dictionary];
		requestBody.APPEND( @"name", name );
		requestBody.APPEND( @"password", password );

//		NSString * requestURI = @"http://shop.ecmobile.me/ecmobile/?url=user/signin";
		NSString * requestURI = [NSString stringWithFormat:@"%@/user/signin", [ServerConfig sharedInstance].url];
		
		msg.HTTP_POST( requestURI ).PARAM( @"json", requestBody.objectToString );
	}
	else if ( msg.succeed )
	{
		NSDictionary * response = msg.responseJSONDictionary;
		STATUS * status = [STATUS objectFromDictionary:[response dictAtPath:@"status"]];
		NSDictionary * data = [response dictAtPath:@"data"];
		SESSION * data_session = [SESSION objectFromDictionary:[response dictAtPath:@"data.session"]];
		USER * data_user = [USER objectFromDictionary:[response dictAtPath:@"data.user"]];

		if ( nil == status || NO == [status isKindOfClass:[STATUS class]] )
		{
			msg.failed = YES;
			return;
		}

		msg.OUTPUT( @"status", status );
		msg.OUTPUT( @"data", data );
		msg.OUTPUT( @"data_session", data_session );
		msg.OUTPUT( @"data_user", data_user );

	}
	else if ( msg.failed )
	{
	}
	else if ( msg.cancelled )
	{
	}
}

#pragma mark - POST user/signup

DEF_MESSAGE_( user_signup, msg )
{
	if ( msg.sending )
	{
		NSString * email = msg.GET_INPUT( @"email" );
		NSString * name = msg.GET_INPUT( @"name" );
		NSString * password = msg.GET_INPUT( @"password" );
		NSArray * field = msg.GET_INPUT( @"field" );

		if ( nil == email || NO == [email isKindOfClass:[NSString class]] )
		{
			msg.failed = YES;
			return;
		}
		if ( nil == name || NO == [name isKindOfClass:[NSString class]] )
		{
			msg.failed = YES;
			return;
		}
		if ( nil == password || NO == [password isKindOfClass:[NSString class]] )
		{
			msg.failed = YES;
			return;
		}

		NSMutableDictionary * requestBody = [NSMutableDictionary dictionary];
		requestBody.APPEND( @"email", email );
		requestBody.APPEND( @"name", name );
		requestBody.APPEND( @"password", password );
		requestBody.APPEND( @"field", field );

//		NSString * requestURI = @"http://shop.ecmobile.me/ecmobile/?url=user/signup";
		NSString * requestURI = [NSString stringWithFormat:@"%@/user/signup", [ServerConfig sharedInstance].url];
		
		msg.HTTP_POST( requestURI ).PARAM( @"json", requestBody.objectToString );
	}
	else if ( msg.succeed )
	{
		NSDictionary * response = msg.responseJSONDictionary;
		SESSION * session = [SESSION objectFromDictionary:[response dictAtPath:@"data.session"]];
		STATUS * status = [STATUS objectFromDictionary:[response dictAtPath:@"status"]];
		USER * user = [USER objectFromDictionary:[response dictAtPath:@"data.user"]];

		INFO( status.error_desc );
		
		if ( nil == session || NO == [session isKindOfClass:[SESSION class]] )
		{
			msg.failed = YES;
			return;
		}
		if ( nil == status || NO == [status isKindOfClass:[STATUS class]] )
		{
			msg.failed = YES;
			return;
		}
		if ( nil == user || NO == [user isKindOfClass:[USER class]] )
		{
			msg.failed = YES;
			return;
		}

		msg.OUTPUT( @"data_session", session );
		msg.OUTPUT( @"data_status", status );
		msg.OUTPUT( @"data_user", user );
		

	}
	else if ( msg.failed )
	{
	}
	else if ( msg.cancelled )
	{
	}
}

#pragma mark - POST user/signupFields

DEF_MESSAGE_( user_signupFields, msg )
{
	if ( msg.sending )
	{
//		NSString * requestURI = @"http://shop.ecmobile.me/ecmobile/?url=user/signupFields";
		NSString * requestURI = [NSString stringWithFormat:@"%@/user/signupFields", [ServerConfig sharedInstance].url];
		
		msg.HTTP_POST( requestURI );
	}
	else if ( msg.succeed )
	{
		NSDictionary * response = msg.responseJSONDictionary;
		STATUS * status = [STATUS objectFromDictionary:[response dictAtPath:@"status"]];
		NSArray * data = [SIGNUP_FIELD objectsFromArray:[response arrayAtPath:@"data"]];

		if ( nil == status || NO == [status isKindOfClass:[STATUS class]] )
		{
			msg.failed = YES;
			return;
		}

		msg.OUTPUT( @"status", status );
		msg.OUTPUT( @"data", data );

	}
	else if ( msg.failed )
	{
	}
	else if ( msg.cancelled )
	{
	}
}

#pragma mark - POST validate/bonus

DEF_MESSAGE_( validate_bonus, msg )
{
	if ( msg.sending )
	{
		NSString * bonus_sn = msg.GET_INPUT( @"bonus_sn" );
		SESSION * session = msg.GET_INPUT( @"session" );

		if ( nil == bonus_sn || NO == [bonus_sn isKindOfClass:[NSString class]] )
		{
			msg.failed = YES;
			return;
		}
		if ( nil == session || NO == [session isKindOfClass:[SESSION class]] )
		{
			msg.failed = YES;
			return;
		}

		NSMutableDictionary * requestBody = [NSMutableDictionary dictionary];
		requestBody.APPEND( @"bonus_sn", bonus_sn );
		requestBody.APPEND( @"session", session );

//		NSString * requestURI = @"http://shop.ecmobile.me/ecmobile/?url=validate/bonus";
		NSString * requestURI = [NSString stringWithFormat:@"%@/validate/bonus", [ServerConfig sharedInstance].url];
		
		msg.HTTP_POST( requestURI ).PARAM( @"json", requestBody.objectToString );
	}
	else if ( msg.succeed )
	{
		NSDictionary * response = msg.responseJSONDictionary;
		STATUS * status = [STATUS objectFromDictionary:[response dictAtPath:@"status"]];
		NSDictionary * data = [response dictAtPath:@"data"];
		NSString * data_bonus_formated = [response stringAtPath:@"data.bonus_formated"];
		NSString * data_bonus = [response stringAtPath:@"data.bonus"];

		if ( nil == status || NO == [status isKindOfClass:[STATUS class]] )
		{
			msg.failed = YES;
			return;
		}

		msg.OUTPUT( @"status", status );
		msg.OUTPUT( @"data", data );
        msg.OUTPUT( @"data_bonus_formated", data_bonus_formated );
        msg.OUTPUT( @"data_bonus", data_bonus );

	}
	else if ( msg.failed )
	{
	}
	else if ( msg.cancelled )
	{
	}
}

#pragma mark - POST validate/integral

DEF_MESSAGE_( validate_integral, msg )
{
	if ( msg.sending )
	{
		NSNumber * integral = msg.GET_INPUT( @"integral" );
		SESSION * session = msg.GET_INPUT( @"session" );

		if ( nil == integral || NO == [integral isKindOfClass:[NSNumber class]] )
		{
			msg.failed = YES;
			return;
		}
		if ( nil == session || NO == [session isKindOfClass:[SESSION class]] )
		{
			msg.failed = YES;
			return;
		}

		NSMutableDictionary * requestBody = [NSMutableDictionary dictionary];
		requestBody.APPEND( @"integral", integral );
		requestBody.APPEND( @"session", session );

//		NSString * requestURI = @"http://shop.ecmobile.me/ecmobile/?url=validate/integral";
		NSString * requestURI = [NSString stringWithFormat:@"%@/validate/integral", [ServerConfig sharedInstance].url];
		
		msg.HTTP_POST( requestURI ).PARAM( @"json", requestBody.objectToString );
	}
	else if ( msg.succeed )
	{
		NSDictionary * response = msg.responseJSONDictionary;
		STATUS * status = [STATUS objectFromDictionary:[response dictAtPath:@"status"]];
		NSDictionary * data = [response dictAtPath:@"data"];
		NSString * data_bonus_formated = [response stringAtPath:@"data.bonus_formated"];
		NSNumber * data_bonus = [response numberAtPath:@"data.bonus"];

		if ( nil == status || NO == [status isKindOfClass:[STATUS class]] )
		{
			msg.failed = YES;
			return;
		}

		msg.OUTPUT( @"status", status );
		msg.OUTPUT( @"data", data );
	msg.OUTPUT( @"data_bonus_formated", data_bonus_formated );
	msg.OUTPUT( @"data_bonus", data_bonus );

	}
	else if ( msg.failed )
	{
	}
	else if ( msg.cancelled )
	{
	}
}

#pragma mark - POST brand

DEF_MESSAGE_( brand, msg )
{
	if ( msg.sending )
	{
//		NSString * requestURI = @"http://shop.ecmobile.me/ecmobile/?url=brand";
		NSString * requestURI = [NSString stringWithFormat:@"%@/brand", [ServerConfig sharedInstance].url];

		NSMutableDictionary * requestBody = [NSMutableDictionary dictionary];
		requestBody.APPEND( @"category_id", msg.GET_INPUT( @"category_id" ) );
        
        NSNumber * category_id = msg.GET_INPUT( @"category_id" );
        
        if ( nil != category_id || NO != [category_id isKindOfClass:[NSNumber class]] )
		{
            requestBody.APPEND( @"category_id", category_id );
            msg.HTTP_POST( requestURI ).PARAM( @"json", requestBody.objectToString );
		}
        else
        {
            msg.HTTP_POST( requestURI );
        }
	}
	else if ( msg.succeed )
	{
		NSDictionary * response = msg.responseJSONDictionary;
		STATUS * status = [STATUS objectFromDictionary:[response dictAtPath:@"status"]];
        NSArray * data = [BRAND objectsFromArray:[response arrayAtPath:@"data"]];
        
		if ( nil == status || NO == [status isKindOfClass:[STATUS class]] )
		{
			msg.failed = YES;
			return;
		}

		msg.OUTPUT( @"status", status );
		msg.OUTPUT( @"data", data );
	}
	else if ( msg.failed )
	{
	}
	else if ( msg.cancelled )
	{
	}
}

#pragma mark - POST price_range

DEF_MESSAGE_( price_range, msg )
{
	if ( msg.sending )
	{
		NSString * requestURI = [NSString stringWithFormat:@"%@/price_range", [ServerConfig sharedInstance].url];
		
		NSMutableDictionary * requestBody = [NSMutableDictionary dictionary];
		requestBody.APPEND( @"category_id", msg.GET_INPUT( @"category_id" ) );
        
        NSNumber * category_id = msg.GET_INPUT( @"category_id" );
        
        if ( nil != category_id || NO != [category_id isKindOfClass:[NSNumber class]] )
		{
            requestBody.APPEND( @"category_id", category_id );
            msg.HTTP_POST( requestURI ).PARAM( @"json", requestBody.objectToString );
		}
        else
        {
            msg.HTTP_POST( requestURI );
        }
	}
	else if ( msg.succeed )
	{
		NSDictionary * response = msg.responseJSONDictionary;
		STATUS * status = [STATUS objectFromDictionary:[response dictAtPath:@"status"]];
		NSArray * data = [PRICE_RANGE objectsFromArray:[response arrayAtPath:@"data"]];
        
		if ( nil == status || NO == [status isKindOfClass:[STATUS class]] )
		{
			msg.failed = YES;
			return;
		}
        
		msg.OUTPUT( @"status", status );
		msg.OUTPUT( @"data", data );
	}
	else if ( msg.failed )
	{
	}
	else if ( msg.cancelled )
	{
	}
}

@end


#pragma mark - config

@implementation ServerConfig

DEF_SINGLETON( ServerConfig )

@synthesize url = _url;

@end
