
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
@interface EnterRoom()<UITextFieldDelegate>


@end
@implementation EnterRoom

- (void)awakeFromNib {
    [super awakeFromNib];
    self.roomNumber.delegate=self;
    [self.roomNumber addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    self.layer.backgroundColor=[UIColor clearColor].CGColor;
}
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
            [hud hideAnimated:YES afterDelay:1];
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
-(void)textFieldDidChange
{
    if (_roomNumber.text.length==6) {
        
        [_roomNumber resignFirstResponder];
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField setText:nil];
}
@end
