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

 */

#import "GCDViewController.h"

@interface GCDViewController ()

@end

@implementation GCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"GCD";
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
