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

#import "Bee.h"
#import "ecmobile.h"

#pragma mark -

@interface UserModel : BeeOnceViewModel

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
