//
//  userNoticeView.m
//  guwangyule
//
//  Created by Jeremy on 2017/9/19.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "userNoticeView.h"

@implementation userNoticeView
- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.backgroundColor=[UIColor clearColor].CGColor;
    
}
- (IBAction)IKnow:(UIButton *)sender {
    [self removeFromSuperview];
}


@end
