//
//  createRoomInfoManager.h
//  guwangyule
//
//  Created by Jeremy on 2017/9/6.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface createRoomInfoManager : NSObject
+(createRoomInfoManager*)shareInterface;
@property(nonatomic,strong)NSString *diamondcount;
@property(nonatomic,strong)NSString *goldcount;
@property(nonatomic,strong)NSString *userid;
@property(nonatomic,strong)NSString *logo;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *roomId;
@end
