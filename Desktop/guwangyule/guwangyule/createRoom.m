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
#import "createRoomInfoManager.h"
@implementation createRoom

- (IBAction)cancel:(UIButton *)sender {
    [self removeFromSuperview];
}

- (IBAction)certain:(UIButton *)sender {
    NSString *param = [NSString stringWithFormat:@"userId=%@",@"12"];
    [[DownLoadManager shareInterface] postddByByUrlPath:createRoom_api andParams:param andHUD:nil andCallBack:^(id obj) {
        NSLog(@"%@",obj);
        NSDictionary *dic = [obj objectForKey:@"result"];
        [createRoomInfoManager shareInterface].diamondcount=[dic objectForKey:@"diamondcount"];
        [createRoomInfoManager shareInterface].goldcount=[dic objectForKey:@"goldcount"];
        [createRoomInfoManager shareInterface].userid=[dic objectForKey:@"id"];
        [createRoomInfoManager shareInterface].logo=[dic objectForKey:@"logo"];
        [createRoomInfoManager shareInterface].name=[dic objectForKey:@"name"];
        [createRoomInfoManager shareInterface].roomId=[dic objectForKey:@"roomId"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"createRoom" object:nil];
    }];
}

@end
