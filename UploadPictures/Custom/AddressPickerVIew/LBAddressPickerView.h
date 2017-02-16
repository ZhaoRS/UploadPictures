//
//  LBAddressPickerView.h
//  LightBillionNet
//
//  Created by 赵瑞生 on 16/3/23.
//  Copyright © 2016年 ZRS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBAreaItem.h"

typedef void (^AddressChoicePickerViewBlock)(LBAreaItem *item);

@interface LBAddressPickerView : UIView

@property (copy, nonatomic)AddressChoicePickerViewBlock confirmBlock;
@property(nonatomic, strong) UIView *pickerView;


- (void)show;


@end
