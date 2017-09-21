//
//  CreateRoomViewController.m
//  guwangyule
//
//  Created by Jeremy on 2017/9/6.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "CreateRoomViewController.h"
#import "buyGold.h"
#import "ModelManager.h"
#import <UIImageView+WebCache.h>
#import "DownLoadManager.h"
#import "ApiManager.h"
#import "OwnerGameInfo.h"
#import "MBProgressHUD.h"
#import "ownerNoticeView.h"
@interface CreateRoomViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *diceImageView;
@property (strong, nonatomic) IBOutlet UILabel *roomNumber;
@property (strong, nonatomic) IBOutlet UILabel *previousDice;
@property (strong, nonatomic) IBOutlet UILabel *peopleNumber;
@property (strong, nonatomic) IBOutlet UIImageView *RoomHostHeader;
@property (strong, nonatomic) IBOutlet UILabel *RoomHostName;

@property (strong, nonatomic) IBOutlet UILabel *RoomHostID;

@property (strong, nonatomic) IBOutlet UILabel *stakeNumber;
@property (strong, nonatomic) IBOutlet UIButton *startButton;

@end

@implementation CreateRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [ModelManager shareInterface].gameTimes=1;
    _diceImageView.hidden=YES;
    _roomNumber.text=[NSString stringWithFormat:@"房间号:%@",[ModelManager shareInterface].createRoomInfoModel.roomId];
    _stakeNumber.text=[NSString stringWithFormat:@"%@",[ModelManager shareInterface].createRoomInfoModel.goldCount];
    _RoomHostName.text=[NSString stringWithFormat:@"%@",[ModelManager shareInterface].createRoomInfoModel.ownerName];
    _RoomHostID.text=[NSString stringWithFormat:@"ID:%@",[ModelManager shareInterface].createRoomInfoModel.ownerId];
    [_RoomHostHeader sd_setImageWithURL:[NSURL URLWithString:[ModelManager shareInterface].createRoomInfoModel.ownerLogo]placeholderImage:[UIImage imageNamed:@"fz"]];
    [self setGameInfo];
}
-(void)setGameInfo
{
    if ([ModelManager shareInterface].gameTimes==1) {
        _peopleNumber.text=[NSString stringWithFormat:@"人数:1/50"];
    }
    else{
    _peopleNumber.text=[NSString stringWithFormat:@"人数:%@/50",[ModelManager shareInterface].createRoomInfoModel.memberCount];
    _previousDice.text=[NSString stringWithFormat:@"上一期骰点:%@",[ModelManager shareInterface].ownerGameInfo.gameResult];
    }
}

- (IBAction)dismissRoom:(UIButton *)sender {
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text=@"解散中...";
    NSString *param = [NSString stringWithFormat:@"userId=%@&roomId=%@",[ModelManager shareInterface].loginInfoModel.userId,[ModelManager shareInterface].createRoomInfoModel.roomId];
    [[DownLoadManager shareInterface] postddByByUrlPath:dissolveRoom_api andParams:param andHUD:nil andCallBack:^(id obj) {
        if ([[obj objectForKey:@"code"] isEqualToString:@"0"])  {
         hud.label.text=@"解散成功";
            [hud hideAnimated:YES afterDelay:1];
            [self closeTimer];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else{
            hud.label.text=[obj objectForKey:@"message"];
            [hud hideAnimated:YES afterDelay:1];
        }
    }];
}
- (IBAction)buyGold:(UIButton *)sender {
    buyGold *bGVC = [[NSBundle mainBundle]loadNibNamed:@"buyGold" owner:nil options:nil].lastObject;
    bGVC.frame=CGRectMake(0,0,0.7*self.view.frame.size.width,0.7*self.view.frame.size.height);
    bGVC.center=CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height/2);
    [self.view addSubview:bGVC];
}
- (IBAction)startGame:(UIButton *)sender {
    [self closeTimer];
    NSString *param = [NSString stringWithFormat:@"userId=%@&roomId=%@&gameTimes=%@",[ModelManager shareInterface].loginInfoModel.userId,[ModelManager shareInterface].createRoomInfoModel.roomId,[NSString stringWithFormat:@"%d",[ModelManager shareInterface].gameTimes]];
    
    [[DownLoadManager shareInterface] postddByByUrlPath:startGame_api andParams:param andHUD:nil andCallBack:^(id obj) {
        if ([[obj objectForKey:@"code"] isEqualToString:@"0"]) {
        
        [ModelManager shareInterface].gameTimes++;
        searchTimer=[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(CheckOwnerGameInfo) userInfo:nil repeats:YES];
        _startButton.userInteractionEnabled=NO;
            [self startAnimation];
        }
    }];
}
-(void)startAnimation
{
    _diceImageView.hidden=NO;
    NSMutableArray *images = [[NSMutableArray alloc]initWithCapacity:6];//因为这个动态图片是由6张图片组成所有把图片放到一个数组中
    for (int i=0; i<6; i++) {
        NSString *imageName = [NSString stringWithFormat:@"%d",i+101];//for循环依次把图片取出 这里我的图片名为1 － %d为i的值
        UIImage *image = [UIImage imageNamed:imageName];
        [images addObject:image];
    }
    //给imageView 制定了一组用于做动画的图片
    _diceImageView.animationImages = images;
    
    //动画的总时长(一组动画坐下来的时间 6张图片显示一遍的总时间)
    _diceImageView.animationDuration = 1;
    _diceImageView.animationRepeatCount = 3;//动画进行几次结束
    [_diceImageView startAnimating];//开始动画
    [self performSelector:@selector(AfterDelay) withObject:nil afterDelay:3];
}
-(void)AfterDelay{
    _diceImageView.hidden=YES;
    _startButton.userInteractionEnabled=YES;
    ownerNoticeView *ONV = [[NSBundle mainBundle]loadNibNamed:@"ownerNoticeView" owner:nil options:nil].lastObject;
    ONV.diceNumber.text=[NSString stringWithFormat:@"骰子点数:%@",[ModelManager shareInterface].ownerGameInfo.gameResult];
    ONV.frame=CGRectMake(0,0,0.7*self.view.frame.size.width,0.7*self.view.frame.size.height);
    ONV.center=CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height/2);
    [self.view addSubview:ONV];
}
-(void)CheckOwnerGameInfo
{
    [ModelManager shareInterface].ownerGameInfo= [[OwnerGameInfo alloc]init];
    NSString *param = [NSString stringWithFormat:@"userId=%@&roomId=%@",[ModelManager shareInterface].loginInfoModel.userId,[ModelManager shareInterface].createRoomInfoModel.roomId];
    [[DownLoadManager shareInterface] postddByByUrlPath:GameCheck_api andParams:param andHUD:nil andCallBack:^(id obj) {
        if ([[obj objectForKey:@"code"] isEqualToString:@"0"]) {
    [[ModelManager shareInterface].ownerGameInfo setValuesForKeysWithDictionary:[obj objectForKey:@"result"]];
    [self setGameInfo];
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
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
