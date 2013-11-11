//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//
//	Copyright (c) 2013-2014, {Bee} open source community
//	http://www.bee-framework.com
//
//
//	Permission is hereby granted, free of charge, to any person obtaining a
//	copy of this software and associated documentation files (the "Software"),
//	to deal in the Software without restriction, including without limitation
//	the rights to use, copy, modify, merge, publish, distribute, sublicense,
//	and/or sell copies of the Software, and to permit persons to whom the
//	Software is furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//	IN THE SOFTWARE.
//

#import "Bee_Precompile.h"
#import "Bee_Foundation.h"
#import "Bee_SystemConfig.h"
#import "Bee_SystemPackage.h"

#pragma mark -

AS_PACKAGE_INSTANCE( BeePackage, BeePackage_Service, service );

#pragma mark -

@class BeeService;

typedef	BeeService *	(^BeeServiceBlock)( void );
typedef	BeeService *	(^BeeServiceBlockN)( BeeService * service, ... );

#pragma mark -

#undef	AS_SERVICE
#define	AS_SERVICE( __class, __name ) \
		AS_PACKAGE( BeePackage_Service, __class, __name )

#undef	DEF_SERVICE
#define	DEF_SERVICE( __class, __name ) \
		DEF_PACKAGE( BeePackage_Service, __class, __name )

#pragma mark -

#undef	SERVICE_AUTO_LOADING
#define SERVICE_AUTO_LOADING( __flag ) \
		+ (BOOL)serviceAutoLoading { return __flag; }

#undef	SERVICE_AUTO_POWERON
#define SERVICE_AUTO_POWERON( __flag ) \
		+ (BOOL)serviceAutoPowerOn { return __flag; }

#pragma mark -

@protocol BeeServiceExecutor<NSObject>

- (void)load;
- (void)unload;

- (BOOL)running;
- (void)powerOn;
- (void)powerOff;

- (void)enterForeground;
- (void)enterBackground;

@end

#pragma mark -

@interface BeeService : NSObject<BeeServiceExecutor>

@property (nonatomic, retain) NSString *		name;
@property (nonatomic, retain) NSBundle *		bundle;

@property (nonatomic, readonly) BOOL			running;
@property (nonatomic, readonly) BeeServiceBlock	ON;
@property (nonatomic, readonly) BeeServiceBlock	OFF;

+ (instancetype)sharedInstance;

+ (BOOL)serviceAutoLoading;
+ (BOOL)serviceAutoPowerOn;

+ (BOOL)servicePreLoad;
+ (void)serviceDidLoad;

- (NSArray *)loadedServices;

@end
