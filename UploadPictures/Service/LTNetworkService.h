//
//  LTNetworkService.h
//  LandTools
//
//  Created by 赵瑞生 on 2017/2/9.
//  Copyright © 2017年 赵瑞生. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LTNetworkServiceItem.h"

@interface LTNetworkService : NSObject

+ (instancetype)shareManager;


/**
 *  POST请求
 */


- (void)postJSONWithUrl:(NSString *)urlStr parameters:(id)parameters success:(void (^)(NSURLSessionDataTask * dataTask, id responseObject))success fail:(void (^)(NSURLSessionDataTask * dataTask, NSError * error))fail netWorkStatus:(void(^)(NSInteger status))statusChange;

@end
