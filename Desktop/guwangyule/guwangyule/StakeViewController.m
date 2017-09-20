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
{
    int gameTimes;
}
@end

@implementation StakeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    gameTimes=1;
}
- (IBAction)subtract:(UIButton *)sender {
    UILabel *superLabel = [self.view viewWithTag:sender.tag+100];
    if ([superLabel.text intValue]>0) {
        superLabel.text=[NSString stringWithFormat:@"%d",[superLabel.text intValue]-1];
    }
}
- (IBAction)add:(UIButton *)sender {
    UILabel *superLabel = [self.view viewWithTag:sender.tag-100];
    superLabel.text=[NSString stringWithFormat:@"%d",[superLabel.text intValue]+1];
}
- (IBAction)certain:(UIButton *)sender {
    NSString *param = [NSString stringWithFormat:@"userId=%@&roomId=%@&gameTimes=%@",[ModelManager shareInterface].loginInfoModel.userId,[ModelManager shareInterface].addRoomInfo.roomId,[NSString stringWithFormat:@"%d",gameTimes]];
    
    NSArray *paramArray = @[@"betBig",@"betSmall",@"betSingle",@"betDouble",@"betNine",@"betTen",@"betEleven",@"betTwelve",@"betSeven",@"betEight",@"betThirteen",@"betFourteen",@"betFive",@"betSix",@"betFifteen",@"betSixteen",@"betFour",@"betSeventeen",@"betLeopard"];
    
    for (int i = 0; i<19; i++) {
        UILabel *label = [self.view viewWithTag:i+201];
        NSString *string =[[NSString alloc]initWithFormat:@"&%@=%@",paramArray[i],label.text];
        param = [param stringByAppendingString:string];
    }
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[DownLoadManager shareInterface] postddByByUrlPath:bet_api andParams:param andHUD:hud andCallBack:^(id obj) {
        if ([[obj objectForKey:@"code"] isEqualToString:@"0"]) {
            gameTimes++;
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
