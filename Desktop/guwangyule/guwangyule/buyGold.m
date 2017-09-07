
//
//  buyGold.m
//  guwangyule
//
//  Created by Jeremy on 2017/9/5.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "buyGold.h"
@interface buyGold ()
@property (strong, nonatomic) IBOutlet UILabel *GoldLabel;
@property (nonatomic,assign)int GoldNumber;
@end
@implementation buyGold


- (IBAction)back:(UIButton *)sender {
    [self removeFromSuperview];
}
- (IBAction)subtract:(UIButton *)sender {
    if (_GoldNumber>0) {
        _GoldNumber--;
        _GoldLabel.text=[NSString stringWithFormat:@"%d",_GoldNumber];
    }
}
- (IBAction)add:(UIButton *)sender {
    _GoldNumber++;
    _GoldLabel.text=[NSString stringWithFormat:@"%d",_GoldNumber];
}
- (IBAction)weChatPay:(UIButton *)sender {
    
}

@end
