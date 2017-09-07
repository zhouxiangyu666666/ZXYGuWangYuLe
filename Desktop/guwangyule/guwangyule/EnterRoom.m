
//
//  EnterRoom.m
//  guwangyule
//
//  Created by Jeremy on 2017/9/5.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "EnterRoom.h"
@interface EnterRoom()
@property (strong, nonatomic) IBOutlet UITextField *roomNumber;

@end
@implementation EnterRoom

- (IBAction)certain:(UIButton *)sender {
    
}
- (IBAction)cancel:(UIButton *)sender {
    [self removeFromSuperview];
}

@end
