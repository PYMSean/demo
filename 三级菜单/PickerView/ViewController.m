//
//  ViewController.m
//  PickerView
//
//  Created by 庞工 on 2018/6/21.
//  Copyright © 2018年 YMDream. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSDictionary * _dic;
    NSArray * _firstArr;
    NSArray * _secondArr;
    NSArray * _thirdArr;
    NSDictionary * _selecteDic;
    
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
#pragma mark data
    _dic = @{@"河南省":@{@"郑州市":@[@"中原区",@"管城回族区",@"金水区"],@"洛阳市":@[@"洛龙区",@"涧西区",@"西工区"],@"开封市":@[@"经开区",@"开封县"]},@"安徽省":@{@"合肥市":@[@"大哭区",@"金山区",@"金水区"],@"亳州市":@[@"神龙区",@"细哦区",@"西工区"],@"六安市":@[@"经开区",@"开封县"]},@"山东省":@{@"青岛市":@[@"西法区",@"大名区",@"消防区"],@"染坊市":@[@"开花区",@"结构区",@"公民区"]}};
    
    _firstArr = [_dic allKeys];
    NSDictionary * dic1 = [_dic objectForKey:_firstArr[0]];
    _secondArr = [dic1 allKeys];
    _thirdArr = [dic1 objectForKey:_secondArr[0]];
    
    UIPickerView * pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 216)];
    pickView.delegate = self;
    pickView.dataSource = self;
    [self.view addSubview:pickView];
    
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (component == 0) {
        return _firstArr.count;
    }else if (component == 1){
        return _secondArr.count;
    }else{
        return _thirdArr.count;
    }
    
}
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return _firstArr[row];
    }else if (component == 1){
        return _secondArr[row];
    }else{
        return _thirdArr[row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (component == 0) {
        
        NSDictionary * dic1 = [_dic objectForKey:_firstArr[row]];
        _secondArr = [dic1 allKeys];
        _thirdArr = [dic1 objectForKey:_secondArr[0]];
        _selecteDic = dic1;
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView selectRow:0 inComponent:2 animated:YES];

    }else if (component == 1){
        _thirdArr = [_selecteDic objectForKey:_secondArr[row]];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
        
    }else{
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
