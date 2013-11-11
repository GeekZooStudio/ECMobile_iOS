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

#import "Bee.h"

@class FormCell;

@interface FormElement : NSObject

@property (nonatomic, retain) id            data;
@property (nonatomic, assign) Class         clazz;
@property (nonatomic, assign) Class         customClazz;
@property (nonatomic, retain) FormCell *    view;
@property (nonatomic, retain) BeeUICell *   customView;

@property (nonatomic, assign) BOOL          isNecessary;
@property (nonatomic, assign) BOOL          enable;
@property (nonatomic, retain) NSString *    text;
@property (nonatomic, retain) NSString *    title;
@property (nonatomic, retain) NSString *    subtitle;
@property (nonatomic, retain) NSString *    tagString;         // used for query

@property (nonatomic, assign) CGSize        size;              // button
@property (nonatomic, retain) NSString *    image;             // button
@property (nonatomic, retain) NSString *    backgroundImage;   // button
@property (nonatomic, retain) NSString *    signal;

@property (nonatomic, assign) BOOL             isSecure;       // input
@property (nonatomic, retain) NSString *       placeholder;    // input
@property (nonatomic, assign) UIReturnKeyType  returnKeyType;  // input
@property (nonatomic, assign) UIKeyboardType   keyboardType;   // input

+ (id)cell;
+ (id)input;
+ (id)check;
+ (id)button;
+ (id)switchr;
+ (id)detailCell;
+ (id)subtitleCell;
+ (id)customWithClass:(Class)clazz;

+ (id)subtitleWithTitle:(NSString *)title;
+ (Class)classWithObject:(FormElement *)object;

@end

@interface FormCell : UITableViewCell
@property (nonatomic, retain) id data;
@property (nonatomic, retain) FormElement * element;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * subtitle;
@end

@interface FormCounter : FormCell

@property (nonatomic, retain) NSNumber *        count;
@property (nonatomic, retain) BeeUILabel *      label;
@property (nonatomic, retain) BeeUIButton *     pluss;
@property (nonatomic, retain) BeeUIButton *     minus;
@property (nonatomic, retain) BeeUITextField *  input;

AS_SIGNAL( COUNT_CHANGE )

@end

@interface FormCheckCell : FormCell
@end

@interface FormDetailCell : FormCell
@property (nonatomic, retain) BeeUILabel * label1;
@property (nonatomic, retain) BeeUILabel * label2;
@end

@interface FormSubtitleCell : FormCell
@end

@interface FormCustomCell : FormCell
@property (nonatomic, retain) BeeUICell * customView;
@end

@interface FormInputCell : FormCell
@property (nonatomic, retain) BeeUITextField * input;
@end

@interface FormSwitchCell : FormCell
@property (nonatomic, retain) BeeUISwitch * switchr;
@end

@interface FormButton : FormCell
AS_SIGNAL( TOUCHED )
@property (nonatomic, assign) CGSize        buttonSize;
@property (nonatomic, retain) BeeUIButton * button;
@property (nonatomic, retain) UIImage *     background;
@end

@interface FormViewBoard : BeeUIBoard<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) UITableViewStyle style;
@property (nonatomic, retain) UITableView    * table;
@property (nonatomic, retain) NSMutableArray * datas;
@property (nonatomic, retain) NSMutableArray * titles;
@property (nonatomic, retain) NSMutableArray * selectedDatas;
@property (nonatomic, retain) NSIndexPath    * selectedIndexPath;
@property (nonatomic, retain) NSMutableArray * selectedIndexPathes;

- (NSString *)valueByQuery:(NSString *)string;
- (void)reloadData;
- (NSArray *)inputs;
ON_SIGNAL2( BeeUIBoard, signal );

AS_INT(CELL_TYPE_CHECK);
AS_INT(CELL_TYPE_RADIO);
AS_INT(CELL_TYPE_STACK);
AS_INT(CELL_TYPE_MIXED);
AS_INT(CELL_TYPE_DETAIL);

@end
