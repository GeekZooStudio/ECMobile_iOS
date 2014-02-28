#第一步、后台配置

1. 打开工程，找到 /shop/Supporting files/AppDelegate.m
2. 修改如下代码为ECMobile API地址：

<pre>
[ServerConfig sharedInstance].url = @"http://shop.ecmobile.me/ecmobile/?url=";
</pre>

#第二步、服务配置

1. 打开工程，找到 /shop/Supporting files/AppDelegate.m
2. 替换 \<Your information\> 为自己的信息
3. 打开 /shop/model/ExpressModel.m
4. 替换 \<Your information\> 为自己的信息

<pre>
ALIAS( bee.services.share.weixin,		weixin );
ALIAS( bee.services.share.tencentweibo,	tweibo );
ALIAS( bee.services.share.sinaweibo,	sweibo );
ALIAS( bee.services.alipay,				alipay );
ALIAS( bee.services.siri,				siri );
ALIAS( bee.services.location,			lbs );

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

// 配置支付宝
alipay.config.parnter		= @"<Your information>";
alipay.config.seller		= @"<Your information>";
alipay.config.privateKey	= @"<Your information>";
alipay.config.publicKey		= @"<Your information>";
alipay.config.notifyURL		= @"<Your information>";

...
</pre>

#二次开发

1. 阅读 `ECMobile_源码说明.pdf`
2. 打开工程，找到 /shop/view_iPhone/source，修改需要调整的 .xml 界面布局及样式
3. 找到 /shop/view_iPhone/resource/default.css，修改全局样式

#联系方式

官方论坛：http://bbs.ecmobile.cn/    

QQ群1：329673575    
QQ群2：239571314    
QQ群3：347624547    