//
//  CommonDefine.h
//  LightBillionNet
//
//  Created by 赵瑞生 on 16/3/7.
//  Copyright © 2016年 ZRS. All rights reserved.
//

#ifndef CommonDefine_h
#define CommonDefine_h

#ifdef DEBUG
#define DLog(...) NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])
#define ALog(...) [[NSAssertionHandler currentHandler] handleFailureInFunction:[NSString stringWithCString:__PRETTY_FUNCTION__ encoding:NSUTF8StringEncoding] file:[NSString stringWithCString:__FILE__ encoding:NSUTF8StringEncoding] lineNumber:__LINE__ description:__VA_ARGS__]
#else
#define DLog(...) do { } while (0)
#endif

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define AI_SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define AI_SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height




//线上环境
#define LBDOMAIN @"http://www.baidu.ccom/"
#define LBIMAGEPATH @"http://www.baidu.ccom/"







#define VersionCode @"0"//API版本号



#define LBEDGEDISTANCE 12





#endif /* CommonDefine_h */
