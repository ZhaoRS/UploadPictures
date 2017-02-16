//
//  ViewController.m
//  UploadPictures
//
//  Created by 赵瑞生 on 2017/2/16.
//  Copyright © 2017年 赵瑞生. All rights reserved.
//

#import "ViewController.h"
#import "UpLoadViewController.h"

@interface ViewController ()

@end

@implementation ViewController
- (IBAction)enterUploadView:(id)sender {
    
    UpLoadViewController *controller = [[UpLoadViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
