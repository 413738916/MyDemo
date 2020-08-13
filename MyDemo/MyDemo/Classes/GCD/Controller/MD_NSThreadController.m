//
//  MD_NSThreadController.m
//  MyDemo
//
//  Created by 陈彤 on 2020/8/13.
//  Copyright © 2020 ct. All rights reserved.
//

#import "MD_NSThreadController.h"

@interface MD_NSThreadController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) NSThread *thread1;
@property (nonatomic, strong) NSThread *thread2;
@property (nonatomic, strong) NSThread *thread3;
/**
 *  剩余票数
 */
@property (nonatomic, assign) int leftTicketCount;

@end

@implementation MD_NSThreadController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self test6];
}

#pragma mark - 创建、启动线程

//1.先创建线程，再启动线程
- (void)test1 {
    // 1. 创建线程
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    // 2. 启动线程
    [thread start];    // 线程一启动，就会在线程thread中执行self的run方法
}

// 新线程调用方法，里边为需要执行的任务
- (void)run {
    NSLog(@"%@", [NSThread currentThread]);
}

//2.创建线程后自动启动线程
- (void)test2 {
    // 1. 创建线程后自动启动线程
    [NSThread detachNewThreadSelector:@selector(run) toTarget:self withObject:nil];
}

//3.隐式创建并启动线程
- (void)test3 {
    [self performSelectorInBackground:@selector(run) withObject:nil];
}

#pragma mark - 线程相关用法

/*4. 线程相关用法
 *
 // 获得主线程
 + (NSThread *)mainThread;
 
 // 判断是否为主线程(对象方法)
 - (BOOL)isMainThread;
 
 // 判断是否为主线程(类方法)
 + (BOOL)isMainThread;
 
 // 获得当前线程
 NSThread *current = [NSThread currentThread];
 
 // 线程的名字——setter方法
 - (void)setName:(NSString *)n;
 
 // 线程的名字——getter方法
 - (NSString *)name;
 */
- (void)test4 {
    NSLog(@"%@", [NSThread mainThread]);
}

#pragma mark - 线程状态控制方法

- (void)test5 {
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    
    // 启动线程方法
    // 线程进入就绪状态 -> 运行状态。当线程任务执行完毕，自动进入死亡状态
    [thread start];
    
    //阻塞（暂停）线程方法
    //    + (void)sleepUntilDate:(NSDate *)date;
    //    + (void)sleepForTimeInterval:(NSTimeInterval)ti;
    // 线程进入阻塞状态
    
    // 强制停止线程
    //    + (void)exit;
    
}

#pragma mark - 线程之间的通信

//开启一个子线程，在子线程中下载图片。
//回到主线程刷新 UI，将图片展示在 UIImageView 中。
//创建一个线程下载图片
- (void)test6 {
    // 在创建的子线程中调用downloadImage下载图片
    [NSThread detachNewThreadSelector:@selector(downloadImage) toTarget:self withObject:nil];
}

/**
 * 下载图片，下载完之后回到主线程进行 UI 刷新
 */
- (void)downloadImage {
    NSLog(@"current thread -- %@", [NSThread currentThread]);
    
    // 1. 获取图片 imageUrl
    NSURL *imageUrl = [NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1597124576442&di=52f5fd34a7e0c3f526a9af1c12fc59b1&imgtype=0&src=http%3A%2F%2Fa1.att.hudong.com%2F62%2F02%2F01300542526392139955025309984.jpg"];
    
    // 2. 从 imageUrl 中读取数据(下载图片) -- 耗时操作
    NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
    // 通过二进制 data 创建 image
    UIImage *image = [UIImage imageWithData:imageData];
    
    // 3. 回到主线程进行图片赋值和界面刷新
    [self performSelectorOnMainThread:@selector(refreshOnMainThread:) withObject:image waitUntilDone:YES];
}

/**
 * 回到主线程进行图片赋值和界面刷新
 */
- (void)refreshOnMainThread:(UIImage *)image {
    NSLog(@"current thread -- %@", [NSThread currentThread]);
    
    // 赋值图片到imageview
    self.imageView.image = image;
}

#pragma mark - NSThread 线程安全和线程同步

- (NSThread *)thread1 {
    if (!_thread1) {
        _thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(saleTicket) object:nil];
        _thread1.name = @"1号窗口";
    }
    return _thread1;
}
- (NSThread *)thread2 {
    if (!_thread2) {
        _thread2 = [[NSThread alloc] initWithTarget:self selector:@selector(saleTicket) object:nil];
        _thread2.name = @"2号窗口";
    }
    return _thread2;
}
- (NSThread *)thread3 {
    if (!_thread3) {
        _thread3 = [[NSThread alloc] initWithTarget:self selector:@selector(saleTicket) object:nil];
        _thread3.name = @"3号窗口";
    }
    return _thread3;
}

- (void)test7 {
    self.leftTicketCount = 100;
    
    [self.thread1 start];
    [self.thread2 start];
    [self.thread3 start];
}

/**
 *  卖票
 */
- (void)saleTicket
{
    //不加锁
    //    while (1) {
    //        // ()小括号里面放的是锁对象
    //        int count = self.leftTicketCount;
    //        if (count > 0) {
    //            [NSThread sleepForTimeInterval:0.05];
    //
    //            self.leftTicketCount = count - 1;
    //
    //            NSLog(@"%@卖了一张票, 剩余%d张票", [NSThread currentThread].name, self.leftTicketCount);
    //        } else {
    //            NSLog(@"所有车票均已售完");
    //            return; // 退出循环
    //        }
    //    }
    
    //加锁
    while (1) {
        // ()小括号里面放的是锁对象
        @synchronized(self) { // 开始加锁
            int count = self.leftTicketCount;
            if (count > 0) {
                //                [NSThread sleepForTimeInterval:0.05];
                
                self.leftTicketCount = count - 1;
                
                NSLog(@"%@卖了一张票, 剩余%d张票", [NSThread currentThread].name, self.leftTicketCount);
            } else {
                return; // 退出循环
            }
        } // 解锁
    }
}


@end
