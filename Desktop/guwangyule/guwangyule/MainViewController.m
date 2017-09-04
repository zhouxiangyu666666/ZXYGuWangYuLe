//
//  MainViewController.m
//  guwangyule
//
//  Created by Jeremy on 2017/9/1.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()
@property (nonatomic,strong)UILabel *noticeLabel;
@property (nonatomic,strong)UIImageView *lightImageView;
@property (weak, nonatomic) IBOutlet UIImageView *horseLamp;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setMyNoticeLabel];
    [self setLight];
}
-(void)setLight
{

    
}
-(void)setMyNoticeLabel
{
    self.noticeLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0,440,21)];
    self.noticeLabel.font=[UIFont systemFontOfSize:14];
    self.noticeLabel.center = CGPointMake(self.horseLamp.frame.size.width+self.noticeLabel.frame.size.width/2, self.horseLamp.frame.size.height/2);
    self.noticeLabel.text=@"[股王娱乐]:代理咨询微信:shaiwangdongniu,请大家文明游戏,禁止赌博";
    self.noticeLabel.textColor=[UIColor whiteColor];
    self.horseLamp.clipsToBounds=YES;
    [self.horseLamp addSubview:self.noticeLabel];
    [self anmationForNoticeLabel];
}
-(void)anmationForNoticeLabel{
    self.noticeLabel.center = CGPointMake(self.horseLamp.frame.size.width+self.noticeLabel.frame.size.width/2, self.horseLamp.frame.size.height/2);
    [UIView animateWithDuration:10 animations:^{
        self.noticeLabel.center = CGPointMake(-self.noticeLabel.frame.size.width/2, self.horseLamp.frame.size.height/2);
    } completion:^(BOOL finished) {
        if (finished) {
            [self anmationForNoticeLabel];
        }
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
