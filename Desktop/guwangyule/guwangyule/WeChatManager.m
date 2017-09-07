//
//  WeChatManager.m
//  guwangyule
//
//  Created by Jeremy on 2017/8/31.
//  Copyright © 2017年 Macx. All rights reserved.


#import "WeChatManager.h"
#import "ApiManager.h"
#import "DownLoadManager.h"
#import "ApiManager.h"
@implementation WeChatManager
+(WeChatManager*)shareInterface
{
    static WeChatManager* _shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareManager=[[WeChatManager alloc]init];
    });
    return _shareManager;
}
//微信登陆
-(void)sendAuthRequest
{
    if (![WXApi isWXAppInstalled]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/wei-xin/id414478124?mt=8"]];
    }
    else{
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc ]init];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"wechat_sdk_demo" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
    }
}
-(void) onResp:(SendAuthResp*)resp{
    if (resp.errCode==0) {
        NSString *param = [NSString stringWithFormat:@"code=%@&phone=0",resp.code];
        [[DownLoadManager shareInterface] postddByByUrlPath:weChatLogin_api andParams:param andHUD:nil andCallBack:^(id obj) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"turnToMainVC" object:nil];
            NSLog(@"%@",obj);
            
        }];
    }
}

@end
