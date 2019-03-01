//
//  ViewController.m
//  password
//
//  Created by 庞工 on 2018/5/8.
//  Copyright © 2018年 YMDream. All rights reserved.
//

#import "ViewController.h"
#import "fingerViewController.h"

@interface ViewController ()
@property (nonatomic,strong)NSMutableArray *buttonArr;//全部手势按键的数组
@property (nonatomic,strong)NSMutableArray *selectorArr;//选中手势按键的数组
@property (nonatomic,assign)CGPoint startPoint;//记录开始选中的按键坐标
@property (nonatomic,assign)CGPoint endPoint;//记录结束时的手势坐标
@property (nonatomic,strong)UIImageView *imageView;//画图所需


#define ScreenHeight [[UIScreen mainScreen] bounds].size.height

#define ScreenWidth [[UIScreen mainScreen] bounds].size.width


@end

@implementation ViewController
-(NSMutableArray *)selectorArr
{
    if (!_selectorArr) {
        _selectorArr = [[NSMutableArray alloc]init];
    }
    
    return _selectorArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:self];
    [UIApplication sharedApplication].delegate.window.rootViewController = nav;
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    if (!_buttonArr) {
        _buttonArr = [[NSMutableArray alloc]initWithCapacity:9];
        }
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(62, 200, ScreenWidth-62*2, 400)];
    [self.view addSubview:self.imageView];

    float width = (self.imageView.frame.size.width-40*2)/3;
    
    for (int i=0; i<3; i++) {
        for (int j=0; j<3; j++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake((width+40)*j, 400/3*i, width, width);
            btn.backgroundColor = [UIColor yellowColor];
            btn.clipsToBounds = YES;
            btn.layer.cornerRadius = ScreenWidth/6/2;
            [btn setImage:[UIImage imageNamed:@"pbg"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"pbg01"] forState:UIControlStateHighlighted];
            btn.userInteractionEnabled = NO;
            [self.buttonArr addObject:btn];
            [self.imageView addSubview:btn];
            btn.tag = i*3+j;
            
            }
        }
    
//    [self.view addSubview:self.imageView];

    
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 100, 200, 40);
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

}

- (void)next{
    
    fingerViewController * vc = [[fingerViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(UIImage *)drawLine{
    UIImage *image = nil;
    UIColor *col = [UIColor greenColor];
    UIGraphicsBeginImageContext(self.imageView.frame.size);//设置画图的大小为imageview的大小
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 5);
    CGContextSetStrokeColorWithColor(context, col.CGColor);
    CGContextMoveToPoint(context, self.startPoint.x, self.startPoint.y);//设置画线起点
    //从起点画线到选中的按键中心，并切换画线的起点
    for (UIButton *btn in self.selectorArr) {
        CGPoint btnPo = btn.center;
        CGContextAddLineToPoint(context, btnPo.x, btnPo.y);
        CGContextMoveToPoint(context, btnPo.x, btnPo.y);
        }
    //画移动中的最后一条线
    CGContextAddLineToPoint(context, self.endPoint.x, self.endPoint.y);
    CGContextStrokePath(context);
    image = UIGraphicsGetImageFromCurrentImageContext();//画图输出
    UIGraphicsEndImageContext();//结束画线
    return image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"begin");
    UITouch *touch = [touches anyObject];//保存所有触摸事件
    if (touch) {
        for (UIButton *btn in self.buttonArr) {
            CGPoint po = [touch locationInView:btn];//记录按键坐标
            if ([btn pointInside:po withEvent:nil]) {//判断按键坐标是否在手势开始范围内,是则为选中的开始按键
                [self.selectorArr addObject:btn];
                btn.highlighted = YES;
                self.startPoint = btn.center;//保存起始坐标
                }
            }
        }
    }
//移动中触发，画线过程中会一直调用画线方法
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"move");
    UITouch *touch = [touches anyObject];
    if (touch) {
        self.endPoint = [touch locationInView:self.imageView];
        for (UIButton *btn in self.buttonArr) {
            CGPoint po = [touch locationInView:btn];
            if ([btn pointInside:po withEvent:nil]) {
                if ((self.startPoint.x ==0)&&(self.startPoint.y == 0)) {
                    self.startPoint = btn.center;
                }
                BOOL isAdd = YES;//记录是否为重复按键
                for (UIButton *seBtn in self.selectorArr) {
                    if (seBtn == btn) {
                        isAdd = NO;//已经是选中过的按键，不再重复添加
                        break;
                        }
                    }
                if (isAdd) {//未添加的选中按键，添加并修改状态
                    [self.selectorArr addObject:btn];
                    btn.highlighted = YES;
                    }
                }
            }
        }
    
    if ((self.startPoint.x != 0) && (self.startPoint.y != 0)) {
        self.imageView.image = [self drawLine];//每次移动过程中都要调用这个方法，把画出的图输出显示
    }
}
//手势结束触发
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    for (int i = 0; i<self.selectorArr.count; i++) {
        UIButton * btn = self.selectorArr[i];
        NSLog(@"tag=%ld",(long)btn.tag);
        
    }

    self.imageView.image = nil;
    self.selectorArr = nil;
    for (UIButton *btn in self.buttonArr) {
        btn.highlighted = NO;
        }
    
    self.startPoint = CGPointMake(0, 0);
    
}
@end
