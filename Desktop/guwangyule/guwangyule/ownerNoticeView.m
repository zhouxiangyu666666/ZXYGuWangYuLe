//
//  ownerNoticeView.m
//  guwangyule
//
//  Created by Jeremy on 2017/9/19.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "ownerNoticeView.h"

@implementation ownerNoticeView
- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.backgroundColor=[UIColor clearColor].CGColor;    
}

- (IBAction)IKnow:(UIButton *)sender {
    [self removeFromSuperview];
}



@end
