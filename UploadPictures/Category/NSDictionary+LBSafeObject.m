//
//  NSDictionary+LBSafeObject.m
//  LightBillionNet
//
//  Created by 赵瑞生 on 16/3/7.
//  Copyright © 2016年 ZRS. All rights reserved.
//

#import "NSDictionary+LBSafeObject.h"

@implementation NSDictionary (LBSafeObject)

- (id)safeObjectForKey:(id)key
{
    id result = [self objectForKey:key];
    
    if ([result isKindOfClass:[NSNull class]]) {
        return nil;
    }
    if ([result isKindOfClass:[NSNumber class]]) {
        return  [result stringValue];
    }
    return  result;
}

@end
