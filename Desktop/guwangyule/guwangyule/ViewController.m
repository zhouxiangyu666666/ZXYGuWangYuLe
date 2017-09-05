//
//  ViewController.m
//  guwangyule
//
//  Created by Jeremy on 2017/8/31.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "ViewController.h"
#import "WeChatManager.h"
#import "ApiManager.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (IBAction)weChatLoginClick:(UIButton *)sender {
    [[WeChatManager shareInterface] sendAuthRequest];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
