//
//  DownLoadManager.h
//  guwangyule
//
//  Created by Jeremy on 2017/8/31.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
typedef void(^CallBack)(id);
@interface DownLoadManager : UIView
+(DownLoadManager*)shareInterface;
-(void)postddByByUrlPath:(NSString *)path andParams:(NSString*)params andHUD:(MBProgressHUD *)hud andCallBack:(CallBack)callback;
@end
