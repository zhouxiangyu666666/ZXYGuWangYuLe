//
//  NoticeView.m
//  guwangyule
//
//  Created by Jeremy on 2017/9/22.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "NoticeView.h"

@implementation NoticeView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.backgroundColor=[UIColor clearColor].CGColor;
    
}

- (IBAction)IKown:(UIButton *)sender {
    if ([self.noticeLabel.text isEqualToString:@"房间已解散"]) {
        [self removeFromSuperview];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"quitRoom" object:nil];
    }
    else{
    [self removeFromSuperview];
     }
    
}


@end
