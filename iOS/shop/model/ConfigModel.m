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

#import "ConfigModel.h"

#pragma mark -

@implementation ConfigModel

DEF_SINGLETON( ConfigModel )

DEF_NOTIFICATION( UPDATED )

@synthesize config = _config;

- (void)load
{
	[self loadCache];
}

- (void)unload
{
	[self saveCache];

	self.config = nil;
}

#pragma mark -

- (void)loadCache
{
	self.config = [CONFIG readFromUserDefaults:@"ConfigModel.config"];
}

- (void)saveCache
{
	[CONFIG userDefaultsWrite:[self.config objectToString] forKey:@"ConfigModel.config"];
}

- (void)clearCache
{
	[CONFIG userDefaultsRemove:@"ConfigModel.config"];
	
	self.config = nil;
	self.loaded = NO;
}

#pragma mark -

- (void)reload
{
	self.CANCEL_MSG( API.config );
	self.MSG( API.config );
}

#pragma mark -

ON_MESSAGE3( API, config, msg )
{
	if ( msg.succeed )
	{
		STATUS * status = msg.GET_OUTPUT( @"status" );
		if ( NO == status.succeed.boolValue )
		{
			msg.failed = YES;
			return;
		}

		self.config = msg.GET_OUTPUT( @"config" );
		self.loaded = YES;
		
		[self saveCache];
		[self postNotification:self.UPDATED];
	}
}

@end
