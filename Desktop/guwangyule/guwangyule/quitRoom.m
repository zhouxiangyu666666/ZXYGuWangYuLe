//
//  quitRoom.m
//  guwangyule
//
//  Created by Jeremy on 2017/9/22.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "quitRoom.h"
#import "DownLoadManager.h"
#import "ModelManager.h"
#import "ApiManager.h"
@implementation quitRoom
- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.backgroundColor=[UIColor clearColor].CGColor;
    
}

- (IBAction)cancel:(UIButton *)sender {
    [self removeFromSuperview];
}

- (IBAction)certain:(UIButton *)sender {
    
    NSString *param = [NSString stringWithFormat:@"userId=%@&roomId=%@",[ModelManager shareInterface].loginInfoModel.userId,[ModelManager shareInterface].addRoomInfo.roomId];
    [[DownLoadManager shareInterface] postddByByUrlPath:quitRoom_api andParams:param andHUD:nil andCallBack:^(id obj) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"quitRoom" object:nil];
        [self removeFromSuperview];
    }];
    
    
}

@end
