//
//  createRoomInfoManager.m
//  guwangyule
//
//  Created by Jeremy on 2017/9/6.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "createRoomInfoManager.h"

@implementation createRoomInfoManager
+(createRoomInfoManager*)shareInterface
{
    static createRoomInfoManager* _shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareManager=[[createRoomInfoManager alloc]init];
    });
    return _shareManager;
}
@end
