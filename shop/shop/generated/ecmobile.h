//
// ECMobile (Geek-Zoo Studio)
//
// generated at 2013-06-17 05:47:47 +0000
//

#import "Bee.h"

#pragma mark - enums

enum ATTR_TYPE
{
	ATTR_TYPE_UNIQUE = 0,
	ATTR_TYPE_SINGLE = 1,
	ATTR_TYPE_MULTI = 2,
};

enum ERROR_CODE
{
	ERROR_CODE_OK = 0,
};

enum GOOD_TYPE
{
	GOOD_TYPE_NORMAL = 0,
	GOOD_TYPE_GROUP = 1,
	GOOD_TYPE_AUCTION = 2,
	GOOD_TYPE_RAIDERS = 3,
};

enum RANK_LEVEL
{
	RANK_LEVEL_NORMAL = 0,
	RANK_LEVEL_VIP = 1,
};

#define ORDER_LIST_FINISHED	@"finished"
#define ORDER_LIST_SHIPPED	@"shipped"
#define ORDER_LIST_AWAIT_PAY	@"await_pay"
#define ORDER_LIST_AWAIT_SHIP	@"await_ship"

#define SEARCH_ORDER_BY_CHEAPEST	@"price_asc"
#define SEARCH_ORDER_BY_HOT	@"is_hot"
#define SEARCH_ORDER_BY_EXPENSIVE	@"price_desc"

#define BANNER_ACTION_GOODS	@"goods"
#define BANNER_ACTION_CATEGORY @"category"
#define BANNER_ACTION_BRAND	@"brand"

#pragma mark - models

@class ADDRESS;
@class ARTICLE;
@class ARTICLE_GROUP;
@class BANNER;
@class BONUS;
@class BRAND;
@class CART_GOODS;
@class CATEGORY;
@class COMMENT;
@class CONFIG;
@class EXPRESS;
@class FILTER;
@class GOODS;
@class GOOD_ATTR;
@class GOOD_RANK_PRICE;
@class GOOD_SPEC;
@class GOOD_VALUE;
@class INVOICE;
@class ORDER;
@class ORDER_GOODS;
@class PAGINATED;
@class PAGINATION;
@class PAYMENT;
@class PHOTO;
@class PRICE_RANGE;
@class REGION;
@class SESSION;
@class SHIPPING;
@class SIGNUP_FIELD;
@class SIGNUP_FIELD_VALUE;
@class SIMPLE_GOODS;
@class STATUS;
@class TOTAL;
@class USER;
@class COLLECT_GOODS;

@interface ADDRESS : NSObject
@property (nonatomic, retain) NSNumber *		id;
@property (nonatomic, retain) NSString *		address;
@property (nonatomic, retain) NSString *		best_time;
@property (nonatomic, retain) NSNumber *		city;
@property (nonatomic, retain) NSNumber *		country;
@property (nonatomic, retain) NSNumber *		default_address;
@property (nonatomic, retain) NSNumber *		district;
@property (nonatomic, retain) NSString *		email;
@property (nonatomic, retain) NSString *		mobile;
@property (nonatomic, retain) NSString *		name;
@property (nonatomic, retain) NSNumber *		province;
@property (nonatomic, retain) NSString *		sign_building;
@property (nonatomic, retain) NSString *		tel;
@property (nonatomic, retain) NSString *		zipcode;
@property (nonatomic, retain) NSString *		country_name;
@property (nonatomic, retain) NSString *		province_name;
@property (nonatomic, retain) NSString *		city_name;
@property (nonatomic, retain) NSString *		district_name;
@property (nonatomic, retain) NSString *        consignee;
@end

@interface ARTICLE : NSObject
@property (nonatomic, retain) NSString *		short_title;
@property (nonatomic, retain) NSString *		title;
@property (nonatomic, retain) NSNumber *		id;
@end

@interface ARTICLE_GROUP : NSObject
@property (nonatomic, retain) NSArray *		article;
@property (nonatomic, retain) NSString *		name;
@end

@interface BANNER : NSObject
@property (nonatomic, retain) NSString *		action;
@property (nonatomic, retain) NSNumber *		action_id;
@property (nonatomic, retain) NSString *		description;
@property (nonatomic, retain) PHOTO *		photo;
@property (nonatomic, retain) NSString *		url;
@end

@interface BONUS : NSObject
@property (nonatomic, retain) NSNumber * type_id;
@property (nonatomic, retain) NSString * type_name;
@property (nonatomic, retain) NSNumber * type_money;
@property (nonatomic, retain) NSString * bonus_id;
@property (nonatomic, retain) NSString * bonus_money_formated;
@end

@interface BRAND : NSObject
@property (nonatomic, retain) NSString *		url;
@property (nonatomic, retain) NSNumber *		brand_id;
@property (nonatomic, retain) NSString *		brand_name;
@end

@interface CART_GOODS : NSObject
@property (nonatomic, retain) NSNumber *		can_handsel;
@property (nonatomic, retain) NSString *		extension_code;
@property (nonatomic, retain) NSString *		formated_goods_price;
@property (nonatomic, retain) NSString *		formated_market_price;
@property (nonatomic, retain) NSString *		formated_subtotal;
@property (nonatomic, retain) NSArray *		goods_attr;
@property (nonatomic, retain) NSNumber *		goods_attr_id;
@property (nonatomic, retain) NSNumber *		goods_id;
@property (nonatomic, retain) NSString *		goods_name;
@property (nonatomic, retain) NSString *		goods_number;
@property (nonatomic, retain) NSString *		goods_price;
@property (nonatomic, retain) NSString *		goods_sn;
@property (nonatomic, retain) PHOTO *		img;
@property (nonatomic, retain) NSNumber *		is_gift;
@property (nonatomic, retain) NSNumber *		is_real;
@property (nonatomic, retain) NSNumber *		is_shipping;
@property (nonatomic, retain) NSString *		market_price;
@property (nonatomic, retain) NSNumber *		parent_id;
@property (nonatomic, retain) NSString *		pid;
@property (nonatomic, retain) NSNumber *		rec_type;
@property (nonatomic, retain) NSString *		subtotal;
@property (nonatomic, retain) NSNumber *		rec_id;
@end

@interface CATEGORY : NSObject
@property (nonatomic, retain) NSArray *		goods;
@property (nonatomic, retain) NSString *		name;
@property (nonatomic, retain) NSNumber *		id;
@end

@interface TOP_CATEGORY : NSObject
@property (nonatomic, retain) NSArray *		children;
@property (nonatomic, retain) NSString *		name;
@property (nonatomic, retain) NSNumber *		id;
@end

@interface COMMENT : NSObject
@property (nonatomic, retain) NSString *		author;
@property (nonatomic, retain) NSString *		content;
@property (nonatomic, retain) NSString *		create;
@property (nonatomic, retain) NSString *		re_content;
@property (nonatomic, retain) NSNumber *		id;
@end

@interface CONFIG : NSObject
@property (nonatomic, retain) NSString *		close_comment;
@property (nonatomic, retain) NSString *		service_phone;
@property (nonatomic, retain) NSNumber *		shop_closed;
@property (nonatomic, retain) NSString *		shop_desc;
@property (nonatomic, retain) NSNumber *		shop_reg_closed;
@property (nonatomic, retain) NSString *		site_url;
@property (nonatomic, retain) NSString *		goods_url;
@end

@interface EXPRESS : NSObject
@property (nonatomic, retain) NSString *		context;
@property (nonatomic, retain) NSString *		time;
@end

@interface FILTER : NSObject
@property (nonatomic, retain) NSNumber *		brand_id;
@property (nonatomic, retain) NSNumber *		category_id;
@property (nonatomic, retain) NSString *		keywords;
@property (nonatomic, retain) PRICE_RANGE *		price_range;
@property (nonatomic, retain) NSString *		sort_by;
@end

@interface GOODS : NSObject
@property (nonatomic, retain) NSNumber *		brand_id;
@property (nonatomic, retain) NSNumber *		cat_id;
@property (nonatomic, retain) NSNumber *		click_count;
@property (nonatomic, retain) NSString *		goods_name;
@property (nonatomic, retain) NSString *		goods_number;
@property (nonatomic, retain) NSString *		goods_sn;
@property (nonatomic, retain) NSString *		goods_weight;
@property (nonatomic, retain) PHOTO *           img;
@property (nonatomic, retain) NSNumber *		collected;
@property (nonatomic, retain) NSNumber *		integral;
@property (nonatomic, retain) NSNumber *		is_shipping;
@property (nonatomic, retain) NSString *		market_price;
@property (nonatomic, retain) NSArray *         pictures;
@property (nonatomic, retain) NSString *		promote_end_date;
@property (nonatomic, retain) NSString *		promote_price;
@property (nonatomic, retain) NSString *		formated_promote_price;
@property (nonatomic, retain) NSString *		promote_start_date;
@property (nonatomic, retain) NSArray *         properties;
@property (nonatomic, retain) NSArray *         rank_prices;
@property (nonatomic, retain) NSString *		shop_price;
@property (nonatomic, retain) NSArray *         specification;
@property (nonatomic, retain) NSNumber *		id;
@end

@interface GOOD_ATTR : NSObject
@property (nonatomic, retain) NSString *		name;
@property (nonatomic, retain) NSString *		value;
@end

@interface GOOD_RANK_PRICE : NSObject
@property (nonatomic, retain) NSNumber *		id;
@property (nonatomic, retain) NSString *		price;
@property (nonatomic, retain) NSString *		rank_name;
@end

@interface GOOD_SPEC : NSObject
@property (nonatomic, retain) NSNumber *		attr_type;
@property (nonatomic, retain) NSString *		name;
@property (nonatomic, retain) NSArray *         value;
@end

@interface GOOD_VALUE : NSObject
@property (nonatomic, retain) NSString *		format_price;
@property (nonatomic, retain) NSNumber *		id;
@property (nonatomic, retain) NSString *		label;
@property (nonatomic, retain) NSNumber *		price;
@end

@interface GOOD_SPEC_VALUE : NSObject
@property (nonatomic, retain) GOOD_SPEC *       spec;
@property (nonatomic, retain) GOOD_VALUE *      value;
@end

@interface INVOICE : NSObject
@property (nonatomic, retain) NSString *		value;
@property (nonatomic, retain) NSNumber *		id;
@end

@interface ORDER_INFO : NSObject
@property (nonatomic, retain) NSString *		pay_code;
@property (nonatomic, retain) NSString *		order_sn;
@property (nonatomic, retain) NSString *		order_amount;
@property (nonatomic, retain) NSString *		order_id;
@property (nonatomic, retain) NSString *		subject;
@property (nonatomic, retain) NSString *		desc;
@end

@interface ORDER : NSObject
@property (nonatomic, retain) NSArray *         goods_list;
@property (nonatomic, retain) NSString *		order_sn;
@property (nonatomic, retain) NSString *		order_time;
@property (nonatomic, retain) NSString *		total_fee;
@property (nonatomic, retain) NSString *        formated_integral_money;
@property (nonatomic, retain) NSString *        formated_shipping_fee;
@property (nonatomic, retain) NSString *    	formated_bonus;
@property (nonatomic, retain) NSNumber *		order_id;
@property (nonatomic, retain) ORDER_INFO *		order_info;
@end

@interface ORDER_GOODS : NSObject
@property (nonatomic, retain) NSString *		formated_shop_price;
@property (nonatomic, retain) NSNumber *		goods_number;
@property (nonatomic, retain) PHOTO *		img;
@property (nonatomic, retain) NSString *		name;
@property (nonatomic, retain) NSString *		subtotal;
@property (nonatomic, retain) NSNumber *		goods_id;
@end

@interface PAGINATED : NSObject
@property (nonatomic, retain) NSNumber *		count;
@property (nonatomic, retain) NSNumber *		more;
@property (nonatomic, retain) NSNumber *		total;
@end

@interface PAGINATION : NSObject
@property (nonatomic, retain) NSNumber *		count;
@property (nonatomic, retain) NSNumber *		page;
@end

@interface PAYMENT : NSObject
@property (nonatomic, retain) NSString *		format_pay_fee;
@property (nonatomic, retain) NSNumber *		is_cod;
@property (nonatomic, retain) NSString *		pay_code;
@property (nonatomic, retain) NSString *		pay_desc;
@property (nonatomic, retain) NSString *		pay_fee;
@property (nonatomic, retain) NSString *		pay_name;
@property (nonatomic, retain) NSNumber *		pay_id;
@end

@interface PHOTO : NSObject
@property (nonatomic, retain) NSString *		img;
@property (nonatomic, retain) NSString *		thumb;
@property (nonatomic, retain) NSString *		url;
@property (nonatomic, retain) NSString *		small;
@end

@interface PRICE_RANGE : NSObject
@property (nonatomic, retain) NSNumber *		price_min;
@property (nonatomic, retain) NSNumber *		price_max;
@end

@interface REGION : NSObject
@property (nonatomic, retain) NSNumber *		more;
@property (nonatomic, retain) NSString *		name;
@property (nonatomic, retain) NSNumber *		parent_id;
@property (nonatomic, retain) NSNumber *		id;
@end

@interface SESSION : NSObject
@property (nonatomic, retain) NSString *		sid;
@property (nonatomic, retain) NSNumber *		uid;
@end

@interface SHIPPING : NSObject
@property (nonatomic, retain) NSString *		format_shipping_fee;
@property (nonatomic, retain) NSString *		free_money;
@property (nonatomic, retain) NSString *		insure;
@property (nonatomic, retain) NSString *		insure_formated;
@property (nonatomic, retain) NSString *		shipping_code;
@property (nonatomic, retain) NSString *		shipping_desc;
@property (nonatomic, retain) NSString *		shipping_fee;
@property (nonatomic, retain) NSString *		shipping_name;
@property (nonatomic, retain) NSNumber *		support_cod;
@property (nonatomic, retain) NSNumber *		shipping_id;
@end

@interface SIGNUP_FIELD : NSObject
@property (nonatomic, retain) NSString *		name;
@property (nonatomic, retain) NSNumber *		need;
@property (nonatomic, retain) NSNumber *		id;
@end

@interface SIGNUP_FIELD_VALUE : NSObject
@property (nonatomic, retain) NSString *		value;
@property (nonatomic, retain) NSNumber *		id;
@end

@interface SIMPLE_GOODS : NSObject
@property (nonatomic, retain) NSString *		brief;
@property (nonatomic, retain) PHOTO *		img;
@property (nonatomic, retain) NSString *		market_price;
@property (nonatomic, retain) NSString *		name;
@property (nonatomic, retain) NSString *		promote_price;
@property (nonatomic, retain) NSString *		shop_price;
@property (nonatomic, retain) NSNumber *		id;
@property (nonatomic, retain) NSNumber *		goods_id;
@end

@interface STATUS : NSObject
@property (nonatomic, retain) NSNumber *		error_code;
@property (nonatomic, retain) NSString *		error_desc;
@property (nonatomic, retain) NSNumber *		succeed;
@end

@interface TOTAL : NSObject
@property (nonatomic, retain) NSString *		goods_amount;
@property (nonatomic, retain) NSString *		goods_price;
@property (nonatomic, retain) NSString *		market_price;
@property (nonatomic, retain) NSNumber *		real_goods_count;
@property (nonatomic, retain) NSString *		save_rate;
@property (nonatomic, retain) NSString *		saving;
@property (nonatomic, retain) NSNumber *		virtual_goods_count;
@end

@interface USER : NSObject
@property (nonatomic, retain) NSNumber *		collection_num;
@property (nonatomic, retain) NSString *		name;
@property (nonatomic, retain) NSString *		email;
@property (nonatomic, retain) NSDictionary *	order_num;
@property (nonatomic, retain) NSString *		rank_name;
@property (nonatomic, retain) NSNumber *		rank_level;
@property (nonatomic, retain) NSNumber *		id;
@end

@interface COLLECT_GOODS : SIMPLE_GOODS
@property (nonatomic, retain) NSNumber *		rec_id;
@property (nonatomic, retain) NSNumber *        goods_id;
@property (nonatomic, retain) NSString *		name;
@property (nonatomic, retain) NSString *		market_price;
@property (nonatomic, retain) NSString *		shop_price;
@property (nonatomic, retain) NSString *		promote_price;
@property (nonatomic, retain) PHOTO *           img;
@property (nonatomic, assign) BOOL isEditing; // TODO:
@end

#pragma mark - controllers

@interface API : BeeController

// POST address/add
AS_MESSAGE( address_add );

// POST address/delete
AS_MESSAGE( address_delete );

// POST address/info
AS_MESSAGE( address_info );

// POST address/list
AS_MESSAGE( address_list );

// POST address/setDefault
AS_MESSAGE( address_setDefault );

// POST address/update
AS_MESSAGE( address_update );

// POST article
AS_MESSAGE( article );

// POST cart/create
AS_MESSAGE( cart_create );

// POST cart/delete
AS_MESSAGE( cart_delete );

// POST cart/list
AS_MESSAGE( cart_list );

// POST cart/update
AS_MESSAGE( cart_update );

// POST category
AS_MESSAGE( category );

// POST comments
AS_MESSAGE( comments );

// POST config
AS_MESSAGE( config );

// POST flow/checkOrder
AS_MESSAGE( flow_checkOrder );

// POST flow/done
AS_MESSAGE( flow_done );

// POST goods
AS_MESSAGE( goods );

// POST goods/desc
AS_MESSAGE( goods_desc );

// POST home/category
AS_MESSAGE( home_category );

// POST oeder/express
AS_MESSAGE( order_express );

// POST home/data
AS_MESSAGE( home_data );

// POST order/affirmReceived
AS_MESSAGE( order_affirmReceived );

// POST order/cancel
AS_MESSAGE( order_cancel );

// POST order/list
AS_MESSAGE( order_list );

// POST order/pay
AS_MESSAGE( order_pay );

// POST region
AS_MESSAGE( region );

// POST search
AS_MESSAGE( search );

// POST searchKeywords
AS_MESSAGE( searchKeywords );

// POST shopHelp
AS_MESSAGE( shopHelp );

// POST user/collect/create
AS_MESSAGE( user_collect_create );

// POST user/collect/delete
AS_MESSAGE( user_collect_delete );

// POST user/collect/list
AS_MESSAGE( user_collect_list );

// POST user/info
AS_MESSAGE( user_info );

// POST user/signin
AS_MESSAGE( user_signin );

// POST user/signup
AS_MESSAGE( user_signup );

// POST user/signupFields
AS_MESSAGE( user_signupFields );

// POST validate/bonus
AS_MESSAGE( validate_bonus );

// POST validate/integral
AS_MESSAGE( validate_integral );

// POST brand
AS_MESSAGE( brand );

// POST price_range
AS_MESSAGE( price_range );

@end

#pragma mark - config

@interface ServerConfig : NSObject

AS_SINGLETON( ServerConfig )

@property (nonatomic, retain) NSString *	url;

@end
