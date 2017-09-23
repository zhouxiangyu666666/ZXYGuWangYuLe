//
//  MainViewController.m
//  guwangyule
//
//  Created by Jeremy on 2017/9/1.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "MainViewController.h"
#import "ModelManager.h"
#import "NoticeView.h"
#import "createRoom.h"
#import "EnterRoom.h"
#import "quitGame.h"
#import <UIImageView+WebCache.h>
#import "DownLoadManager.h"
#import "ApiManager.h"
#import "SearchUserInfo.h"
@interface MainViewController ()

@property (strong, nonatomic) IBOutlet UILabel *noticeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *lightImageView;
@property (weak, nonatomic) IBOutlet UIImageView *horseLamp;
@property (strong, nonatomic) IBOutlet UIImageView *topLightImageView;
@property (strong, nonatomic) IBOutlet UILabel *diamondLabel;
@property (strong, nonatomic) IBOutlet UILabel *goldLabel;
@property (strong, nonatomic) IBOutlet UIImageView *headerImageView;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *userIdLabel;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUserInfo];
    diamondNumber = [[ModelManager shareInterface].loginInfoModel.diamondCount intValue];
    [self performSelector:@selector(anmationForNoticeLabel) withObject:nil afterDelay:1];
    [self performSelector:@selector(anmationForLight) withObject:nil afterDelay:1];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(turnToCreateRoomVC) name:@"createRoom" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(turnToAddRoomVC) name:@"addRoom" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(quitGame) name:@"quitGame" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginHorseLamp) name:@"beginHorseLamp" object:nil];
}
-(void)setUserInfo
{
    
    _userNameLabel.text=[ModelManager shareInterface].loginInfoModel.userName;

    _userIdLabel.text=[NSString stringWithFormat:@"ID:%@",[ModelManager shareInterface].loginInfoModel.userId];
    
    NSString *headerDiamond = [NSString stringWithFormat:@"%@",[ModelManager shareInterface].loginInfoModel.diamondCount];
    NSString *headerGold = [NSString stringWithFormat:@"%@",[ModelManager shareInterface].loginInfoModel.goldCount];
    
    if (headerDiamond.length>9) {
        _diamondLabel.text=[NSString stringWithFormat:@"%@...",[headerDiamond substringToIndex:9]];
    }
    else{
        _diamondLabel.text=headerDiamond;
    }
    
    if (headerGold.length>9) {
        _goldLabel.text=[NSString stringWithFormat:@"%@...",[headerGold substringToIndex:9]];
    }
    else{
        _goldLabel.text=headerGold;
    }
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:[ModelManager shareInterface].loginInfoModel.userLogo] placeholderImage:[UIImage imageNamed:@"toux"]];
}
-(void)anmationForNoticeLabel{
    self.horseLamp.clipsToBounds=YES;
    [self.horseLamp addSubview:self.noticeLabel];
    self.noticeLabel.center = CGPointMake(self.horseLamp.frame.size.width+self.noticeLabel.frame.size.width/2, self.horseLamp.frame.size.height/2);
    [UIView animateWithDuration:10 animations:^{
        self.noticeLabel.center = CGPointMake(-self.noticeLabel.frame.size.width/2, self.horseLamp.frame.size.height/2);
    } completion:^(BOOL finished) {
        if (finished) {
            [self anmationForNoticeLabel];
        }
    }];
}
-(void)anmationForLight{
    self.lightImageView.center=CGPointMake(self.lightImageView.frame.size.width/2+self.view.frame.size.width,self.horseLamp.frame.origin.y-4);
    self.topLightImageView.center=CGPointMake(-self.topLightImageView.frame.size.width, self.view.frame.size.height-50);
    [UIView animateWithDuration:5 animations:^{
        self.lightImageView.center=CGPointMake(-self.lightImageView.frame.size.width/2,self.horseLamp.frame.origin.y-4);
        self.topLightImageView.center=CGPointMake(self.lightImageView.frame.size.width/2+self.view.frame.size.width,self.view.frame.size.height-25);
    } completion:^(BOOL finished) {
        if (finished) {
            [self anmationForLight];
        }
    }];

}
- (IBAction)buyDiamond:(UIButton *)sender {
    NoticeView *bDVC = [[NSBundle mainBundle]loadNibNamed:@"NoticeView" owner:nil options:nil].lastObject;
    bDVC.noticeLabel.text=@"充值钻石请联系客服微信:18559576442";
    [self showViewWithName:bDVC];
}
- (IBAction)buyGold:(UIButton *)sender {
    NoticeView *bGVC = [[NSBundle mainBundle]loadNibNamed:@"NoticeView" owner:nil options:nil].lastObject;
    bGVC.noticeLabel.text=@"充值金币请联系客服微信:18559576442";
    [self showViewWithName:bGVC];
}
- (IBAction)quit:(UIButton *)sender {
    quitGame *qRVC = [[NSBundle mainBundle]loadNibNamed:@"quitGame" owner:nil options:nil].lastObject;
    [self showViewWithName:qRVC];
}
- (IBAction)createRoom:(UIButton *)sender {
    
    if (diamondNumber>10) {
        createRoom *cRVC = [[NSBundle mainBundle]loadNibNamed:@"createRoom" owner:nil options:nil].lastObject;

        [self showViewWithName:cRVC];
    }
    else{
        NoticeView *NVC = [[NSBundle mainBundle]loadNibNamed:@"NoticeView" owner:nil options:nil].lastObject;
        NVC.noticeLabel.text=@"钻石不足,请充值。";
        [self showViewWithName:NVC];
    }
}
- (IBAction)enterRoom:(UIButton *)sender {
    EnterRoom *eRVC = [[NSBundle mainBundle]loadNibNamed:@"EnterRoom" owner:nil options:nil].lastObject;
    [self showViewWithName:eRVC];
}
-(void)showViewWithName:(UIView *)showView{
    showView.frame=CGRectMake(0, 0, 0.7*self.view.frame.size.width, 0.7*self.view.frame.size.height);
    showView.center=CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height/2);
    [self.view addSubview:showView];
}
-(void)turnToCreateRoomVC
{
    diamondNumber=diamondNumber-10;
    NSString *headerDiamond = [NSString stringWithFormat:@"%d",diamondNumber];
    if (headerDiamond.length>9) {
        _diamondLabel.text=[NSString stringWithFormat:@"%@...",[headerDiamond substringToIndex:9]];
    }
    else{
        _diamondLabel.text=headerDiamond;
    }
    [self performSegueWithIdentifier:@"createRoom" sender:self];
}
-(void)turnToAddRoomVC
{
    [self performSegueWithIdentifier:@"addRoom" sender:self];
}
-(void)quitGame
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)refresh:(UIButton *)sender {
    
    [ModelManager shareInterface].searchUserInfo=[[SearchUserInfo alloc]init];
    NSString *param = [NSString stringWithFormat:@"userId=%@",[ModelManager shareInterface].loginInfoModel.userId];
    [[DownLoadManager shareInterface] postddByByUrlPath:searchUserInfo_api andParams:param andHUD:nil andCallBack:^(id obj) {
        if ([[obj objectForKey:@"code"] isEqualToString:@"0"]) {
            [[ModelManager shareInterface].searchUserInfo setValuesForKeysWithDictionary:[obj objectForKey:@"result"]];
            [self refreshUserInfo];
        }
    }];
}
-(void)refreshUserInfo
{
    _diamondLabel.text=[NSString stringWithFormat:@"%@",[ModelManager shareInterface].searchUserInfo.diamondCount];
    _goldLabel.text=[NSString stringWithFormat:@"%@",[ModelManager shareInterface].searchUserInfo.goldCount];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
