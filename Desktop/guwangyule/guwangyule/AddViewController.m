//
//  AddViewController.m
//  guwangyule
//
//  Created by Jeremy on 2017/9/18.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "AddViewController.h"
#import "ApiManager.h"
#import "DownLoadManager.h"
#import "ModelManager.h"
#import "RoomInfo.h"
#import "AddRoomInfo.h"
#import <UIImageView+WebCache.h>
#import "UserGameInfo.h"
#import "userNoticeView.h"
#import "buyGold.h"
@interface AddViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *diceImageView;
@property (strong, nonatomic) IBOutlet UILabel *roomIdLabel;

@property (strong, nonatomic) IBOutlet UILabel *previousDiceLabel;

@property (strong, nonatomic) IBOutlet UIImageView *ownerLogo;
@property (strong, nonatomic) IBOutlet UIImageView *userLogo;

@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *userId;


@property (strong, nonatomic) IBOutlet UILabel *GoldLabel;
@property (strong, nonatomic) IBOutlet UILabel *peopleNumber;

@property (strong, nonatomic) IBOutlet UIButton *stakeBuuton;

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginTimer) name:@"beginTimer" object:nil];
    [self getInfoConfigue];
    [ModelManager shareInterface].userGameInfo=[[UserGameInfo alloc]init];
    searchTimer=[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(CheckUSerGameInfo) userInfo:nil repeats:YES];
}
-(void)getInfoConfigue
{
    [ModelManager shareInterface].roomInfo=[[RoomInfo alloc]init];
    NSString *param = [NSString stringWithFormat:@"userId=%@&roomId=%@",[ModelManager shareInterface].loginInfoModel.userId,[ModelManager shareInterface].addRoomInfo.roomId];
    [[DownLoadManager shareInterface] postddByByUrlPath:searchRoomInfo_api andParams:param andHUD:nil andCallBack:^(id obj) {
        NSLog(@"%@",obj);
    //KVO监听局数
    [[ModelManager shareInterface] addObserver:self forKeyPath:@"gameTimes" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [[ModelManager shareInterface].roomInfo setValuesForKeysWithDictionary:[obj objectForKey:@"result"]];
        
    [ModelManager shareInterface].gameTimes=[[ModelManager shareInterface].roomInfo.gameTimes intValue];
    [self setInfoConfigue];
    }];
}
//KVO回调方法
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"gameTimes"]) {
        if (!(change[NSKeyValueChangeOldKey]==change[NSKeyValueChangeNewKey])) {
            [self startAnimation];
        }
    }
}
-(void)setInfoConfigue{
    
    _roomIdLabel.text = [NSString stringWithFormat:@"房间号:%@",[ModelManager shareInterface].roomInfo.roomId];
    _userName.text=[NSString stringWithFormat:@"%@",[ModelManager shareInterface].roomInfo.userName];
    _userId.text=[NSString stringWithFormat:@"%@",[ModelManager shareInterface].roomInfo.userId];
    _GoldLabel.text=[NSString stringWithFormat:@"%@",[ModelManager shareInterface].roomInfo.userGoldCount];
    [_ownerLogo sd_setImageWithURL:[NSURL URLWithString:[ModelManager shareInterface].roomInfo.ownerLogo]placeholderImage:[UIImage imageNamed:@"fz"]];
    [_userLogo sd_setImageWithURL:[NSURL URLWithString:[ModelManager shareInterface].roomInfo.userLogo]placeholderImage:[UIImage imageNamed:@"fz"]];
    _peopleNumber.text=[NSString stringWithFormat:@"人数:%@/50",[ModelManager shareInterface].roomInfo.memberCount];
    
    
}
-(void)setRoomPeopleNumber
{
    _peopleNumber.text=[NSString stringWithFormat:@"人数:%@/50",[ModelManager shareInterface].userGameInfo.memberCount];
}
-(void)SetGamePreviousDice
{
//    [NSString stringWithFormat:@"%@"[ModelManager shareInterface].userGameInfo.gameResult];
//    _previousDiceLabel.text=[NSString stringWithFormat:@"上一期骰数:%@",];
}
-(void)startAnimation
{
    _stakeBuuton.userInteractionEnabled=NO;
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
    [self performSelector:@selector(AfterDelay1) withObject:nil afterDelay:3];
}
-(void)AfterDelay1{
    
//    UIView *lastView=[self.view viewWithTag:[ModelManager shareInterface].gameTimes-1];
//    if (lastView) {
//        [lastView removeFromSuperview];
//    }
    _diceImageView.hidden=YES;
    _stakeBuuton.userInteractionEnabled=YES;
    userNoticeView *UNV = [[NSBundle mainBundle]loadNibNamed:@"userNoticeView" owner:nil options:nil].lastObject;
    UNV.tag=[ModelManager shareInterface].gameTimes;
    UNV.resultGain.text=[NSString stringWithFormat:@"您的亏盈情况:%@",[ModelManager shareInterface].userGameInfo.resultGain];
    UNV.diceNumber.text=[NSString stringWithFormat:@"骰子点数:%@",[ModelManager shareInterface].userGameInfo.gameResult];
    UNV.frame=CGRectMake(0,0,0.7*self.view.frame.size.width,0.7*self.view.frame.size.height);
    UNV.center=CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height/2);
    [self.view addSubview:UNV];
    [self SetGamePreviousDice];
}

- (IBAction)quitRoom:(UIButton *)sender {

    NSString *param = [NSString stringWithFormat:@"userId=%@&roomId=%@",[ModelManager shareInterface].loginInfoModel.userId,[ModelManager shareInterface].addRoomInfo.roomId];
    [[DownLoadManager shareInterface] postddByByUrlPath:quitRoom_api andParams:param andHUD:nil andCallBack:^(id obj) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
}
-(void)CheckUSerGameInfo
{
    NSString *param = [NSString stringWithFormat:@"userId=%@&roomId=%@",[ModelManager shareInterface].loginInfoModel.userId,[ModelManager shareInterface].addRoomInfo.roomId];
    [[DownLoadManager shareInterface] postddByByUrlPath:GameCheck_api andParams:param andHUD:nil andCallBack:^(id obj) {
        if ([[obj objectForKey:@"code"] isEqualToString:@"0"]) {
    [[ModelManager shareInterface].userGameInfo setValuesForKeysWithDictionary:[obj objectForKey:@"result"]];
        }
    [ModelManager shareInterface].gameTimes=[[ModelManager shareInterface].userGameInfo.gameTimes intValue];
        [self setRoomPeopleNumber];
    }];
}
- (IBAction)buyGold:(UIButton *)sender {
    buyGold *bGVC = [[NSBundle mainBundle]loadNibNamed:@"buyGold" owner:nil options:nil].lastObject;
    bGVC.frame=CGRectMake(0,0,0.7*self.view.frame.size.width,0.7*self.view.frame.size.height);
    bGVC.center=CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height/2);
    [self.view addSubview:bGVC];
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

-(void)beginTimer
{
    searchTimer=[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(CheckUSerGameInfo) userInfo:nil repeats:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
