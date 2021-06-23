//
//  NSThreadViewController.m
//  MultithreadingDemo
//
//  Created by 张毅成 on 2021/6/22.
//

/**
 线程状态

 1.新建状态

 通过创建方法-initWithTarget...来实例化线程对象
 程序还没开始运行线程中的代码
 
 2.就绪状态

 向线程对象发送 start 消息，线程对象被加入 可调度线程池 等待 CPU 调度
 detachNewThreadSelector 方法detachNewThreadWithBlock和performSelectorInBackground 方法会直接实例化一个线程对象并加入可调度线程池
 处于就绪状态的线程并不一定立即执行线程里的代码，线程还必须同其他线程竞争CPU时间，只有获得CPU时间才可以运行线程。

 3.运行状态

 CPU 负责调度可调度线程池中线程的执行
 线程执行完成之前(死亡之前)，状态可能会在就绪和运行之间来回切换
 就绪和运行之间的状态变化由 CPU 负责，程序员不能干预

 4.阻塞状态

 所谓阻塞状态是正在运行的线程没有运行结束，暂时让出CPU，这时其他处于就绪状态的线程就可以获得CPU时间，进入运行状态

 线程通过调用sleep方法进入睡眠状态

 线程调用一个在I/O上被阻塞的操作，即该操作在输入输出操作完成之前不会返回到它的调用者

 线程试图得到一个锁，而该锁正被其他线程持有

 线程在等待某个触发条件

 + (void)sleepUntilDate:(NSDate *)date;//休眠到制定日期
 + (void)sleepForTimeInterval:(NSTimeInterval)ti;//休眠指定时长
 @synchronized(self):互斥锁
 sleep(unsigned int);
 
 5.死亡状态

 正常死亡： 线程执行完毕
 非正常死亡：
 当满足某个条件后，在现程内部自己种中止执行（自杀）
 当满足某个条件后，在主线程给其它线程打个死亡标记(下圣旨),让子线程自行了断.(被逼着死亡)

 */

#import "NSThreadViewController.h"

@interface NSThreadViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation NSThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"NSThread";
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.layer.masksToBounds = true;
    self.imageView.layer.cornerRadius = 8.0f;
}

- (IBAction)downloadAction:(UIButton *)sender {
    [self categoryNSthreadMethod];
}

//通过NSObject的分类方法开辟线程
- (void)categoryNSthreadMethod {
    [self performSelectorInBackground:@selector(downloadImage) withObject:nil];
}

//通过NSThread类方法开辟线程
- (void)classNSthreadMethod {
    //异步1
    [NSThread detachNewThreadSelector:@selector(downloadImage) toTarget:self withObject:nil];
    //异步2
    [NSThread detachNewThreadWithBlock:^{
        [self downloadImage];
    }];
}

//通过NSThread实例方法去下载图片
- (void)objectNSthreadMethod {
    //创建一个程序去下载图片
//    NSThread *thread = [[NSThread alloc] initWithBlock:^{
//        [self downloadImage];
//    }];
    //or
    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(downloadImage) object:nil];
    //开启线程
    [thread start];
    thread.name = @"imageThread";
}

//下载图片
- (void)downloadImage {
    NSURL *url = [NSURL URLWithString:@"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fqqpublic.qpic.cn%2Fqq_public%2F0%2F0-2293333134-8F8AA93986AE3D5677431BC732CE3CB7%2F0%3Ffmt%3Djpg%26size%3D108%26h%3D1385%26w%3D640%26ppv%3D1.jpg&refer=http%3A%2F%2Fqqpublic.qpic.cn&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1626936392&t=b933535790a963a08d4ec1958725fe71"];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    //在子线程中下载图片
    NSLog(@"downloadImage:%@",[NSThread currentThread].description);
    
    //在主线程中更新UI
    [self performSelectorOnMainThread:@selector(updateImage:) withObject:data waitUntilDone:YES];
}

//更新ImageView
- (void)updateImage:(NSData *)data {
    NSLog(@"updateImage:%@",[NSThread currentThread].description);//在主线程中更新UI
    //将二进制数据转换为Image
    UIImage *image = [UIImage imageWithData:data];
    //设置image
    self.imageView.image = image;
}
@end
