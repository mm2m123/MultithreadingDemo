//
//  GCDViewController.m
//  MultithreadingDemo
//
//  Created by 张毅成 on 2021/6/21.
//

/**
 任务和队列

 任务

 就是执行操作的意思，换句话说就是你在线程中执行的那段代码。在GCD中是放在block中的。执行任务有两种方式：同步执行和异步执行。两者的主要区别是：是否具备开启新线程的能力。

 
 
 同步执行（sync):只能在当前线程中执行的任务，不具备开启新线程的能力

 必须等待当前语句执行完毕，才会执行下一条语句
 不会开启线程
 在当前主线程执行 block 的任务
 dispatch_sync(queue, block);

 异步执行（async):可以在新的线程中执行任务，具备开启新线程的能力

 不用等待当前语句执行完毕，就可以执行下一条语句
 会开启线程执行 block 的任务
 异步是多线程的代名词
 dispatch_async(queue, block);

 
 
 
 
 队列

 这里的队列指任务队列，即用来存放任务的队列。队列是一种特殊的线性表，采用FIFO（先进先出）的原则，即新任务总是被插入到队列的末尾，而读取任务的时候总是从队列的头部开始读取。每读取一个任务，则从队列中释放一个任务。在GCD中有四种队列：串行队列、并发队列、主队列、全局队列。

 
 1.串行队列（Serial Dispatch Queue）：让任务一个接着一个地执行（一个任务执行完毕后，再执行下一个任务）

 一次只能"调度"一个任务
 dispatch_queue_create("queue", NULL);或者dispatch_queue_create("queue", DISPATCH_QUEUE_SERIAL);
 
 2.并发队列（Concurrent Dispatch Queue）：可以让多个任务并发（同时）执行（自动开启多个线程同时执行任务）
 
 一次可以"调度"多个任务
 并发功能只有在异步（dispatch_async）函数下才有效
 dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);

 3.主队列
 
 专门用来在主线程上调度任务的队列
 不会开启线程
 在主线程空闲时才会调度队列中的任务在主线程执行
 dispatch_get_main_queue();
 
 4.全局队列
 
 执行过程和并发队列一致，参考并发队列
 dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
 
 小结:
 1. 开不开线程由执行任务的函数决定
 异步开，异步是多线程的代名词
 同步不开
 2.开几条线程由队列决定
 串行队列开一条线程（GCD会开一条，NSOperation Queue最大并发数为1时也可能开多条）
 并发队列开多条线程，具体能开的线程数量由底层线程池决定

 
 */

#import "GCDViewController.h"

@interface GCDViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation GCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"GCD";
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.layer.masksToBounds = true;
    self.imageView.layer.cornerRadius = 8.0f;
}

- (IBAction)downloadAction:(UIButton *)sender {
//    [self GCDAutoDispatchGroupMethod];
//    [self downloadImageByDispatchAsync];
//    [self GCDBarrierAsyncMethod];
    [self GCDDispatchSemaphore];
}

//通过GCD异步下载图片
- (void)downloadImageByDispatchAsync{
    //获取全局队列 -- DISPATCH_QUEUE_PRIORITY_DEFAULT是宏，可以写作 0
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //异步下载图片
        NSURL *url = [NSURL URLWithString:@"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fqqpublic.qpic.cn%2Fqq_public%2F0%2F0-2293333134-8F8AA93986AE3D5677431BC732CE3CB7%2F0%3Ffmt%3Djpg%26size%3D108%26h%3D1385%26w%3D640%26ppv%3D1.jpg&refer=http%3A%2F%2Fqqpublic.qpic.cn&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1626936392&t=b933535790a963a08d4ec1958725fe71"];
        //获取资源转换为二进制
        NSData *data = [NSData dataWithContentsOfURL:url];
        //将二进制转为图片
        UIImage *image = [UIImage imageWithData:data];
        //获取主队列，更新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            //给图控件赋值
            self.imageView.image = image;
        });
    });
}

//自动执行任务组
- (void)GCDAutoDispatchGroupMethod {
    //创建队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //创建队列组
    dispatch_group_t group = dispatch_group_create();
    
    for (int i = 0; i<6; i++) {
        dispatch_group_async(group,queue, ^{
            NSLog(@"current Thread = %@----->%d",[NSThread currentThread],i);
        });
    }
    
    dispatch_group_notify(group,dispatch_get_main_queue(), ^{
        NSLog(@"current Thread = %@----->这是最后执行",[NSThread currentThread]);
    });
}

#pragma mark - Dispatch_barrier_async
 - (void)GCDBarrierAsyncMethod{
    
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    void(^blk1_reading)(void) = ^{
         NSLog(@"blk1---reading");
    };
    
    void(^blk2_reading)(void) = ^{
        NSLog(@"blk2---reading");
    };
    void(^blk3_reading)(void) = ^{
        NSLog(@"blk3---reading");
    };
    void(^blk4_reading)(void) = ^{
        NSLog(@"blk4---reading");
    };
    void(^blk_writing)(void) = ^{
        NSLog(@"blk---writing");
    };
        
    dispatch_async(concurrentQueue, blk1_reading);
    dispatch_async(concurrentQueue, blk2_reading);
    
    //添加追加操作,,会等待b1和b2全部执行结束，执行完成追加操作b，才会继续并发执行下面操作
    dispatch_barrier_async(concurrentQueue, blk_writing);
    
    dispatch_async(concurrentQueue, blk3_reading);
    dispatch_async(concurrentQueue, blk4_reading);

}

- (void)GCDDispatchSemaphore{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
  //创建一个信号量dispatch
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    
    NSMutableArray *array = [NSMutableArray new];
    for (int i = 0; i < 10; i++) {
        dispatch_async(queue, ^{
            //一直等待信号量大于0
            dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, DISPATCH_TIME_FOREVER));
            
          //进行排他控制的处理代码...
          //将dispatch semphore的计数器减1
            [array addObject:[NSNumber numberWithInteger:i]];
              
            //排他控制处理结束
            //将dispatch semphore的计数器加1
            //如果有通过dispatch_semaphore_wait函数dispatch semphore的计数值增加的线程，等待就由最先等待的线程执行
            dispatch_semaphore_signal(semaphore);
        });
        
        NSLog(@"%@",array);
    }
}
//创建一个信号量dispatch dispatch_semaphore_t dispatch_semaphore_create(long value);
//等待信号量longdispatch_semaphore_wait(dispatch_semaphore_t dsema, dispatch_time_t timeout);返回值和dispatch_group_wait函数相同，也可以通过下面进行分支处理：
//long  result = dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10*NSEC_PER_SEC)));
//
// if (result == 0){
//      //进行排他控制的处理代码...
//      //将dispatch semphore的计数器减1
//      [array addObject:[NSNumber numberWithInteger:i]];
//
//      //排他控制处理结束
//      //将dispatch semphore的计数器加1
//      //如果有通过dispatch_semaphore_wait函数dispatch semphore的计数值增加的线程，等待就由最先等待的线程执行
//      dispatch_semaphore_signal(semaphore);
//}else{
//      //这个时候计数值为0，在达到指定时间为止还是等待状态。
//        //处理逻辑....
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
