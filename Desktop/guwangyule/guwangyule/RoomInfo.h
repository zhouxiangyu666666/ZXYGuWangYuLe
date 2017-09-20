//
//  RoomInfo.h
//  guwangyule
//
//  Created by Jeremy on 2017/9/18.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RoomInfo : NSObject
@property (nonatomic,strong)NSString *roomId;
@property (nonatomic,strong)NSString *memberCount;
@property (nonatomic,strong)NSString *ownerId;
@property (nonatomic,strong)NSString *ownerName;
@property (nonatomic,strong)NSString *ownerLogo;
@property (nonatomic,strong)NSString *userId;
@property (nonatomic,strong)NSString *userName;
@property (nonatomic,strong)NSString *userLogo;
@property (nonatomic,strong)NSString *userType;
@property (nonatomic,strong)NSString *userGoldCount;
@property (nonatomic,strong)NSString *userDiamongCount;
@property (nonatomic,strong)NSString *gameTimes;
@property (nonatomic,strong)NSString *lastResult;

@end
