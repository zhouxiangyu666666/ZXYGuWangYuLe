//
//  DownLoadManager.m
//  guwangyule
//
//  Created by Jeremy on 2017/8/31.
//  Copyright © 2017年 Macx. All rights reserved.


#import "DownLoadManager.h"
@implementation DownLoadManager
+(DownLoadManager*)shareInterface
{
    static DownLoadManager* _shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareManager=[[DownLoadManager alloc]init];
    });
    return _shareManager;
}
-(void)postddByByUrlPath:(NSString *)path andParams:(NSString*)params andHUD:(MBProgressHUD *)hud andCallBack:(CallBack)callback{
    
       NSURL *url=[NSURL URLWithString:path];
       NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:5];
       NSData *Paradata=[params  dataUsingEncoding:NSUTF8StringEncoding];
    
       [request setHTTPMethod:@"post"];
    
       [request setHTTPBody:Paradata];
    
       [request setTimeoutInterval:10];

        NSURLSession *session = [NSURLSession sharedSession];
    
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSLog(@"%@",error);
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
            NSLog(@"%ld",(long)httpResponse.statusCode);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error==nil&&httpResponse.statusCode==200) {
                    
                    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                    NSLog(@"%@",string);
                    
                    callback(dic);
                }
                else{
                    hud.labelText=@"网络连接失败";
                    [hud hide:YES afterDelay:1];
                }
            });
        }];
        //开始请求
        [task resume];
    
}

@end
