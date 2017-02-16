//
//  LBAreaItem.h
//  LightBillionNet
//
//  Created by 赵瑞生 on 16/3/23.
//  Copyright © 2016年 ZRS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBAreaItem : NSObject
/**
 *  区域
 */
@property (nonatomic, copy) NSString *region;
/**
 *  省
 */
@property (nonatomic, copy) NSString *province;
/**
 *  市
 */
@property (nonatomic, copy) NSString *city;
/**
 *  县
 */
@property (nonatomic, copy) NSString *area;

@end
