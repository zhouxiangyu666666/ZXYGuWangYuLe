//
//  WeChatManager.h
//  guwangyule
//
//  Created by Jeremy on 2017/8/31.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WXApiObject.h>
#import <WXApi.h>
@interface WeChatManager : NSObject<WXApiDelegate>
+(WeChatManager*)shareInterface;
-(void)sendAuthRequest;
@end
