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
#import "MBProgressHUD.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(turnToMainVC) name:@"turnToMainVC" object:nil];
    
}
- (IBAction)weChatLoginClick:(UIButton *)sender {
     [[WeChatManager shareInterface] sendAuthRequest];
}
-(void)turnToMainVC
{
    [self performSegueWithIdentifier:@"turnToMainVC" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
