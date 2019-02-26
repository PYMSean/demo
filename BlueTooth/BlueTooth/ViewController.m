//
//  ViewController.m
//  BlueTooth
//
//  Created by 庞工 on 2018/3/28.
//  Copyright © 2018年 YMDream. All rights reserved.
//

#import "ViewController.h"
@interface ViewController ()
{
    CBCentralManager * _manager;
    CBPeripheral * _peripheral;
    NSMutableArray * _peripheralArr;
}



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //初始化蓝牙
    _manager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
    _manager.delegate = self;
    
    _peripheralArr = [NSMutableArray arrayWithCapacity:1];
    
    
    //开始扫描
    [_manager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @NO}];//此方法执行之后会执行代理方法  didDiscoberPeripheral
    
}

#pragma mark  检测蓝牙状态
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    if (central.state != CBManagerStatePoweredOn) {
        NSLog(@"fail, state is off");
        switch (central.state) {
            case CBManagerStatePoweredOff:
                NSLog(@"连接失败，请检查一下手机蓝牙是否开启");
                break;
                
            case CBManagerStateResetting:
                NSLog(@"");
                break;
                
            case CBManagerStateUnsupported:
                NSLog(@"检测到手机不支持蓝牙4.0");
                break;
                
            case CBManagerStateUnauthorized:
                NSLog(@"连接失败");
                break;
                
            case CBManagerStateUnknown:
                NSLog(@"unknow");
                break;
                
            default:
                break;
        }
        
        return;
    }
    
    NSLog(@"Bluetooth fail state not exit");
    
    //检测完成之后就可以扫面设备了
    
}

#pragma mark  发现peripheral
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI{
    
    if (peripheral == nil || peripheral.identifier == nil || peripheral.name == nil) {
        //没有扫描到任何设备
        return;
    }
    
    NSString * peripheralName = [NSString stringWithFormat:@"%@",peripheral.name];
    
    //设备列表没有设备  检索到自己需要的设备名字  然后加到设备列表中
    
    NSRange range = [peripheralName rangeOfString:@"our device we need"];
    if ((range.location != NSNotFound) && !([_peripheralArr containsObject:peripheral])) {
        [_peripheralArr addObject:peripheral];
        
        
        //找到设备后,连接设备
        [_manager connectPeripheral:peripheral options:@{CBConnectPeripheralOptionNotifyOnConnectionKey:@YES}];

    }
    
    
}


#pragma mark  连接上设备后  ->接下来要去发现service了
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"设备 has connected ：%@",peripheral);
    
    //设置设备代理
    peripheral.delegate = self;
    
    //获取服务和特征
    [peripheral discoverServices:nil];//nil的话获取所有service
    
    [peripheral discoverServices:@[[CBUUID UUIDWithString:@"service's UUID"]]];
    
    //停止扫描
    [_manager stopScan];
    
    
}

#pragma mark connect fail
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
    NSLog(@"连接失败!");
    
}


#pragma mark  获取服务
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    
    if (error) {
        NSLog(@"%@",[error localizedDescription]);
        return;
    }
    
    NSLog(@"all service :%@",peripheral.services);
    
    for (CBService * service in peripheral.services) {
        NSLog(@"service‘s uuid: %@",service.UUID);
        
        //找到自己需要的，然后获取他的特征
        if ([service.UUID isEqual:[CBUUID UUIDWithString:@"你的设备服务的UUID"]]) {
            
            //获取服务对应的特征
            [peripheral discoverCharacteristics:nil forService:service];
        }
    }
    
    
}

#pragma mark  获取特征值
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    
    if (error) {
        NSLog(@"error :%@",[error localizedDescription]);
        return;
    }
    
    NSLog(@"服务 ：%@",service.UUID);
    
    //遍历特征值，找出自己的特征值
    for (CBCharacteristic * characteristics in service.characteristics) {
        NSLog(@"characteristic's UUID : %@",characteristics.UUID);
        
        if ([characteristics.UUID isEqual:[CBUUID UUIDWithString:@"自己的特征值"]]) {
            
            //为蓝牙设备写入指令
            [_peripheral writeValue:[NSData data] forCharacteristic:characteristics type:CBCharacteristicWriteWithResponse];
            
            //监听特征
            [_peripheral setNotifyValue:YES forCharacteristic:characteristics];
        }
    }
    
    
    
    
}


#pragma mark  write or notify response
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(nonnull CBCharacteristic *)characteristic error:(nullable NSError *)error{
    
    NSLog(@"收到的数据%@",characteristic.value);
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error{
    
    NSLog(@"收到的数据%@",characteristic.value);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
