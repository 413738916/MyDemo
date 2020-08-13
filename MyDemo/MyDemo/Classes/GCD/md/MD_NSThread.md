# 笔记 - NSThread

###[学习参考](https://www.jianshu.com/p/cbaeea5368b1)

### 1. 创建、启动线程
*  先创建线程，再启动线程

```objectivec
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
```
* 创建线程后自动启动线程


```objectivec
- (void)test2 {
    // 1. 创建线程后自动启动线程
    [NSThread detachNewThreadSelector:@selector(run) toTarget:self withObject:nil];
}
- (void)run {
    NSLog(@"%@", [NSThread currentThread]);
}
```
* 隐式创建并启动线程


```objectivec
- (void)test3 {
    [self performSelectorInBackground:@selector(run) withObject:nil];
}
- (void)run {
    NSLog(@"%@", [NSThread currentThread]);
}
```
### 2. 线程相关用法

```objectivec
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
```
### 3. 线程状态控制方法

* 启动线程方法

```objectivec
- (void)start;
// 线程进入就绪状态 -> 运行状态。当线程任务执行完毕，自动进入死亡状态
```
* 阻塞（暂停）线程方法

```objectivec
+ (void)sleepUntilDate:(NSDate *)date;
+ (void)sleepForTimeInterval:(NSTimeInterval)ti;
// 线程进入阻塞状态
```
* 强制停止线程

```objectivec
+ (void)exit;
// 线程进入死亡状态
```
### 4. 线程之间的通信

```objectivec
// 在主线程上执行操作
- (void)performSelectorOnMainThread:(SEL)aSelector withObject:(id)arg waitUntilDone:(BOOL)wait;
- (void)performSelectorOnMainThread:(SEL)aSelector withObject:(id)arg waitUntilDone:(BOOL)wait modes:(NSArray<NSString *> *)array;
  // equivalent to the first method with kCFRunLoopCommonModes

// 在指定线程上执行操作
- (void)performSelector:(SEL)aSelector onThread:(NSThread *)thr withObject:(id)arg waitUntilDone:(BOOL)wait modes:(NSArray *)array NS_AVAILABLE(10_5, 2_0);
- (void)performSelector:(SEL)aSelector onThread:(NSThread *)thr withObject:(id)arg waitUntilDone:(BOOL)wait NS_AVAILABLE(10_5, 2_0);

// 在当前线程上执行操作，调用 NSObject 的 performSelector:相关方法
- (id)performSelector:(SEL)aSelector;
- (id)performSelector:(SEL)aSelector withObject:(id)object;
- (id)performSelector:(SEL)aSelector withObject:(id)object1 withObject:(id)object2;

```
#####4.1 下面通过一个经典的下载图片 DEMO 来展示线程之间的通信。具体步骤如下：
1. 开启一个子线程，在子线程中下载图片。
2. 回到主线程刷新 UI，将图片展示在 UIImageView 中。

```objectivec
//创建一个线程下载图片
- (void)test6 {
    // 在创建的子线程中调用downloadImage下载图片
    [NSThread detachNewThreadSelector:@selector(downloadImage) toTarget:self withObject:nil];
}

//下载图片，下载完之后回到主线程进行 UI 刷新
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

 // 回到主线程进行图片赋值和界面刷新
- (void)refreshOnMainThread:(UIImage *)image {
    NSLog(@"current thread -- %@", [NSThread currentThread]);
    
    // 赋值图片到imageview
    self.imageView.image = image;
}
```
### 5. NSThread 线程安全和线程同步

**线程安全：**如果你的代码所在的进程中有多个线程在同时运行，而这些线程可能会同时运行这段代码。如果每次运行结果和单线程运行的结果是一样的，而且其他的变量的值也和预期的是一样的，就是线程安全的。

若每个线程中对全局变量、静态变量只有读操作，而无写操作，一般来说，这个全局变量是线程安全的；若有多个线程同时执行写操作（更改变量），一般都需要考虑线程同步，否则的话就可能影响线程安全。

**线程同步：**可理解为线程 A 和 线程 B 一块配合，A 执行到一定程度时要依靠线程 B 的某个结果，于是停下来，示意 B 运行；B 依言执行，再将结果给 A；A 再继续操作。

下面，我们模拟车票售卖的方式，实现 NSThread 线程安全和解决线程同步问题。

场景：总共有100张火车票，有三个售卖车票的窗口，分别是是1号、2号、3号售卖窗口，两个窗口同时售卖火车票，卖完为止。

#####5.1 NSThread 非线程安全
初始化初始化火车票数量、卖票窗口，并开始卖票

```objectivec
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
```
不考虑线程安全的代码：
```objectivec
//卖票
- (void)saleTicket
{
    while (1) {
        int count = self.leftTicketCount;
        if (count > 0) {
            [NSThread sleepForTimeInterval:0.05];
            
            self.leftTicketCount = count - 1;
            
            NSLog(@"%@卖了一张票, 剩余%d张票", [NSThread currentThread].name, self.leftTicketCount);
        } else {
            NSLog(@"所有车票均已售完");
            return; // 退出循环
        }
    }
}
```
运行后部分结果为：
```objectivec
2020-08-13 15:42:20.631325+0800 MyDemo[11617:245373] 3号窗口卖了一张票, 剩余2张票
2020-08-13 15:42:20.631338+0800 MyDemo[11617:245372] 2号窗口卖了一张票, 剩余2张票
2020-08-13 15:42:20.631325+0800 MyDemo[11617:245371] 1号窗口卖了一张票, 剩余2张票
2020-08-13 15:42:20.682762+0800 MyDemo[11617:245373] 3号窗口卖了一张票, 剩余1张票
2020-08-13 15:42:20.682762+0800 MyDemo[11617:245371] 1号窗口卖了一张票, 剩余1张票
2020-08-13 15:42:20.682762+0800 MyDemo[11617:245372] 2号窗口卖了一张票, 剩余1张票
2020-08-13 15:42:20.737964+0800 MyDemo[11617:245372] 2号窗口卖了一张票, 剩余0张票
2020-08-13 15:42:20.737962+0800 MyDemo[11617:245371] 1号窗口卖了一张票, 剩余0张票
2020-08-13 15:42:20.737962+0800 MyDemo[11617:245373] 3号窗口卖了一张票, 剩余0张票
2020-08-13 15:42:20.738236+0800 MyDemo[11617:245372] 所有车票均已售完
2020-08-13 15:42:20.738251+0800 MyDemo[11617:245371] 所有车票均已售完
2020-08-13 15:42:20.738278+0800 MyDemo[11617:245373] 所有车票均已售完
```
可以看到在不考虑线程安全的情况下，得到票数是错乱的，这样显然不符合我们的需求，所以我们需要考虑线程安全问题。
#####5.2 NSThread 线程安全
线程安全解决方案：可以给线程加锁，在一个线程执行该操作的时候，不允许其他线程进行操作。iOS 实现线程加锁有很多种方式。@synchronized、 NSLock、NSRecursiveLock、NSCondition、NSConditionLock、pthread_mutex、dispatch_semaphore、OSSpinLock、atomic(property) set/ge等等各种方式。

为了简单起见，这里不对各种锁的解决方案和性能做分析，只用最简单的@synchronized来保证线程安全，从而解决线程同步问题。

```objectivec
//卖票
- (void)saleTicket
{
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
```
运行后部分结果为：

```objectivec
2020-08-13 15:46:56.625551+0800 MyDemo[11673:248676] 1号窗口卖了一张票, 剩余25张票
2020-08-13 15:46:56.625833+0800 MyDemo[11673:248676] 1号窗口卖了一张票, 剩余24张票
...
2020-08-13 15:46:56.631278+0800 MyDemo[11673:248677] 2号窗口卖了一张票, 剩余4张票
2020-08-13 15:46:56.631519+0800 MyDemo[11673:248677] 2号窗口卖了一张票, 剩余3张票
2020-08-13 15:46:56.631782+0800 MyDemo[11673:248677] 2号窗口卖了一张票, 剩余2张票
2020-08-13 15:46:56.632017+0800 MyDemo[11673:248677] 2号窗口卖了一张票, 剩余1张票
2020-08-13 15:46:56.632233+0800 MyDemo[11673:248677] 2号窗口卖了一张票, 剩余0张票
```
可以看出，在考虑了线程安全的情况下，加锁之后，得到的票数是正确的，没有出现混乱的情况。我们也就解决了多个线程同步的问题。

