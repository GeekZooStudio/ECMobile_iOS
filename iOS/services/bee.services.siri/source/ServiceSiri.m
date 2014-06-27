//
//   ______    ______    ______
//  /\  __ \  /\  ___\  /\  ___\
//  \ \  __<  \ \  __\_ \ \  __\_
//   \ \_____\ \ \_____\ \ \_____\
//    \/_____/  \/_____/  \/_____/
//
//
//  Copyright (c) 2014-2015, Geek Zoo Studio
//  http://www.bee-framework.com
//
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//

#import "ServiceSiri.h"
#import "ServiceSiri_Window.h"

#import "iflyMSC/IFlySpeechRecognizerDelegate.h"
#import "iflyMSC/IFlySpeechRecognizer.h"



#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#pragma mark -

@interface ServiceSiri()<IFlySpeechRecognizerDelegate>
{
	IFlySpeechRecognizer *	_recognizer;
	BOOL					_recognizing;
	
	BeeServiceBlock			_whenStart;
	BeeServiceBlock			_whenVolumnChanged;
	BeeServiceBlock			_whenRecognized;
	BeeServiceBlock			_whenFailed;
	BeeServiceBlock			_whenCancelled;
    NSMutableArray *        _tempResult;
}
@end

#pragma mark -

@implementation ServiceSiri

SERVICE_AUTO_LOADING( YES );
SERVICE_AUTO_POWERON( YES );

@dynamic config;

@synthesize whenStart = _whenStart;
@synthesize whenVolumnChanged = _whenVolumnChanged;
@synthesize whenRecognized = _whenRecognized;
@synthesize whenFailed = _whenFailed;
@synthesize whenCancelled = _whenCancelled;

@synthesize recognizing = _recognizing;
@synthesize volumn = _volumn;
@synthesize results = _results;

@dynamic START;
@dynamic STOP;
@dynamic CANCEL;

- (void)load
{
    _tempResult = [[NSMutableArray alloc] init];
}

- (void)unload
{
    [_tempResult removeAllObjects];
    [_tempResult release];
    
    self.results = nil;
	self.whenStart = nil;
	self.whenVolumnChanged = nil;
	self.whenRecognized = nil;
	self.whenFailed = nil;
	self.whenCancelled = nil;
}

#pragma mark -

- (void)powerOn
{
}

- (void)powerOff
{
	self.results = nil;
	
	[_recognizer setDelegate:nil];
	[_recognizer cancel];
	_recognizer = nil;
}

- (void)serviceWillActive
{
}

- (void)serviceDidActived
{
}

- (void)serviceWillDeactive
{
}

- (void)serviceDidDeactived
{
}

#pragma mark -

- (ServiceSiri_Config *)config
{
	return [ServiceSiri_Config sharedInstance];
}

- (BeeServiceBlock)START
{
	BeeServiceBlock block = ^ void ( void )
	{
		[self start];
	};
	
	return [[block copy] autorelease];
}

- (BeeServiceBlock)STOP
{
	BeeServiceBlock block = ^ void ( void )
	{
		[self stop];
	};
	
	return [[block copy] autorelease];
}

- (BeeServiceBlock)CANCEL
{
	BeeServiceBlock block = ^ void ( void )
	{
		[self cancel];
	};
	
	return [[block copy] autorelease];
}

#pragma mark -

- (void)start
{
	__block id __self = self;

	if ( [[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)] )
	{
		[[AVAudioSession sharedInstance] requestRecordPermission:^( BOOL granted )
		{
			if ( NO == granted )
			{
				[BeeUIAlertView showMessage:@"您关闭了麦克风权限，无法正常识别。请前往 设置 > 隐私 > 麦克风 中开启权限。"
								cancelTitle:@"确定"];
			}
			else
			{
				[__self internalStart];
			}
		}];
	}
	else
	{
		[self internalStart];
	}
}

- (void)internalStart
{
	if ( nil == _recognizer )
	{
		NSString * params = [NSString stringWithFormat:@"appid=%@,timeout=%d", self.config.appID, (30 * 1000)];
		_recognizer = [IFlySpeechRecognizer createRecognizer:params delegate:self];
		[_recognizer setParameter:@"domain" value:@"search"];
		[_recognizer setParameter:@"asr_ptt" value:@"0"];
		[_recognizer setParameter:@"sample_rate" value:@"16000"];
		[_recognizer setParameter:@"plain_result" value:@"0"];
	}
	
	[_recognizer setDelegate:nil];
	[_recognizer cancel];
	
	[_recognizer setDelegate:self];
	[_recognizer startListening];
	
	if ( self.config.showUI )
	{
		[[ServiceSiri_Window sharedInstance] open];
	}
	
	if ( self.whenStart )
	{
		self.whenStart();
	}
}

- (void)stop
{
	if ( _recognizer )
	{
		[_recognizer stopListening];
		
		if ( self.config.showUI )
		{
			[[ServiceSiri_Window sharedInstance] close];
		}
	}
}

- (void)cancel
{
	if ( _recognizer )
	{
		[_recognizer setDelegate:nil];
		[_recognizer cancel];

		if ( self.config.showUI )
		{
			[[ServiceSiri_Window sharedInstance] close];
		}

		if ( self.whenCancelled )
		{
			self.whenCancelled();
		}
	}
}

#pragma mark -

- (void)onVolumeChanged:(int)vol
{
	_volumn = vol;
	
	if ( self.whenVolumnChanged )
	{
		self.whenVolumnChanged();
	}
}

- (void)onBeginOfSpeech
{
}

- (void)onEndOfSpeech
{
}

- (void)onError:(IFlySpeechError *)errorCode
{
    if ( self.config.showUI )
	{
		[[ServiceSiri_Window sharedInstance] close];
	}
    
    if ( 0 == errorCode.errorCode && _tempResult.count )
    {
        self.results = [_tempResult copy];
        
        if ( self.whenRecognized )
		{
			self.whenRecognized();
		}
    }
    else
    {
        if ( self.whenFailed )
        {
            self.whenFailed();
        }
    }
    
    [_tempResult removeAllObjects];
}

- (void)onResults:(NSArray *)results
{
	NSDictionary * dict = [results objectAtIndex:0];
	
	if ( [dict isKindOfClass:[NSDictionary class]] )
	{
        [_tempResult addObjectsFromArray:dict.allKeys];
	}
}

- (void)onCancel
{
}

@end

#endif  // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
