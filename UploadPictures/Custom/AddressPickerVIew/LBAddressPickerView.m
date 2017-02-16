//
//  LBAddressPickerView.m
//  LightBillionNet
//
//  Created by 赵瑞生 on 16/3/23.
//  Copyright © 2016年 ZRS. All rights reserved.
//


#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height//获取设备高度
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width//获取设备宽度

#define FITSCREEN (SCREENWIDTH/ 414.0)//适配屏幕

#import "LBAddressPickerView.h"

@interface LBAddressPickerView()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic, strong) NSLayoutConstraint *contentViewHightCons;

@property (nonatomic, strong) UIPickerView *dataPicker;

@property (nonatomic, strong) LBAreaItem *locate;
//区域 数组
@property (strong, nonatomic) NSArray *regionArr;
//省 数组
@property (strong, nonatomic) NSArray *provinceArr;
//城市 数组
@property (strong, nonatomic) NSArray *cityArr;
//区县 数组
@property (strong, nonatomic) NSArray *areaArr;

@property (nonatomic, copy) NSString *selectedProvince;

@property (nonatomic, strong) NSDictionary *areaDic;

@property (nonatomic, strong) LBAreaItem *item;


@end


@implementation LBAddressPickerView

- (instancetype)init
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        
        UIButton *bgButton = [UIButton buttonWithType: UIButtonTypeCustom];
        [bgButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        bgButton.frame = self.bounds;
        [self addSubview:bgButton];
        
        self.item = [[LBAreaItem alloc] init];
        
        self.pickerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 44 + 150 * FITSCREEN)];
        self.pickerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.pickerView];
        
        self.dataPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, SCREENWIDTH, 150 * FITSCREEN)];
        self.dataPicker.delegate = self;
        self.dataPicker.dataSource = self;
        self.dataPicker.showsSelectionIndicator = YES;
        [self.dataPicker selectRow:0 inComponent:0 animated:YES];
        [self.pickerView addSubview:self.dataPicker];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(10, 0, 60, 44);
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        [self.pickerView addSubview:cancelButton];
        
        UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmButton.frame = CGRectMake(SCREENWIDTH - 10 - 60, 0, 60, 44);
        [confirmButton setTitle:@"确认" forState:UIControlStateNormal];
        [confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [confirmButton addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
        [self.pickerView addSubview:confirmButton];
        
        self.areaDic = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"]];
//        NSBundle *bundle = [NSBundle mainBundle];
//        NSString *plistPath = [bundle pathForResource:@"area" ofType:@"plist"];
//        areaDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        NSArray *components = [_areaDic allKeys];
        NSArray *sortedArray = [components sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        NSMutableArray *proviceTmp = [[NSMutableArray alloc] initWithCapacity:0];
        for (int i = 0; i < [sortedArray count]; i ++) {
            NSString *index = [sortedArray objectAtIndex:i];
            NSArray *tmp = [[_areaDic objectForKey:index] allKeys];
            [proviceTmp addObject:[tmp objectAtIndex:0]];
        }
        
        self.provinceArr = [[NSArray alloc] initWithArray:proviceTmp];
        
        
        NSString *index = [sortedArray objectAtIndex:0];
        NSString *selected = [self.provinceArr objectAtIndex:0];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[[self.areaDic objectForKey:index] objectForKey:selected]];
        
        NSArray *cityArray = [dic allKeys];
        NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary:[dic objectForKey:[cityArray objectAtIndex:0]]];
        self.cityArr = [[NSArray alloc] initWithArray:[cityDic allKeys]];
        
        NSString *selectCity = [self.cityArr objectAtIndex:0];
        self.areaArr = [[NSArray alloc] initWithArray:[cityDic objectForKey:selectCity]];
        
        
        
        
    }
    return self;
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


#pragma mark -取消
- (void)cancel
{
    [UIView beginAnimations:@"hiddenView" context:NULL];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationDelegate:self];
    CGRect rect=self.pickerView.frame;
    rect.origin.y=SCREENHEIGHT;
    self.pickerView.frame=rect;
    [UIView setAnimationDidStopSelector:@selector(didStopCancelAnimation)];
    [UIView commitAnimations];
}
- (void)didStopCancelAnimation
{
    [self removeFromSuperview];
}

#pragma mark- 确认
- (void)confirm
{
    if (self.item.area.length > 0) {
        self.confirmBlock(self.item);
    }
    [self cancel];
}
- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [UIView beginAnimations:@"showView" context:NULL];
    [UIView setAnimationDuration:0.25];
    CGRect rect1=self.pickerView.frame;
    rect1.origin.y = SCREENHEIGHT - 44 - FITSCREEN * 150;
    self.pickerView.frame=rect1;
    [UIView commitAnimations];
    
    if (self.areaArr && [self.areaArr count] > 0) {
        [self pickerView:self.dataPicker didSelectRow:0 inComponent:0];
    }
}

#pragma mark -Picker Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return [self.provinceArr count];
    } else if (component == 1) {
        return [self.cityArr count];
    } else {
        return [self.areaArr count];
    }
}

#pragma mark- Picker Delegate Methods
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return [self.provinceArr objectAtIndex:row];
    } else if (component == 1) {
        return [self.cityArr objectAtIndex:row];
    } else {
        return [self.areaArr objectAtIndex:row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        self.selectedProvince = [self.provinceArr objectAtIndex:row];
        NSDictionary *tmp = [NSDictionary dictionaryWithDictionary:[self.areaDic objectForKey:[NSString stringWithFormat:@"%d",row]]];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[tmp objectForKey:self.selectedProvince]];
        NSArray *cityArray = [dic allKeys];
        NSArray *sortedArray = [cityArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
            
        }];
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (int i = 0; i < [sortedArray count]; i ++) {
            NSString *index = [sortedArray objectAtIndex:i];
            NSArray *temp = [[dic objectForKey:index] allKeys];
            [array addObject:[temp objectAtIndex:0]];
        }
        self.cityArr = [[NSArray alloc] initWithArray:array];
        
        NSDictionary *cityDic = [dic objectForKey:[sortedArray objectAtIndex:0]];
        self.areaArr = [[NSArray alloc] initWithArray:[cityDic objectForKey:[self.cityArr objectAtIndex:0]]];
        [self.dataPicker selectRow:0 inComponent:1 animated:YES];
        [self.dataPicker selectRow:0 inComponent:2 animated:YES];
        [self.dataPicker reloadComponent:1];
        [self.dataPicker reloadComponent:2];
        self.item.province = self.selectedProvince;
        self.item.city = self.cityArr[0];
        if (self.areaArr.count) {
            self.item.area = self.areaArr[0];
        } else {
            self.item.area = @"";
        }
        
        
    } else if (component == 1) {
        NSString *proviewceIndex = [NSString stringWithFormat:@"%d",[self.provinceArr indexOfObject:self.selectedProvince]];
        NSDictionary *tmp = [NSDictionary dictionaryWithDictionary:[self.areaDic objectForKey:proviewceIndex]];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[tmp objectForKey:self.selectedProvince]];
        NSArray *dicKeyArray = [dic allKeys];
        NSArray *sortedArray = [dicKeyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
            
        }];
        NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [sortedArray objectAtIndex: row]]];
        NSArray *cityKeyArray = [cityDic allKeys];
        self.areaArr = [[NSArray alloc] initWithArray:[cityDic objectForKey:[cityKeyArray objectAtIndex:0]]];
        [self.dataPicker selectRow:0 inComponent:2 animated:YES];
        [self.dataPicker reloadComponent:2];
        self.item.city = self.cityArr[row];
        if (self.areaArr.count > 0) {
            self.item.area = self.areaArr[0];
        } else {
            self.item.area = @"";
        }
    } else if (component == 2){
        if (!row) {
            row = 0;
        }
//        self.item.area = self.areaArr[row];
        self.item.area = [self.areaArr objectAtIndex:row];
    }

    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
//    if (component == 0) {
//        return 80  ;
//    } else if (component == 1){
//        return 100;
//    } else {
//        return 115;
//    }
    return 44;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *myView = nil;
    switch (component) {
        case 0:
        {
            myView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 78, 30)];
            myView.textAlignment = NSTextAlignmentCenter;
            myView.text = [self.provinceArr objectAtIndex:row];
            myView.font = [UIFont systemFontOfSize:14];
            myView.backgroundColor = [UIColor clearColor];
            [myView sizeToFit];
        }
            break;
            
        case 1:
        {
            myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 95, 30)];
            myView.textAlignment = NSTextAlignmentCenter;
            myView.text = [self.cityArr objectAtIndex:row];
            myView.font = [UIFont systemFontOfSize:14];
            myView.backgroundColor = [UIColor clearColor];
            [myView sizeToFit];
        }
            break;
            
        case 2:
        {
            myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 110, 30)];
            myView.textAlignment = NSTextAlignmentCenter;
            myView.text = [self.areaArr objectAtIndex:row];
            myView.font = [UIFont systemFontOfSize:14];
            myView.backgroundColor = [UIColor clearColor];
            [myView sizeToFit];
        }
            break;
        default:
            break;
    }
    
    
    
    return myView;
}

@end
