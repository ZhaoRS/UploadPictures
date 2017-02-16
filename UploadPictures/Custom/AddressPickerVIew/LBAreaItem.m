//
//  LBAreaItem.m
//  LightBillionNet
//
//  Created by 赵瑞生 on 16/3/23.
//  Copyright © 2016年 ZRS. All rights reserved.
//

#import "LBAreaItem.h"
#import "LBAreaItem.h"

@implementation LBAreaItem
- (NSString *)description{
    return [NSString stringWithFormat:@"%@ %@ %@ %@",self.region,self.province,self.city,self.area];
}
@end
