//
//  createRoom.m
//  guwangyule
//
//  Created by Jeremy on 2017/9/5.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "createRoom.h"
#import "DownLoadManager.h"
#import "ApiManager.h"
#import "ModelManager.h"
#import "CreateRoomInfo.h"
#import "MBProgressHUD.h"
@implementation createRoom

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.backgroundColor=[UIColor clearColor].CGColor;
}

- (IBAction)cancel:(UIButton *)sender {
    [self removeFromSuperview];
}

- (IBAction)certain:(UIButton *)sender {
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.superview animated:YES];
    hud.label.text=@"创建中...";
    [ModelManager shareInterface].createRoomInfoModel=[[CreateRoomInfo alloc]init];
    NSString *param = [NSString stringWithFormat:@"userId=%@",[ModelManager shareInterface].loginInfoModel.userId];
    [[DownLoadManager shareInterface] postddByByUrlPath:createRoom_api andParams:param andHUD:hud andCallBack:^(id obj) {
        NSLog(@"%@",obj);
        if ([[obj objectForKey:@"code"] isEqualToString:@"0"]) {
            [[ModelManager shareInterface].createRoomInfoModel setValuesForKeysWithDictionary:[obj objectForKey:@"result"]];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"createRoom" object:nil];
            [hud hideAnimated:YES afterDelay:1];
        }
        else{
            hud.label.text=[obj objectForKey:@"message"];
            [hud hideAnimated:YES afterDelay:1];
        }
    }];
    [self removeFromSuperview];
}

@end
