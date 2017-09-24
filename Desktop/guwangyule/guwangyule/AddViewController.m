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
#import "NoticeView.h"
#import "quitRoom.h"
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

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _diceImageView.hidden=YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginTimer:) name:@"beginTimer" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(certainQuitRoom) name:@"quitRoom" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showDisRoomView) name:@"dissolveRoom" object:nil];
    [self getInfoConfigue];
    [ModelManager shareInterface].userGameInfo=[[UserGameInfo alloc]init];
}
-(void)getInfoConfigue
{
    [ModelManager shareInterface].roomInfo=[[RoomInfo alloc]init];
    NSString *param = [NSString stringWithFormat:@"userId=%@&roomId=%@",[ModelManager shareInterface].loginInfoModel.userId,[ModelManager shareInterface].addRoomInfo.roomId];
    [[DownLoadManager shareInterface] postddByByUrlPath:searchRoomInfo_api andParams:param andHUD:nil andCallBack:^(id obj) {

    [[ModelManager shareInterface].roomInfo setValuesForKeysWithDictionary:[obj objectForKey:@"result"]];
    [ModelManager shareInterface].gameTimes=[[ModelManager shareInterface].roomInfo.gameTimes intValue];
   
    
    [self setInfoConfigue];
    }];
}

-(void)setInfoConfigue{
    
    _roomIdLabel.text = [NSString stringWithFormat:@"房间号:%@",[ModelManager shareInterface].roomInfo.roomId];
    _userName.text=[NSString stringWithFormat:@"%@",[ModelManager shareInterface].roomInfo.userName];
    _userId.text=[NSString stringWithFormat:@"%@",[ModelManager shareInterface].roomInfo.userId];
    NSLog(@"%@",[ModelManager shareInterface].roomInfo.gameTimes);
    if ([[ModelManager shareInterface].roomInfo.gameTimes intValue]!=0) {
        _previousDiceLabel.text=[NSString stringWithFormat:@"上一期骰数:%@",[NSString stringWithFormat:@"%@",[ModelManager shareInterface].roomInfo.lastResult]];
    }
    NSString *headerGold = [NSString stringWithFormat:@"%@",[ModelManager shareInterface].roomInfo.userGoldCount];
    
    if (headerGold.length>9) {
        _GoldLabel.text=[NSString stringWithFormat:@"%@...",[headerGold substringToIndex:9]];
    }
    else{
        _GoldLabel.text=headerGold;
    }
    
    [_ownerLogo sd_setImageWithURL:[NSURL URLWithString:[ModelManager shareInterface].roomInfo.ownerLogo]placeholderImage:[UIImage imageNamed:@"fz"]];
    [_userLogo sd_setImageWithURL:[NSURL URLWithString:[ModelManager shareInterface].roomInfo.userLogo]placeholderImage:[UIImage imageNamed:@"fz"]];
    _peopleNumber.text=[NSString stringWithFormat:@"人数:%@",[ModelManager shareInterface].roomInfo.memberCount];
    //KVO监听局数
    [[ModelManager shareInterface] addObserver:self forKeyPath:@"gameTimes" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    searchTimer=[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(CheckUserGameInfo) userInfo:nil repeats:YES];
    
}

-(void)CheckUserGameInfo
{
    NSString *param = [NSString stringWithFormat:@"userId=%@&roomId=%@",[ModelManager shareInterface].loginInfoModel.userId,[ModelManager shareInterface].addRoomInfo.roomId];
    [[DownLoadManager shareInterface] postddByByUrlPath:GameCheck_api andParams:param andHUD:nil andCallBack:^(id obj) {
        
        if ([[obj objectForKey:@"code"] isEqualToString:@"0"]) {
            [[ModelManager shareInterface].userGameInfo setValuesForKeysWithDictionary:[obj objectForKey:@"result"]];
            if ([[ModelManager shareInterface].userGameInfo.roomState isEqualToString:@"1"]) {
                [self showDisRoomView];
            }
            else{
            [ModelManager shareInterface].gameTimes=[[ModelManager shareInterface].userGameInfo.gameTimes intValue];
            [self setRoomPeopleNumber];
            }
        }
    }];
}
-(void)showDisRoomView
{
    if (![self.view viewWithTag:2000000]) {
        NoticeView *UNV = [[NSBundle mainBundle]loadNibNamed:@"NoticeView" owner:nil options:nil].lastObject;
        UNV.tag=2000000;
        UNV.noticeLabel.text=@"房间已解散";
        [self showViewWithName:UNV];
    }
}
//KVO回调方法
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSLog(@"%@,%@",change[NSKeyValueChangeOldKey],change[NSKeyValueChangeNewKey]);
    if ([keyPath isEqualToString:@"gameTimes"]) {
        if (!(change[NSKeyValueChangeOldKey]==change[NSKeyValueChangeNewKey])) {
            [self startAnimation];
        }
    }
}

-(void)setRoomPeopleNumber
{
    _peopleNumber.text=[NSString stringWithFormat:@"人数:%@",[ModelManager shareInterface].userGameInfo.memberCount];
}
-(void)SetGamePreviousDice
{
    _previousDiceLabel.text=[NSString stringWithFormat:@"上一期骰数:%@",[NSString stringWithFormat:@"%@",[ModelManager shareInterface].userGameInfo.gameResult]];
}
-(void)setGoldCount
{
    NSString *headerGold = [NSString stringWithFormat:@"%@",[ModelManager shareInterface].userGameInfo.goldCount];
    
    if (headerGold.length>9) {
        _GoldLabel.text=[NSString stringWithFormat:@"%@...",[headerGold substringToIndex:9]];
    }
    else{
        _GoldLabel.text=headerGold;
    }
}
-(void)startAnimation
{
    UIView *lastView=[self.view viewWithTag:[ModelManager shareInterface].gameTimes+1000000-1];
    if (lastView) {
        [lastView removeFromSuperview];
    }
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
    
    _diceImageView.hidden=YES;
    userNoticeView *UNV = [[NSBundle mainBundle]loadNibNamed:@"userNoticeView" owner:nil options:nil].lastObject;
    UNV.tag=[ModelManager shareInterface].gameTimes+1000000;
    UNV.resultGain.text=[NSString stringWithFormat:@"您的亏盈情况:%@",[ModelManager shareInterface].userGameInfo.resultGain];
    UNV.diceNumber.text=[NSString stringWithFormat:@"骰子点数:%@",[ModelManager shareInterface].userGameInfo.gameResult];
    [self showViewWithName:UNV];
    [self SetGamePreviousDice];
    [self setGoldCount];
}

- (IBAction)quitRoom:(UIButton *)sender {
   quitRoom *QRV = [[NSBundle mainBundle]loadNibNamed:@"quitRoom" owner:nil options:nil].lastObject;
    [self showViewWithName:QRV];
}


- (IBAction)buyGold:(UIButton *)sender {
    NoticeView *bGVC = [[NSBundle mainBundle]loadNibNamed:@"NoticeView" owner:nil options:nil].lastObject;
    bGVC.noticeLabel.text=@"充值金币请联系客服微信:18559576442";
    [self showViewWithName:bGVC];
}
-(void)showViewWithName:(UIView *)showView{
    showView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    showView.center=CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height/2);
    [self.view addSubview:showView];
}

-(void)closeTimer
{
    [searchTimer invalidate];
    searchTimer = nil;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self closeTimer];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"beginHorseLamp" object:nil];
}

-(void)beginTimer:(NSNotification *)noti
{
    NSInteger newGoldCount=[[ModelManager shareInterface].userGameInfo.goldCount integerValue]-[noti.object integerValue];
    NSString *headerGold = [NSString stringWithFormat:@"%ld",(long)newGoldCount];
    
    if (headerGold.length>9) {
        _GoldLabel.text=[NSString stringWithFormat:@"%@...",[headerGold substringToIndex:9]];
    }
    else{
        _GoldLabel.text=headerGold;
    }
    searchTimer=[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(CheckUserGameInfo) userInfo:nil repeats:YES];
}
-(void)certainQuitRoom
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [[ModelManager shareInterface] removeObserver:self forKeyPath:@"gameTimes"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
