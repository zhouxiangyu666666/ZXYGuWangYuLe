//
//  CreateRoomViewController.m
//  guwangyule
//
//  Created by Jeremy on 2017/9/6.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "CreateRoomViewController.h"
#import "buyGold.h"
#import "createRoomInfoManager.h"
#import <UIImageView+WebCache.h>
@interface CreateRoomViewController ()
@property (strong, nonatomic) IBOutlet UILabel *roomNumber;
@property (strong, nonatomic) IBOutlet UILabel *previousDice;
@property (strong, nonatomic) IBOutlet UILabel *peopleNumber;
@property (strong, nonatomic) IBOutlet UIImageView *RoomHostHeader;
@property (strong, nonatomic) IBOutlet UILabel *RoomHostName;
@property (strong, nonatomic) IBOutlet UILabel *RoomHostID;
@property (strong, nonatomic) IBOutlet UILabel *stakeNumber;
@end

@implementation CreateRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _roomNumber.text=[NSString stringWithFormat:@"房间号:%@",[createRoomInfoManager shareInterface].roomId];
    _stakeNumber.text=[NSString stringWithFormat:@"%@",[createRoomInfoManager shareInterface].goldcount];
    _RoomHostName.text=[NSString stringWithFormat:@"%@",[createRoomInfoManager shareInterface].name];
    _RoomHostID.text=[NSString stringWithFormat:@"%@",[createRoomInfoManager shareInterface].userid];
    [_RoomHostHeader sd_setImageWithURL:[NSURL URLWithString:[createRoomInfoManager shareInterface].logo]placeholderImage:[UIImage imageNamed:@"fz"]];
    
}
- (IBAction)startGame:(UIButton *)sender {
    
}

- (IBAction)dismissRoom:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)buyGold:(UIButton *)sender {
    buyGold *bGVC = [[NSBundle mainBundle]loadNibNamed:@"buyGold" owner:nil options:nil].lastObject;
    bGVC.frame=CGRectMake(0,0,0.7*self.view.frame.size.width,0.7*self.view.frame.size.height);
    bGVC.center=CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height/2);
    [self.view addSubview:bGVC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end