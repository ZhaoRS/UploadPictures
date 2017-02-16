//
//  LTNetworkServiceItem.h
//  LandTools
//
//  Created by 赵瑞生 on 2017/2/9.
//  Copyright © 2017年 赵瑞生. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTNetworkServiceItem : NSObject
/**
 *  网络接口
 */
@property (nonatomic, copy) NSString *url;
/**
 *  请求成功
 */
@property (nonatomic, copy) NSString *method;
/**
 *  请求的参数
 */
@property (nonatomic, copy) NSMutableDictionary *parameters;

@end
