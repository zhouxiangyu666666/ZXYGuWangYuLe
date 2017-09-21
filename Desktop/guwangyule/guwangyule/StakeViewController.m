//
//  StakeViewController.m
//  guwangyule
//
//  Created by Jeremy on 2017/9/11.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "StakeViewController.h"
#import "ModelManager.h"
#import "DownLoadManager.h"
#import "ApiManager.h"
#import "MBProgressHUD.h"
@interface StakeViewController ()

@end

@implementation StakeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    searchTimer=[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(CheckUSerGameInfo) userInfo:nil repeats:YES];
}
-(void)CheckUSerGameInfo
{
    NSString *param = [NSString stringWithFormat:@"userId=%@&roomId=%@",[ModelManager shareInterface].loginInfoModel.userId,[ModelManager shareInterface].addRoomInfo.roomId];
    [[DownLoadManager shareInterface] postddByByUrlPath:GameCheck_api andParams:param andHUD:nil andCallBack:^(id obj) {
        if ([[obj objectForKey:@"code"] isEqualToString:@"0"]) {
            [[ModelManager shareInterface].userGameInfo setValuesForKeysWithDictionary:[obj objectForKey:@"result"]];
        }
        [ModelManager shareInterface].gameTimes=[[ModelManager shareInterface].userGameInfo.gameTimes intValue];
    }];
}
- (IBAction)subtract:(UIButton *)sender {
    sender.selected=!sender.selected;
    UILabel *superLabel = [self.view viewWithTag:sender.tag+100];
    if ([superLabel.text intValue]>0) {
        superLabel.text=[NSString stringWithFormat:@"%d",[superLabel.text intValue]-1];
    }
}
- (IBAction)add:(UIButton *)sender {
    sender.selected=!sender.selected;
    UILabel *superLabel = [self.view viewWithTag:sender.tag-100];
    superLabel.text=[NSString stringWithFormat:@"%d",[superLabel.text intValue]+1];
}
- (IBAction)certain:(UIButton *)sender {
    NSString *param = [NSString stringWithFormat:@"userId=%@&roomId=%@&gameTimes=%@",[ModelManager shareInterface].loginInfoModel.userId,[ModelManager shareInterface].addRoomInfo.roomId,[NSString stringWithFormat:@"%d",[ModelManager shareInterface].gameTimes+1]];
    
    NSArray *paramArray = @[@"betBig",@"betSmall",@"betSingle",@"betDouble",@"betFour",@"betFive",@"betSix",@"betSeven",@"betEight",@"betNine",@"betTen",@"betEleven",@"betTwelve",@"betThirteen",@"betFourteen",@"betFifteen",@"betSixteen",@"betSeventeen",@"betLeopard"];
    
    for (int i = 0; i<19; i++) {
        UILabel *label = [self.view viewWithTag:i+201];
        NSString *string =[[NSString alloc]initWithFormat:@"&%@=%@",paramArray[i],label.text];
        param = [param stringByAppendingString:string];
    }
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[DownLoadManager shareInterface] postddByByUrlPath:bet_api andParams:param andHUD:hud andCallBack:^(id obj) {
        if ([[obj objectForKey:@"code"] isEqualToString:@"0"]) {
            hud.label.text=@"下注成功";
            [hud hideAnimated:YES afterDelay:1];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"userStartGame" object:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else{
            hud.label.text=[obj objectForKey:@"message"];
            [hud hideAnimated:YES afterDelay:1];
        }
    }];
}
-(void)closeTimer
{
    [searchTimer invalidate];
    searchTimer = nil;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self closeTimer];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"beginTimer" object:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
