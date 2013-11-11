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
#import "ecmobile.h"
#import "BaseModel.h"

#pragma mark -

@interface UserModel : BaseModel

AS_SINGLETON( UserModel )

@property (nonatomic, retain) SESSION *	session;
@property (nonatomic, retain) UIImage *	avatar;
@property (nonatomic, retain) NSArray *	fields;
@property (nonatomic, retain) USER *	user;
@property (nonatomic, assign) BOOL		firstUse;

AS_NOTIFICATION( LOGIN )
AS_NOTIFICATION( LOGOUT )
AS_NOTIFICATION( KICKOUT )
AS_NOTIFICATION( UPDATED )

+ (BOOL)online;

- (void)setOnline:(BOOL)flag;
- (void)setOffline:(BOOL)flag;

- (void)signinWithUser:(NSString *)user
			  password:(NSString *)password;
- (void)signupWithUser:(NSString *)user
			  password:(NSString *)password
				 email:(NSString *)email
				fields:(NSArray *)fields;

- (void)signout;
- (void)kickout;

- (void)updateFields;
- (void)updateProfile;

@end
