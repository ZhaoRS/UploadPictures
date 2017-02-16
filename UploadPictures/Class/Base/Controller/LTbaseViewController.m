//
//  LTbaseViewController.m
//  LandTools
//
//  Created by 赵瑞生 on 2017/1/19.
//  Copyright © 2017年 赵瑞生. All rights reserved.
//

#import "LTbaseViewController.h"
#import "MBProgressHUD.h"

@interface LTbaseViewController ()

@property (nonatomic, strong) MBProgressHUD *HUD;

@end

@implementation LTbaseViewController

- (MBProgressHUD *)HUD {
    if (!_HUD) {
        _HUD = [[MBProgressHUD alloc] initWithView:self.view];
        //如果设置此属性则当前的view置于后台
        
        _HUD.dimBackground = YES;
        
        //设置对话框文字
        
        _HUD.label.text = @"请稍等";
    }
    return _HUD;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)showLoadingHUD {
    [self.view addSubview:self.HUD];
    [self.HUD showAnimated:YES];
    
}

- (void)removeLoadingHUD {
    [self.HUD removeFromSuperview];
}


@end
