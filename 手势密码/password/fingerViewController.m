//
//  fingerViewController.m
//  password
//
//  Created by 庞工 on 2018/5/8.
//  Copyright © 2018年 YMDream. All rights reserved.
//

#import "fingerViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
@interface fingerViewController ()
{
    UIView * _round1;
    UIView * _round2;
    UIView * _round3;
    
    int _count;
    int _add;
}
@end

@implementation fingerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"指纹识别";
    
    
    LAContext * context = [[LAContext alloc] init];
    context.localizedFallbackTitle = @"1";
    context.localizedCancelTitle = @"取消";
    
    NSError * error = nil;
    NSString * result = @"指纹验证通过后可以控制设备";
    
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:result reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                NSLog(@"success");
            }else
            {
                NSLog(@"%@",error.localizedDescription);
                switch (error.code) {
                    case LAErrorSystemCancel:
                    {
                        //NSLog(@"Authentication was cancelled by the system");
                        //切换到其他APP，系统取消验证Touch ID
                        break;
                    }
                    case LAErrorUserCancel:
                    {
                        //NSLog(@"Authentication was cancelled by the user");
                        //用户取消验证Touch ID
                        break;
                    }
                    case LAErrorUserFallback:
                    {
                        //NSLog(@"User selected to enter custom password");
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //用户选择其他验证方式，切换主线程处理
                        }];
                        break;
                    }
                    default:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //其他情况，切换主线程处理
                        }];
                        break;
                    }
                }
            }
        }];
    }else{
        NSLog(@"不支持指纹识别");
        
        switch (error.code) {
            case LAErrorTouchIDNotEnrolled:
            {
                NSLog(@"TouchID is not enrolled");
                break;
            }
            case LAErrorPasscodeNotSet:
            {
                NSLog(@"A passcode has not been set");
                break;
            }
            default:
            {
                NSLog(@"TouchID not available");
                break;
            }
        }
    }
    
    [self animation];
}

- (void)animation {
    
    CGPoint center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    
    _round1 = [[UIView alloc]init];
    _round1.center = center;
    _round1.clipsToBounds = YES;
    _round1.layer.cornerRadius = 25;
    _round1.bounds = CGRectMake(0, 0, 50, 50);
    _round1.backgroundColor = [UIColor blueColor];
    
    _round2 = [[UIView alloc]init];
    _round2.center = center;
    _round2.clipsToBounds = YES;
    _round2.layer.cornerRadius = 40;
    _round2.bounds = CGRectMake(0, 0, 80, 80);
    _round2.backgroundColor = [UIColor greenColor];
    
    _round3 = [[UIView alloc]init];
    _round3.center = center;
    _round3.clipsToBounds = YES;
    _round3.layer.cornerRadius = 75;
    _round3.bounds = CGRectMake(0, 0, 150, 150);
    _round3.backgroundColor = [UIColor purpleColor];
//    [self.view addSubview:_round3];
//    [self.view addSubview:_round2];
    [self.view addSubview:_round1];
    
    [self start];

    
}
- (void)way{
    
    UIView * view = [[UIView alloc] init];
    view.center = _round3.center;
    view.backgroundColor = [UIColor lightGrayColor];
    view.clipsToBounds = YES;
    view.layer.cornerRadius = 100;
    [self.view addSubview:view];
    [self.view bringSubviewToFront:_round1];

    [UIView animateWithDuration:3 animations:^{
        view.bounds = CGRectMake(0, 0, 200, 200);
        view.alpha = 0.2;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
    
//    if (_add == 0) {
//        _count++;
//    }else{
//        _count--;
//    }
//    
//    
//    if (_count==12) {
//        _count=0;
//        _add = 1;
//    }
//    
//    if (_count == -12) {
//        _count = 0;
//        _add = 0;
//    }
//    
//    _round3.bounds = CGRectMake(0, 0, _round3.frame.size.width+_count, _round3.frame.size.width+_count);
//    _round2.bounds = CGRectMake(0, 0, _round2.frame.size.width+_count, _round2.frame.size.width+_count);
//
//    _round3.layer.cornerRadius = _round3.frame.size.width/2;
//    _round2.layer.cornerRadius = _round2.frame.size.width/2;
    

}
- (void)start{
    
    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(way) userInfo:nil repeats:YES];
    [timer fire];
    
//    [UIView animateWithDuration:2 animations:^{
//
//        UIView * view = [[UIView alloc] init];
//        view.center = _round3.center;
//        view.backgroundColor = [UIColor lightGrayColor];
//        [self.view addSubview:view];
//    } completion:^(BOOL finished) {
//        
//    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
