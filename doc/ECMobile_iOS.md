#修改工程

1. 打开工程
2. 找到[AppDelegate load]方法，修改 [ServerConfig sharedInstance].url
3. 找到[AppDelegate updateConfig]方法，修改以下代码：

<pre>
// 配置微信
weixin.config.appId			= @"<Your information>";
weixin.config.appKey		= @"<Your information>";

// 配置新浪
sweibo.config.appKey		= @"<Your information>";
sweibo.config.appSecret		= @"<Your information>";
sweibo.config.redirectURI	= @"<Your information>";

// 配置腾讯
tweibo.config.appKey		= @"<Your information>";
tweibo.config.appSecret		= @"<Your information>";
tweibo.config.redirectURI	= @"<Your information>";

// 配置语音识别
siri.config.showUI			= NO;
siri.config.appID			= @"<Your iflyKey>";

// 配置友盟
[MobClick startWithAppkey:@"<Your umengKey>" reportPolicy:BATCH channelId:nil];

// 配置快递100
[ExpressModel setKuaidi100Key:@"<Your kuaidi100Key>"];
</pre>

#联系方式

官方论坛：http://bbs.ecmobile.cn/    

QQ群1：329673575    
QQ群2：239571314    
QQ群3：347624547    