//
//  LTNetworkService.m
//  LandTools
//
//  Created by 赵瑞生 on 2017/2/9.
//  Copyright © 2017年 赵瑞生. All rights reserved.
//

#import "LTNetworkService.h"
#import "AFNetworking.h"
#import "LTNetworkServiceItem.h"
#import "MBProgressHUD.h"
#import "NSDictionary+LBSafeObject.h"

@implementation LTNetworkService

+ (instancetype)shareManager
{
    static LTNetworkService *_shareManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _shareManager = [self alloc];
    });
    return _shareManager;
}

- (void)netWorkStatus
{
    /**
     AFNetworkReachabilityStatusUnknown          = -1,  // 未知
     AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
     AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G 花钱
     AFNetworkReachabilityStatusReachableViaWiFi = 2,   // WiFi
     */
    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
    }];
}


- (void)postJSONWithUrl:(NSString *)urlStr parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *, id))success fail:(void (^)(NSURLSessionDataTask *, NSError *))fail netWorkStatus:(void (^)(NSInteger))statusChange
{
    
    
    
    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (statusChange) {
            statusChange(status);
        }
    }];
    
    
    NSString *url = nil;
    url=[NSString stringWithFormat:@"%@%@",LBDOMAIN,urlStr];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [dict setObject:[[[UIDevice currentDevice] identifierForVendor] UUIDString] forKey:@"deviceId"];
    [dict setObject:@"iOS" forKey:@"deviceType"];
    
    [dict setObject:VersionCode forKey:@"versionCode"];
    
    
    DLog(@"url = %@  parameters === %@",url,dict);
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求格式
//        manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    //    //设置返回格式
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //设置超时时间
    //    [manager.requestSerializer willChangeValueForKey:@"timeOutInterval"];
    //    manager.requestSerializer.timeoutInterval = 10.f;
    //    [manager.requestSerializer didChangeValueForKey:@"timeOutInterval"];
    
    
    
    [manager POST:url parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        
           
            if (responseObject) {
                
                NSString* code=[responseObject safeObjectForKey:@"code"];
                NSString *msg = [responseObject safeObjectForKey:@"message"];
                if (code&&[code isEqualToString:@"0"]) {
                    if (msg && msg.length >  0) {
                       
                    }
                    success(task,[responseObject objectForKey:@"data"]);
                }else if ([code isEqualToString:@"4131"]){
                    
//                    [[LBUserManager shareManager] logou];
//                    [[LBUserManager shareManager] isLoginWithView];
                    NSError* error=[NSError errorWithDomain:@"123" code:[code integerValue] userInfo:nil];
                    fail(task,error);
                }
                else{
                    if ([responseObject isKindOfClass:[NSData class]]) {
                        DLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
                    }else{
                        DLog(@"%@",responseObject);
                    }
                    NSString* msg=[responseObject safeObjectForKey:@"message"];
                    if (msg&&[msg length]>0) {
                    }
                    NSError* error=[NSError errorWithDomain:@"123" code:[code integerValue] userInfo:nil];
                    fail(task,error);
                }
            }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        fail(task,error);
        DLog(@"%@",error);
        
        
    }];
    
}



@end
