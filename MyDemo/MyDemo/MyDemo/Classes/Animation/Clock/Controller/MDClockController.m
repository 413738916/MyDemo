//
//  MDClockController.m
//  MyDemo
//
//  Created by 123 on 2017/12/8.
//  Copyright © 2017年 ct. All rights reserved.
//

#import "MDClockController.h"

@interface MDClockController ()

@property (nonatomic, strong) CALayer *second;
@property (nonatomic, strong) CALayer *minute;
@property (nonatomic, strong) CALayer *hour;

@property (nonatomic, strong) NSTimer *timer;

@property (weak, nonatomic) IBOutlet UIImageView *clockView;

@end

@implementation MDClockController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)viewDidLayoutSubviews {
    NSLog(@"%@",NSStringFromCGRect(_clockView.frame));

    // 1.添加秒针
    [self second];
    
    // 2.添加分针
    [self minute];
    
    // 3.添加时针
    [self hour];
    
    [self update];
    
    [self timer];
    
}

- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(update) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (void)update {
    
    // 每秒秒针转多少度
#define perSecendA 6
    
    // 每分钟分针转多少度
#define perMinuteA 6
    
    // 每小时时针转多少度
#define perHourA 30
    
    // 每分钟时针转多少度
#define perMinuteHourA 0.5
    
#define angle2radian(x) ((x) / 180.0 * M_PI)
    
    // 获取秒数
    // 获取日历对象
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 获取日期组件
    NSDateComponents *compoents = [calendar components:NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour fromDate:[NSDate date]];
    
    // 获取秒数
    CGFloat sec = compoents.second;
    
    // 获取分钟
    CGFloat minute = compoents.minute;
    
    // 获取小时
    CGFloat hour = compoents.hour;
    
    
    // 算出秒针旋转多少°
    CGFloat secondA = sec * perSecendA;
    
    // 算出分针旋转多少°
    CGFloat minuteA = minute * perMinuteA;
    
    // 算出时针旋转多少°
    CGFloat hourA = hour * perHourA;
    hourA += minute * perMinuteHourA;
    
    // 旋转秒针
    _second.transform = CATransform3DMakeRotation(angle2radian(secondA), 0, 0, 1);
    
    // 旋转分针
    _minute.transform = CATransform3DMakeRotation(angle2radian(minuteA), 0, 0, 1);
    
    // 旋转时针
    _hour.transform = CATransform3DMakeRotation(angle2radian(hourA), 0, 0, 1);
    
}

// 添加时针
- (CALayer *)hour {
    
    if (!_hour) {
        CGFloat imageW = _clockView.bounds.size.width;
        CGFloat imageH = _clockView.bounds.size.height;
        
        // 1.添加时针
        _hour = [CALayer layer];
        
        // 2.设置锚点
        _hour.anchorPoint = CGPointMake(0.5, 1);
        
        // 3.设置位置
        _hour.position = CGPointMake(imageW * 0.5, imageH * 0.5);
        
        // 4.设置尺寸
        _hour.bounds = CGRectMake(0, 0, 4, imageH * 0.5 - 50);
        
        // 5.红色
        _hour.backgroundColor = [UIColor blackColor].CGColor;
        
        _hour.cornerRadius = 4;
        
        // 添加到图层上
        [_clockView.layer addSublayer:_hour];
        
    }
    return _hour;
}

// 添加分针
- (CALayer *)minute {
    
    if (!_minute) {
        CGFloat imageW = _clockView.bounds.size.width;
        CGFloat imageH = _clockView.bounds.size.height;
        
        // 1.添加分针
        _minute = [CALayer layer];
        
        // 2.设置锚点
        _minute.anchorPoint = CGPointMake(0.5, 1);
        
        // 3.设置位置
        _minute.position = CGPointMake(imageW * 0.5, imageH * 0.5);
        
        // 4.设置尺寸
        _minute.bounds = CGRectMake(0, 0, 2, imageH * 0.5 - 30);
        
        // 5.红色
        _minute.backgroundColor = [UIColor blueColor].CGColor;
        
        // 添加到图层上
        [_clockView.layer addSublayer:_minute];
        
    }
    return _minute;
}

// 懒加载秒针
- (CALayer *)second {
    if (!_second) {
        
        CGFloat imageW = _clockView.bounds.size.width;
        CGFloat imageH = _clockView.bounds.size.height;
        
        // 1.添加秒针
        _second = [CALayer layer];
        
        // 2.设置锚点
        _second.anchorPoint = CGPointMake(0.5, 1);
        
        // 3.设置位置
        _second.position = CGPointMake(imageW * 0.5, imageH * 0.5);
        
        // 4.设置尺寸
        _second.bounds = CGRectMake(0, 0, 1, imageH * 0.5 - 20);
        
        // 5.红色
        _second.backgroundColor = [UIColor redColor].CGColor;
        
        // 添加到图层上
        [_clockView.layer addSublayer:_second];
        
    }
    return _second;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
