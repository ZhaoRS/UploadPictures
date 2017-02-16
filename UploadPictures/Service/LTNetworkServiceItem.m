//
//  LTNetworkServiceItem.m
//  LandTools
//
//  Created by 赵瑞生 on 2017/2/9.
//  Copyright © 2017年 赵瑞生. All rights reserved.
//

#import "LTNetworkServiceItem.h"

@implementation LTNetworkServiceItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.parameters = [[NSMutableDictionary alloc] initWithCapacity:0];
        self.method = @"POST";
    }
    return self;
}

@end
