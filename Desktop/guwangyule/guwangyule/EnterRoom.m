
//
//  EnterRoom.m
//  guwangyule
//
//  Created by Jeremy on 2017/9/5.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "EnterRoom.h"
#import "ModelManager.h"
#import "DownLoadManager.h"
#import "ApiManager.h"
#import "AddRoomInfo.h"
#import "MBProgressHUD.h"
@interface EnterRoom()
@property (strong, nonatomic) IBOutlet UITextField *roomNumber;

@end
@implementation EnterRoom

- (IBAction)certain:(UIButton *)sender {
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.superview animated:YES];
    hud.label.text=@"加入中...";
    [ModelManager shareInterface].addRoomInfo=[[AddRoomInfo alloc]init];
    NSString *param = [NSString stringWithFormat:@"userId=%@&roomId=%@",[ModelManager shareInterface].loginInfoModel.userId,_roomNumber.text];
    [[DownLoadManager shareInterface] postddByByUrlPath:addRoom_api andParams:param andHUD:nil andCallBack:^(id obj) {
        NSLog(@"%@",obj);
        if ([[obj objectForKey:@"code"] isEqualToString:@"0"]) {
            [[ModelManager shareInterface].addRoomInfo setValuesForKeysWithDictionary:[obj objectForKey:@"result"]];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"addRoom" object:nil];
        }
        else{
            hud.label.text=[obj objectForKey:@"message"];
            [hud hideAnimated:YES afterDelay:1];
        }
    }];
    [self removeFromSuperview];
}
- (IBAction)cancel:(UIButton *)sender {
    [self removeFromSuperview];
}

@end
