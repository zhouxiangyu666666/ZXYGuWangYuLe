//
//  quitGame.m
//  guwangyule
//
//  Created by Jeremy on 2017/9/5.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "quitGame.h"

@implementation quitGame
- (IBAction)certain:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"quitGame" object:nil];
    [self removeFromSuperview];
}
- (IBAction)cancel:(UIButton *)sender {
    [self removeFromSuperview];
}


@end
