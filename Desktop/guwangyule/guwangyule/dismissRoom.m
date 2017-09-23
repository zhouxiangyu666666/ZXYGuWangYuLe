//
//  dismissRoom.m
//  guwangyule
//
//  Created by Jeremy on 2017/9/22.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "dismissRoom.h"
#import "ModelManager.h"
#import "DownLoadManager.h"
#import "ApiManager.h"
#import "MBProgressHUD.h"
@implementation dismissRoom

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.backgroundColor=[UIColor clearColor].CGColor;
    
}

- (IBAction)cancel:(UIButton *)sender {
    [self removeFromSuperview];
}
- (IBAction)certain:(UIButton *)sender {
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.label.text=@"解散中...";
    NSString *param = [NSString stringWithFormat:@"userId=%@&roomId=%@",[ModelManager shareInterface].loginInfoModel.userId,[ModelManager shareInterface].createRoomInfoModel.roomId];
    [[DownLoadManager shareInterface] postddByByUrlPath:dissolveRoom_api andParams:param andHUD:nil andCallBack:^(id obj) {
        if ([[obj objectForKey:@"code"] isEqualToString:@"0"])  {
            hud.label.text=@"解散成功";
            [hud hideAnimated:YES afterDelay:1];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissRoom" object:nil];
        }
        else{
            hud.label.text=[obj objectForKey:@"message"];
            [hud hideAnimated:YES afterDelay:1];
        }
    }];
}

@end
