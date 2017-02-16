//
//  NSDictionary+LBSafeObject.h
//  LightBillionNet
//
//  Created by 赵瑞生 on 16/3/7.
//  Copyright © 2016年 ZRS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (LBSafeObject)

/**
 *  查找字典中是否有这个值
 */
- (id)safeObjectForKey:(id)key;


@end
