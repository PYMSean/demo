//
//  UnitTestTests.m
//  UnitTestTests
//
//  Created by 庞工 on 2019/2/18.
//  Copyright © 2019年 YMDream. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ViewController.h"

@interface UnitTestTests : XCTestCase

@end

@implementation UnitTestTests



#pragma mark 单元测试之前会调用，可以把单元测试中要初始化的操作放在这里
- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}
#pragma mark 单元测试之后会调用，可以把单元测试后需要销毁的对象放在这里
- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    
    //测试性能
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        ViewController * viewC = [[ViewController alloc] init];
        
        NSInteger num = [viewC getRandom];
    }];
}
- (void)testArc4Random{
    
    ViewController * viewC = [[ViewController alloc] init];
    
    NSInteger num = [viewC getRandom];
    
    XCTAssert(num<10,@"It's a error value");
    
    
}

- (void)testAsyncFunction{
    
    
    XCTestExpectation * expectation = [self expectationWithDescription:@"just a expectationDemo"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        sleep(1);
        NSLog(@"Async demo");
        XCTAssert(YES,"should pass");
        [expectation fulfill];
    });
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        
    }];
    
    
}
@end
