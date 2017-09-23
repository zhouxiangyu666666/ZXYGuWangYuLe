//
//  CreateRoomViewController.m
//  guwangyule
//
//  Created by Jeremy on 2017/9/6.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "CreateRoomViewController.h"
#import "NoticeView.h"
#import "ModelManager.h"
#import "DownLoadManager.h"
#import "ApiManager.h"
#import "OwnerGameInfo.h"
#import "ownerNoticeView.h"
#import <UIImageView+WebCache.h>
#import "dismissRoom.h"
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(certainDismissRoom) name:@"dismissRoom" object:nil];
    [ModelManager shareInterface].ownerGameInfo= [[OwnerGameInfo alloc]init];
    searchTimer=[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(CheckOwnerGameInfo) userInfo:nil repeats:YES];
    
    _diceImageView.hidden=YES;
    _roomNumber.text=[NSString stringWithFormat:@"房间号:%@",[ModelManager shareInterface].createRoomInfoModel.roomId];
    
    NSString *headerGold = [NSString stringWithFormat:@"%@",[ModelManager shareInterface].createRoomInfoModel.goldCount];
    
    if (headerGold.length>9) {
        _stakeNumber.text=[NSString stringWithFormat:@"%@...",[headerGold substringToIndex:9]];
    }
    else{
        _stakeNumber.text=headerGold;
    }
    
    _RoomHostName.text=[NSString stringWithFormat:@"%@",[ModelManager shareInterface].createRoomInfoModel.ownerName];
    _RoomHostID.text=[NSString stringWithFormat:@"ID:%@",[ModelManager shareInterface].createRoomInfoModel.ownerId];
    [_RoomHostHeader sd_setImageWithURL:[NSURL URLWithString:[ModelManager shareInterface].createRoomInfoModel.ownerLogo]placeholderImage:[UIImage imageNamed:@"fz"]];
    _previousDice.hidden=YES;
    [self changeRoomNumber];
}
-(void)setGameInfo
{
     _previousDice.hidden=NO;
    NSLog(@"-----%@",[ModelManager shareInterface].ownerGameInfo.gameTimes);
    
    _previousDice.text=[NSString stringWithFormat:@"上一期骰点:%@",[ModelManager shareInterface].ownerGameInfo.gameResult];
}

-(void)changeRoomNumber{
    _peopleNumber.text=[NSString stringWithFormat:@"人数:%@",[ModelManager shareInterface].createRoomInfoModel.memberCount];
}

- (IBAction)dismissRoom:(UIButton *)sender {
    dismissRoom *dMVC = [[NSBundle mainBundle]loadNibNamed:@"dismissRoom" owner:nil options:nil].lastObject;
    [self showViewWithName:dMVC];
}
-(void)certainDismissRoom
{
    [self closeTimer];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)buyGold:(UIButton *)sender {
    NoticeView *bGVC = [[NSBundle mainBundle]loadNibNamed:@"NoticeView" owner:nil options:nil].lastObject;
    bGVC.noticeLabel.text=@"充值金币请联系客服微信:18559576442";
    [self showViewWithName:bGVC];
}
- (IBAction)startGame:(UIButton *)sender {
    NSString *param = [NSString stringWithFormat:@"userId=%@&roomId=%@&gameTimes=%@",[ModelManager shareInterface].loginInfoModel.userId,[ModelManager shareInterface].createRoomInfoModel.roomId,[NSString stringWithFormat:@"%d",[[ModelManager shareInterface].ownerGameInfo.gameTimes intValue]+1]];
    
    [[DownLoadManager shareInterface] postddByByUrlPath:startGame_api andParams:param andHUD:nil andCallBack:^(id obj) {
        if ([[obj objectForKey:@"code"] isEqualToString:@"0"]) {
        
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
    [self showViewWithName:ONV];
    [self setGameInfo];
}
-(void)CheckOwnerGameInfo
{
    NSString *param = [NSString stringWithFormat:@"userId=%@&roomId=%@",[ModelManager shareInterface].loginInfoModel.userId,[ModelManager shareInterface].createRoomInfoModel.roomId];
    [[DownLoadManager shareInterface] postddByByUrlPath:GameCheck_api andParams:param andHUD:nil andCallBack:^(id obj) {
        if ([[obj objectForKey:@"code"] isEqualToString:@"0"]) {
    [[ModelManager shareInterface].ownerGameInfo setValuesForKeysWithDictionary:[obj objectForKey:@"result"]];
    [self changeRoomNumber];
        }
    }];
}
-(void)showViewWithName:(UIView *)showView{
    showView.frame=CGRectMake(0, 0, 0.7*self.view.frame.size.width, 0.7*self.view.frame.size.height);
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
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
