//
//  UpLoadViewController.m
//  LandTools
//
//  Created by 赵瑞生 on 2017/1/19.
//  Copyright © 2017年 赵瑞生. All rights reserved.
//
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height//获取设备高度
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width//获取设备宽度


#import "UpLoadViewController.h"
#import "LBAddressPickerView.h"
#import "LQPhotoViewCell.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "LTNetworkService.h"
#import "NSDictionary+LBSafeObject.h"


@interface UpLoadViewController ()<LQPhotoPickerViewDelegate, UITextViewDelegate, UITextFieldDelegate>
{
    //备注文本View高度
    float noteTextHeight;
    float pickerViewHeight;
    float allViewHeight;
    
    LBAreaItem *currentAreaItem;
    NSMutableString *_responseFileString;
}

@property (nonatomic, strong) LBAddressPickerView *pickerView;
@property (strong, nonatomic) IBOutlet UIView *addressView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (strong, nonatomic) IBOutlet UIView *marketView;
@property (weak, nonatomic) IBOutlet UITextField *marketTextField;
@property (strong, nonatomic) IBOutlet UIView *noteView;
@property (strong, nonatomic) IBOutlet UIView *shopView;
@property (weak, nonatomic) IBOutlet UITextField *shopTextField;


@property (nonatomic, strong) LBAddressPickerView *addressPkView;



@end

@implementation UpLoadViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _responseFileString = [[NSMutableString alloc] initWithCapacity:0];
    //收起键盘
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
    
    /**
     *  依次设置
     */
    self.LQPhotoPicker_superView = self.scrollView;
    
    self.LQPhotoPicker_imgMaxCount = 10;
    
    [self LQPhotoPicker_initPickerView];
    
    self.LQPhotoPicker_delegate = self;
    
    
    
    [self initViews];
    
    [self.scrollView addSubview:self.pickerView];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64 - 30)];
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
    
}
- (LBAddressPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[LBAddressPickerView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH - 64, SCREENHEIGHT)];
    }
    return _pickerView;
}

- (void)viewTapped{
    [self.view endEditing:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"caseLogNeedRef" object:nil];
}

-(void)dismissKeyBoard
{
    [self.noteTextView resignFirstResponder];
    [self.marketTextField resignFirstResponder];
    [self.shopTextField resignFirstResponder];
}

- (void)initViews{
    
    
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, AI_SCREEN_WIDTH, 40)];
    [topView setBarStyle:UIBarStyleDefault];
    
    
    
    
    
    
    
    _noteTextBackgroudView = [[UIView alloc]init];
    _noteTextBackgroudView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    
    _noteTextView = [[UITextView alloc]init];
    _noteTextView.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    _noteTextView.delegate = self;
    _noteTextView.layer.borderColor = [UIColor grayColor].CGColor;
    _noteTextView.layer.borderWidth = 0.5;
    _noteTextView.font = [UIFont boldSystemFontOfSize:14];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * doneButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(dismissKeyBoard)];
    
    
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneButtonItem,nil];
    [self.noteTextView setInputAccessoryView:topView];
    [self.marketTextField setInputAccessoryView:topView];
    [self.shopTextField setInputAccessoryView:topView];
    [topView setItems:buttonsArray];
    _textNumberLabel = [[UILabel alloc]init];
    _textNumberLabel.textAlignment = NSTextAlignmentRight;
    _textNumberLabel.font = [UIFont boldSystemFontOfSize:12];
    _textNumberLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    _textNumberLabel.backgroundColor = [UIColor whiteColor];
    _textNumberLabel.text = @"0/300    ";
    
    _explainLabel = [[UILabel alloc]init];
    _explainLabel.text = @"添加图片不超过10张，文字备注不超过300字";
    _explainLabel.textColor = [UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:199.0/255.0 alpha:1.0];
    _explainLabel.textAlignment = NSTextAlignmentCenter;
    _explainLabel.font = [UIFont boldSystemFontOfSize:12];
    

    [_noteView addSubview:_noteTextView];
    [_scrollView addSubview:_addressView];
    [_scrollView addSubview:_marketView];
    [_scrollView addSubview:_noteView];
    [_scrollView addSubview:_shopView];
//    [_scrollView addSubview:_textNumberLabel];
//    [_scrollView addSubview:_explainLabel];
//    [_scrollView addSubview:_submitBtn];
    
    [self updateViewsFrame];
}
- (void)updateViewsFrame{
    
    if (!allViewHeight) {
        allViewHeight = 0;
    }
    
    if (!noteTextHeight) {
        noteTextHeight = 100;
    }
    
    
    
    //photoPicker
    [self LQPhotoPicker_updatePickerViewFrameY:_textNumberLabel.frame.origin.y + _textNumberLabel.frame.size.height];
    
    _addressView.frame = CGRectMake(0, [self LQPhotoPicker_getPickerViewFrame].origin.y+[self LQPhotoPicker_getPickerViewFrame].size.height + 10, SCREENWIDTH, 44);
    _marketView.frame = CGRectMake(0, _addressView.frame.size.height + _addressView.frame.origin.y, SCREENWIDTH, 44);
    
    _shopView.frame = CGRectMake(0, _marketView.frame.size.height + _marketView.frame.origin.y, SCREENWIDTH, 44);
    
    _noteView.frame = CGRectMake(0, _shopView.frame.size.height + _shopView.frame.origin.y, SCREENWIDTH, noteTextHeight);
    _noteTextView.frame = CGRectMake(15, 10, SCREENWIDTH - 30, noteTextHeight);
    allViewHeight =  [self LQPhotoPicker_getPickerViewFrame].size.height + 30 + 100 ;
    
    _scrollView.contentSize = self.scrollView.contentSize = CGSizeMake(0,allViewHeight + 3*44 + noteTextHeight + 30);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    _textNumberLabel.text = [NSString stringWithFormat:@"%lu/300    ",(unsigned long)_noteTextView.text.length];
    if (_noteTextView.text.length > 300) {
        _textNumberLabel.textColor = [UIColor redColor];
    }
    else{
        _textNumberLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    }
    
    [self textChanged];
    return YES;
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    _textNumberLabel.text = [NSString stringWithFormat:@"%lu/300    ",(unsigned long)_noteTextView.text.length];
    if (_noteTextView.text.length > 300) {
        _textNumberLabel.textColor = [UIColor redColor];
    }
    else{
        _textNumberLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    }
    [self textChanged];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.scrollView.contentOffset = CGPointMake(0, _noteView.frame.origin.y);
    
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.scrollView.contentOffset = CGPointMake(0, 0);
}

-(void)textChanged{
    
    CGRect orgRect = self.noteTextView.frame;//获取原始UITextView的frame
    
    CGSize size = [self.noteTextView sizeThatFits:CGSizeMake(self.noteTextView.frame.size.width, MAXFLOAT)];
    
    orgRect.size.height=size.height+10;//获取自适应文本内容高度
    
    if (orgRect.size.height > 100) {
        noteTextHeight = orgRect.size.height;
    }
    [self updateViewsFrame];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.scrollView.contentOffset = CGPointMake(0, _addressView.frame.origin.y);
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.scrollView.contentOffset = CGPointMake(0, 0);
}

- (void)submitBtnClicked{
    
    if (![self checkInput]) {
        return;
    }
    [self submitToServer];
}

#pragma maek - 检查输入
- (BOOL)checkInput{
    if (_addressLabel.text.length == 0 ||_marketTextField.text.length == 0) {
        
        return NO;
    }
    return YES;
}


#pragma mark - 上传数据到服务器前将图片转data（上传服务器用form表单：未写）
- (void)submitToServer{
    NSMutableArray *bigImageArray = [self LQPhotoPicker_getBigImageArray];
    //大图数据
    NSMutableArray *bigImageDataArray = [self LQPhotoPicker_getBigImageDataArray];
    
    //小图数组
    NSMutableArray *smallImageArray = [self LQPhotoPicker_getSmallImageArray];
    
    //小图数据
    NSMutableArray *smallImageDataArray = [self LQPhotoPicker_getSmallDataImageArray];
    
    NSMutableArray *imageDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self showLoadingHUD];
    
    dispatch_group_t group = dispatch_group_create();
     dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    
        for (int i = 0; i < bigImageArray.count ; i ++) {
            UIImage *image = bigImageArray[i];
            dispatch_group_enter(group);
            NSData* imageData = UIImageJPEGRepresentation(image, 0.5);
            dispatch_group_async(group, queue, ^{
                
            LQPhotoViewCell *cell1 = (LQPhotoViewCell *)[self.pickerCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                
            MBProgressHUD *mbHUD = [[MBProgressHUD alloc] initWithView:cell1];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                                [cell1 addSubview:mbHUD];
                
                                //如果设置此属性则当前的view置于后台
                                mbHUD.dimBackground = YES;
                                [mbHUD showAnimated:YES];
                                
                                
                                
                            });
                DLog(@"我爱你");
                [self loadImageData:imageData HUD:mbHUD andgroup:group];
            });
        }

    
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        DLog(@"_responseFileString  ====   %@", _responseFileString);
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithCapacity:0];
        [parameters setObject:_shopTextField.text forKey:@"shopName"];
        [parameters setObject:_marketTextField.text forKey:@"market"];
        [parameters setObject:currentAreaItem.province forKey:@"provinceName"];
        [parameters setObject:currentAreaItem.city forKey:@"cityName"];
        [parameters setObject:currentAreaItem.area forKey:@"districtName"];
        NSUserDefaults *user =[NSUserDefaults standardUserDefaults];
        NSString *userName = [user objectForKey:@"name"];
        [user synchronize];
        [parameters setObject:userName forKey:@"pusher"];
        if (_noteTextView.text.length > 0) {
            [parameters setObject:_noteTextView.text forKey:@"mark"];
        }
        
        [[LTNetworkService shareManager] postJSONWithUrl:@"p/push/savePushInfo" parameters:parameters success:^(NSURLSessionDataTask *dataTask, id responseObject) {
            
//            [self.navigationController popViewControllerAnimated:YES];
            
        } fail:^(NSURLSessionDataTask *dataTask, NSError *error) {
            
        
            
        } netWorkStatus:^(NSInteger status) {
            
        }];
        
        
    });
    
    
    
    
    
}


- (void)loadImageData:(NSData *)imageData HUD:(MBProgressHUD *)mbHUD andgroup:(dispatch_group_t)group {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
     manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSString *urlStr = [NSString stringWithFormat:@"%@upload/uploadFileLimitSize", LBDOMAIN];
    [manager POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        //上传的参数(上传图片，以文件流的格式)
        [formData appendPartWithFileData:imageData
                                    name:@"photo"
                                fileName:fileName
                                mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [mbHUD removeFromSuperview];
        dispatch_group_leave(group);
        NSString *dataString = [responseObject safeObjectForKey:@"data"];
        _responseFileString = [NSMutableString stringWithFormat:@"%@", dataString];
        if (_responseFileString.length == 0) {
            _responseFileString = [NSMutableString stringWithString:dataString];
        } else {
            _responseFileString = [NSMutableString stringWithFormat:@"%@,%@", _responseFileString, dataString];
        }
        
        DLog(@"%@", responseObject);
        DLog(@"%@", _responseFileString);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [mbHUD removeFromSuperview];
        
//        [self.navigationController popViewControllerAnimated:YES];
    }];

}


- (void)LQPhotoPicker_pickerViewFrameChanged{
    [self updateViewsFrame];
}
- (IBAction)showAddressAction:(id)sender {
    
    LBAddressPickerView *pickerView = [[LBAddressPickerView alloc] init];
    [pickerView show];
    
    pickerView.confirmBlock = ^(LBAreaItem *item){
        DLog(@"%@    %@    %@",item.province,item.city,item.area);
        currentAreaItem = item;
        if ([item.city isEqualToString:@"市辖区"] || [item.city isEqualToString:@"县"]) {
            _addressLabel.text = [NSString stringWithFormat:@"%@ %@",item.province,item.area];
        } else {
            _addressLabel.text = [NSString stringWithFormat:@"%@ %@ %@",item.province,item.city,item.area];
        }
        
    };
    

}

- (IBAction)submitAction:(id)sender {
    
    if (![self checkInput]) {
        return;
    }
    [self submitToServer];
    
    
    
}

@end
