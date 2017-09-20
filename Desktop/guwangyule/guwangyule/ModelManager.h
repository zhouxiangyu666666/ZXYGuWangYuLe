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
#import "AddRoomInfo.h"
#import "RoomInfo.h"
#import "OwnerGameInfo.h"
#import "UserGameInfo.h"
@interface ModelManager : NSObject
@property(nonatomic,strong)CreateRoomInfo *createRoomInfoModel;
@property(nonatomic,strong)LoginInfo *loginInfoModel;
@property(nonatomic,strong)AddRoomInfo *addRoomInfo;
@property(nonatomic,strong)RoomInfo *roomInfo;
@property(nonatomic,strong)OwnerGameInfo *ownerGameInfo;
@property(nonatomic,strong)UserGameInfo *userGameInfo;
@property(nonatomic,assign)int gameTimes;
+(ModelManager*)shareInterface;
@end
