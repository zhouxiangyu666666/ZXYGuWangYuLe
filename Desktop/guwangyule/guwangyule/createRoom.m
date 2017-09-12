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
@implementation createRoom

- (IBAction)cancel:(UIButton *)sender {
    [self removeFromSuperview];
}

- (IBAction)certain:(UIButton *)sender {
    [ModelManager shareInterface].createRoomInfoModel=[[CreateRoomInfo alloc]init];
    NSString *param = [NSString stringWithFormat:@"userId=%@",@"12"];
    [[DownLoadManager shareInterface] postddByByUrlPath:createRoom_api andParams:param andHUD:nil andCallBack:^(id obj) {
        [[ModelManager shareInterface].createRoomInfoModel setValuesForKeysWithDictionary:[obj objectForKey:@"result"]];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"createRoom" object:nil];
    }];
}

@end
