//
//  ViewController.m
//  UnitTest
//
//  Created by 庞工 on 2019/2/18.
//  Copyright © 2019年 YMDream. All rights reserved.
//

#import "ViewController.h"

#import "FMDB.h"


@interface ViewController ()




@property (nonatomic,strong)FMDatabase * db;



@end

@implementation ViewController
- (NSInteger)getRandom{
    return arc4random()%10;
}

- (void)coreAnimationTest{
    
    
    UIView * demoView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    demoView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:demoView];
    
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [animation setFillMode:kCAFillModeForwards];
    
    
    
    CAKeyframeAnimation * keyFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation"];
    
    CGFloat angle = M_PI_4/9;
    NSArray * arr = @[@(angle),@(-angle),@(angle)];
//    [keyFrameAnimation setValues:arr];
    UIBezierPath * path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 300, 200, 100)];
    keyFrameAnimation.path = path.CGPath;
    keyFrameAnimation.duration = 2;
    
    [keyFrameAnimation setFillMode:kCAFillModeForwards];
    [keyFrameAnimation setRemovedOnCompletion:YES];//动画完成后要不要回到最初的位置
    [keyFrameAnimation setRepeatCount:MAXFLOAT];
    [keyFrameAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    keyFrameAnimation.autoreverses = YES;
    [demoView.layer addAnimation:keyFrameAnimation forKey:@"keyFrameRotation"];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self coreAnimationTest];
    //获取沙盒地址
    NSString * path = [NSHomeDirectory() stringByAppendingString:@"/Documents/student.sqlite"];
    NSLog(@"文件路径=%@",path);
    
    
    NSString * path1 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"我大哥=%@",path1);
    
    
    FMDatabase * db = [FMDatabase databaseWithPath:path];
    if ([db open]) {
        NSLog(@"数据库成功");
        
        
        //创建表
        
        BOOL result = [db executeUpdate:@"CREATE table if not exists t_student (id integer primary key autoincrement,name text not null,age integer not null);"];
        if (result) {
            NSLog(@"创表成功");
            
            
            self.db = db;
            
            
        }else{
            NSLog(@"创表失败");
        }
        
        
        
    }else{
        NSLog(@"数据库失败");
    }
    
    
    
    
    dispatch_queue_t queue = dispatch_queue_create(0, DISPATCH_QUEUE_CONCURRENT);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 2.0*NSEC_PER_SEC, 0.1*NSEC_PER_SEC);
    
    
    __weak typeof (self) weakSelf = self;
    dispatch_source_set_event_handler(timer, ^{
        NSLog(@"延时执行的任务");
        [weakSelf query];
    });
    
    dispatch_resume(timer);
    
//    dispatch_source_cancel(timer);
}



- (void)insert{
    
    for (int i = 0; i<10; i++) {
        NSString * name = [NSString stringWithFormat:@"jack-%d",i];
        [self.db executeUpdate:@"insert into t_student (name, age) values (?, ?);",name,@(arc4random_uniform(40))];
    }
    
}

- (void)query{
    
    FMResultSet * resultSet = [self.db executeQuery:@"select * from t_student"];
    
    while ([resultSet next]) {
        int ID = [resultSet intForColumn:@"id"];
        NSString * name = [resultSet stringForColumn:@"name"];
        int age = [resultSet intForColumn:@"age"];
        NSLog(@"id = %d,name = %@,age = %d",ID,name,age);
    }
    
    
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self insert];
    [self query];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
