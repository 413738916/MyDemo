//
//  MDGCDController.m
//  MyDemo
//
//  Created by 123 on 2017/12/14.
//  Copyright © 2017年 ct. All rights reserved.
//

#import "MDGCDController.h"

@interface MDGCDController ()

@property (weak, nonatomic) IBOutlet UIImageView *demoImgView;

#pragma mark  NSThread

@property (nonatomic, strong) NSThread *thread1;
@property (nonatomic, strong) NSThread *thread2;
@property (nonatomic, strong) NSThread *thread3;
/**
 *  剩余票数
 */
@property (nonatomic, assign) int leftTicketCount;


@end

@implementation MDGCDController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.leftTicketCount = 50;
    
}

#pragma mark - NSThread

- (IBAction)startThread:(id)sender {
    
    //1.模拟卖票（加锁）
//    [self.thread1 start];
//    [self.thread2 start];
//    [self.thread3 start];
    //2.下载图片
    [self performSelectorInBackground:@selector(threadDownLoad) withObject:nil];

}

- (void)threadDownLoad {
    NSLog(@"download---%@", [NSThread currentThread]);
    // 1.图片地址
    NSString *urlStr = @"http://d.hiphotos.baidu.com/image/pic/item/37d3d539b6003af3290eaf5d362ac65c1038b652.jpg";
    NSURL *url = [NSURL URLWithString:urlStr];
    
    // 2.根据地址下载图片的二进制数据(这句代码最耗时)
    NSLog(@"---begin");
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSLog(@"---end");
    
    // 3.设置图片
    UIImage *image = [UIImage imageWithData:data];
    
    // 4.回到主线程，刷新UI界面(为了线程安全)
    [self performSelectorOnMainThread:@selector(downloadFinished:) withObject:image waitUntilDone:NO];
    //    [self performSelector:@selector(downloadFinished:) onThread:[NSThread mainThread] withObject:image waitUntilDone:YES];
    //    [self.imageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:YES];
    
    NSLog(@"-----done----");
}
- (void)downloadFinished:(UIImage *)image
{
    self.demoImgView.image = image;
    
    NSLog(@"downloadFinished---%@", [NSThread currentThread]);
}

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

/**
 *  卖票
 */
- (void)saleTicket
{
    while (1) {
        // ()小括号里面放的是锁对象
        @synchronized(self) { // 开始加锁
            int count = self.leftTicketCount;
            if (count > 0) {
                [NSThread sleepForTimeInterval:0.05];
                
                self.leftTicketCount = count - 1;
                
                NSLog(@"%@卖了一张票, 剩余%d张票", [NSThread currentThread].name, self.leftTicketCount);
            } else {
                return; // 退出循环
            }
        } // 解锁
    }
}

#pragma mark - GCD

- (IBAction)startGCD:(id)sender {
    
    //1.组合的方式
    [self asyncGlobalQueue];
//    [self asyncSerialQueue];
//    [self asyncMainQueue];
//    [self syncMainQueue];
//    [self syncGlobalQueue];
//    [self syncSerialQueue];

    //2.下载图片
    [self imageDownLoadGCD];
}

/**
 *  async -- 并发队列（最常用）
 *  会不会创建线程：会，一般同时开多条
 *  任务的执行方式：并发执行
 */
- (void)asyncGlobalQueue
{
    // 获得全局的并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // 将 任务 添加 全局队列 中去 异步 执行
    dispatch_async(queue, ^{
        NSLog(@"-----下载图片1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"-----下载图片2---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"-----下载图片3---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"-----下载图片4---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"-----下载图片5---%@", [NSThread currentThread]);
    });
}

/**
 *  async -- 串行队列（有时候用）
 *  会不会创建线程：会，一般只开1条线程
 *  任务的执行方式：串行执行（一个任务执行完毕后再执行下一个任务）
 */
- (void)asyncSerialQueue
{
    // 1.创建一个串行队列
    dispatch_queue_t queue = dispatch_queue_create("cn.heima.queue", NULL);
    
    // 2.将任务添加到串行队列中 异步 执行
    dispatch_async(queue, ^{
        NSLog(@"-----下载图片1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"-----下载图片2---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"-----下载图片3---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"-----下载图片4---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"-----下载图片5---%@", [NSThread currentThread]);
    });
    
    // 3.非ARC，需要释放创建的队列
    //    dispatch_release(queue);
}

/**
 *  async -- 主队列(很常用)
 */
- (void)asyncMainQueue
{
    // 1.主队列(添加到主队列中的任务，都会自动放到主线程中去执行)
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    // 2.添加 任务 到主队列中 异步 执行
    dispatch_async(queue, ^{
        NSLog(@"-----下载图片1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"-----下载图片2---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"-----下载图片3---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"-----下载图片4---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"-----下载图片5---%@", [NSThread currentThread]);
    });
}

/**
 *  sync -- 主队列(不能用---会卡死)
 */
- (void)syncMainQueue
{
    NSLog(@"syncMainQueue----begin--");
    
    // 1.主队列(添加到主队列中的任务，都会自动放到主线程中去执行)
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    // 2.添加 任务 到主队列中 异步 执行
    dispatch_sync(queue, ^{
        NSLog(@"-----下载图片1---%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"-----下载图片2---%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"-----下载图片3---%@", [NSThread currentThread]);
    });
    
    NSLog(@"syncMainQueue----end--");
}

/**-------------------------------------华丽的分割线-----------------------------------------------------**/

/**
 *  sync -- 并发队列
 *  会不会创建线程：不会
 *  任务的执行方式：串行执行（一个任务执行完毕后再执行下一个任务）
 *  并发队列失去了并发的功能
 */
- (void)syncGlobalQueue
{
    // 获得全局的并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // 将 任务 添加到 全局并发队列 中 同步 执行
    dispatch_sync(queue, ^{
        NSLog(@"-----下载图片1---%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"-----下载图片2---%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"-----下载图片3---%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"-----下载图片4---%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"-----下载图片5---%@", [NSThread currentThread]);
    });
}

/**
 *  sync -- 串行队列
 *  会不会创建线程：不会
 *  任务的执行方式：串行执行（一个任务执行完毕后再执行下一个任务）
 */
- (void)syncSerialQueue
{
    // 创建一个串行队列
    dispatch_queue_t queue = dispatch_queue_create("cn.heima.queue", NULL);
    
    // 将 任务 添加到 串行队列 中 同步 执行
    dispatch_sync(queue, ^{
        NSLog(@"-----下载图片1---%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"-----下载图片2---%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"-----下载图片3---%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"-----下载图片4---%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"-----下载图片5---%@", [NSThread currentThread]);
    });
}

- (void)imageDownLoadGCD {
    // 1.队列组
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // 2.下载图片1
    __block UIImage *image1 = nil;
    dispatch_group_async(group, queue, ^{
        NSURL *url1 = [NSURL URLWithString:@"http://g.hiphotos.baidu.com/image/pic/item/f2deb48f8c5494ee460de6182ff5e0fe99257e80.jpg"];
        NSData *data1 = [NSData dataWithContentsOfURL:url1];
        image1 = [UIImage imageWithData:data1];
    });
    
    // 3.下载图片2
    __block UIImage *image2 = nil;
    dispatch_group_async(group, queue, ^{
        NSURL *url2 = [NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1586352776747&di=b7d5e9490eed01d54d695049fcc573db&imgtype=0&src=http%3A%2F%2Fdl.ppt123.net%2Fpptbj%2F51%2F20181115%2Fmzj0ghw2xo2.jpg"];
        NSData *data2 = [NSData dataWithContentsOfURL:url2];
        image2 = [UIImage imageWithData:data2];
    });
    
    // 4.合并图片 (保证执行完组里面的所有任务之后，再执行notify函数里面的block)
    dispatch_group_notify(group, queue, ^{
        // 开启一个位图上下文
        UIGraphicsBeginImageContextWithOptions(image1.size, NO, 0.0);
        
        // 绘制第1张图片
        CGFloat image1W = image1.size.width;
        CGFloat image1H = image1.size.height;
        [image1 drawInRect:CGRectMake(0, 0, image1W, image1H)];
        
        // 绘制第2张图片
        CGFloat image2W = image2.size.width * 0.5;
        CGFloat image2H = image2.size.height * 0.5;
        CGFloat image2Y = image1H - image2H;
        [image2 drawInRect:CGRectMake(0, image2Y, image2W, image2H)];
        
        // 得到上下文中的图片
        UIImage *fullImage = UIGraphicsGetImageFromCurrentImageContext();
        
        // 结束上下文
        UIGraphicsEndImageContext();
        
        // 5.回到主线程显示图片
        dispatch_async(dispatch_get_main_queue(), ^{
            self.demoImgView.image = fullImage;
        });
    });
}

#pragma mark - Operation

- (IBAction)startOperation:(id)sender {
    
    //
    [self dependencyOperation];
//    [self maxCountOperation];
    
    // 下载图片
    [self operationDownLoadImg];
}

- (void)dependencyOperation
{
    /**
     假设有A、B、C三个操作，要求：
     1. 3个操作都异步执行
     2. 操作C依赖于操作B
     3. 操作B依赖于操作A
     */
    
    // 1.创建一个队列（非主队列）
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    // 2.创建3个操作
    NSBlockOperation *operationA = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"A1---%@", [NSThread currentThread]);
    }];
    //    [operationA addExecutionBlock:^{
    //        NSLog(@"A2---%@", [NSThread currentThread]);
    //    }];
    //
    //    [operationA setCompletionBlock:^{
    //        NSLog(@"AAAAA---%@", [NSThread currentThread]);
    //    }];
    
    NSBlockOperation *operationB = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"B---%@", [NSThread currentThread]);
    }];
    NSBlockOperation *operationC = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"C---%@", [NSThread currentThread]);
    }];
    
    // 设置依赖
    [operationB addDependency:operationA];
    [operationC addDependency:operationB];
    
    // 3.添加操作到队列中（自动异步执行任务）
    [queue addOperation:operationC];
    [queue addOperation:operationA];
    [queue addOperation:operationB];
}

- (void)maxCountOperation
{
    // 1.创建一个队列（非主队列）
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    // 2.设置最大并发(最多同时并发执行3个任务)
    queue.maxConcurrentOperationCount = 3;
    
    // 3.添加操作到队列中（自动异步执行任务，并发）
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"下载图片1---%@", [NSThread currentThread]);
    }];
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"下载图片2---%@", [NSThread currentThread]);
    }];
    NSBlockOperation *operation3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"下载图片3---%@", [NSThread currentThread]);
    }];
    NSBlockOperation *operation4 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"下载图片4---%@", [NSThread currentThread]);
    }];
    NSInvocationOperation *operation5 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(downloadOperation) object:nil];
    
    [queue addOperation:operation1];
    [queue addOperation:operation2];
    [queue addOperation:operation3];
    [queue addOperation:operation4];
    [queue addOperation:operation5];
    [queue addOperationWithBlock:^{
        NSLog(@"下载图片5---%@", [NSThread currentThread]);
    }];
    [queue addOperationWithBlock:^{
        NSLog(@"下载图片6---%@", [NSThread currentThread]);
    }];
    [queue addOperationWithBlock:^{
        NSLog(@"下载图片7---%@", [NSThread currentThread]);
    }];
    [queue addOperationWithBlock:^{
        NSLog(@"下载图片8---%@", [NSThread currentThread]);
    }];
    [queue addOperationWithBlock:^{
        NSLog(@"下载图片9---%@", [NSThread currentThread]);
    }];
    
    [queue cancelAllOperations];
}

- (void)downloadOperation
{
    NSLog(@"download---%@", [NSThread currentThread]);
}

- (void)operationDownLoadImg {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
        // 1.异步下载图片
        NSURL *url = [NSURL URLWithString:@"http://d.hiphotos.baidu.com/image/pic/item/37d3d539b6003af3290eaf5d362ac65c1038b652.jpg"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        
        // 2.回到主线程，显示图片
        //        [self performSelectorOnMainThread:<#(SEL)#> withObject:<#(id)#> waitUntilDone:<#(BOOL)#>];
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //
        //        });
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.demoImgView.image = image;
        }];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
