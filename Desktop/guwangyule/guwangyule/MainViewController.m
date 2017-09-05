//
//  MainViewController.m
//  guwangyule
//
//  Created by Jeremy on 2017/9/1.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@property (strong, nonatomic) IBOutlet UILabel *noticeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *lightImageView;
@property (weak, nonatomic) IBOutlet UIImageView *horseLamp;
@property (strong, nonatomic) IBOutlet UIImageView *topLightImageView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self anmationForNoticeLabel];
    [self anmationForLight];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
