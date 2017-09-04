//
//  DownLoad.h
//  laibaApp
//
//  Created by 北京正途信息科技有限公司 on 16/3/11.
//  Copyright © 2016年 北京正途信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
typedef void(^CallBack)(id);
@interface DownLoadManager : UIView
+(DownLoadManager*)shareInterface;
-(void)postddByByUrlPath:(NSString *)path andParams:(NSString*)params andHUD:(MBProgressHUD *)hud andCallBack:(CallBack)callback;
@end
