//
//  TTBlockController.m
//  MyDemo
//
//  Created by 陈彤 on 2020/4/8.
//  Copyright © 2020 ct. All rights reserved.
//

#import "TTBlockController.h"

@interface TTBlockController ()

@property (nonatomic, assign) float tmp;

- (TTBlockController *(^)(float))add;
- (TTBlockController *(^)(float))minus;
- (TTBlockController *(^)(float))multiply;
- (TTBlockController *(^)(float))divide;
- (float)giveMeResult;

@end

@implementation TTBlockController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self blockTest2];
        
}

- (void)blockTest1 {
//    关于“带有自动变量（局部变量）”的含义，这是因为Block拥有捕获外部变量的功能。在Block中访问一个外部的局部变量，Block会持用它的临时状态，自动捕获变量值，外部局部变量的变化不会影响它的的状态。
//    block在实现时就会对它引用到的它所在方法中定义的栈变量进行一次只读拷贝，然后在block块内使用该只读拷贝；换句话说block截获自动变量的瞬时值；或者block捕获的是自动变量的副本。
//    由于block捕获了自动变量的瞬时值，所以在执行block语法后，即使改写block中使用的自动变量的值也不会影响block执行时自动变量的值。
//    所以，试题的结果是2不是10。
    int val = 10;
    void (^blk)(void) = ^{
        NSLog(@"val=%d",val);
    };
    val = 2;
    blk();
    
//    解决block不能修改自动变量的值，这一问题的另外一个办法是使用__block修饰符。
    __block int val1 = 10;
    void (^blk1)(void) = ^{
        NSLog(@"val1=%d",val1);
    };
    val1 = 2;
    blk1();
}

#pragma mark - 链式

- (TTBlockController *(^)(float))add {
    TTBlockController *(^result)(float) = ^(float value) {
        self.tmp += value;
        return self;
    };
    return result;
}

- (TTBlockController *(^)(float))minus {
    return ^(float value) {
        self.tmp -= value;
        return self;
    };
}

- (TTBlockController *(^)(float))multiply {
    TTBlockController *(^result)(float) = ^(float value) {
        self.tmp *= value;
        return self;
    };
    return result;
}
- (TTBlockController *(^)(float))divide {
    TTBlockController *(^result)(float) = ^(float value) {
        self.tmp /= value;
        return self;
    };
    return result;
}

- (float)giveMeResult {
    return self.tmp;
}

- (void)blockTest2 {
    float result = self.add(2).add(3).minus(1).multiply(3).divide(4).giveMeResult;
    NSLog(@"计算结果-%f", result);
}


@end
