//
//  UpLoadViewController.h
//  LandTools
//
//  Created by 赵瑞生 on 2017/1/19.
//  Copyright © 2017年 赵瑞生. All rights reserved.
//

#import "LQPhotoPickerViewController.h"



@interface UpLoadViewController : LQPhotoPickerViewController

@property (nonatomic, strong) UIScrollView *scrollView;

@property(nonatomic,strong) UIView *noteTextBackgroudView;
//备注
@property(nonatomic,strong) UITextView *noteTextView;

//文字个数提示label
@property(nonatomic,strong) UILabel *textNumberLabel;

//文字说明
@property(nonatomic,strong) UILabel *explainLabel;

//提交按钮
@property(nonatomic,strong) UIButton *submitBtn;

@property (nonatomic, strong) NSDictionary *userInfoDict;


@end
