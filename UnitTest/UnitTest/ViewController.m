//
//  ViewController.m
//  UnitTest
//
//  Created by 庞工 on 2019/2/18.
//  Copyright © 2019年 YMDream. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
- (NSInteger)getRandom{
    return arc4random()%10;
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
