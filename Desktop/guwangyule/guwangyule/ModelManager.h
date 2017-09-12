//
//  ModelManager.h
//  guwangyule
//
//  Created by Jeremy on 2017/9/7.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CreateRoomInfo.h"
#import "LoginInfo.h"
@interface ModelManager : NSObject
@property(nonatomic,strong)CreateRoomInfo *createRoomInfoModel;
@property(nonatomic,strong)LoginInfo *loginInfoModel;
+(ModelManager*)shareInterface;
@end
