//
//  StakeViewController.m
//  guwangyule
//
//  Created by Jeremy on 2017/9/11.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "StakeViewController.h"

@interface StakeViewController ()

@end

@implementation StakeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}
- (IBAction)subtract:(UIButton *)sender {
    UILabel *superLabel = [self.view viewWithTag:sender.tag+100];
    if ([superLabel.text intValue]>0) {
        superLabel.text=[NSString stringWithFormat:@"%d",[superLabel.text intValue]-1];
    }
}
- (IBAction)add:(UIButton *)sender {
    UILabel *superLabel = [self.view viewWithTag:sender.tag-100];
    superLabel.text=[NSString stringWithFormat:@"%d",[superLabel.text intValue]+1];
}
- (IBAction)certain:(UIButton *)sender {
    
}
-(void)viewDidAppear:(BOOL)animated
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
