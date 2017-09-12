//
//  ModelManager.m
//  guwangyule
//
//  Created by Jeremy on 2017/9/7.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "ModelManager.h"

@implementation ModelManager
+(ModelManager*)shareInterface
{
    static ModelManager* _shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareManager=[[ModelManager alloc]init];
    });
    return _shareManager;
}
@end
