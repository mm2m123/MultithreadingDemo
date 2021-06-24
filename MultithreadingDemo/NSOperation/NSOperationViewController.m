//
//  NSOperationViewController.m
//  MultithreadingDemo
//
//  Created by 张毅成 on 2021/6/24.
//

#import "NSOperationViewController.h"

@interface NSOperationViewController ()

@end

@implementation NSOperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"NSOperation";
    [self blockOperationAddTask];
}

- (void)invocationOperation {
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(run) object:nil];
    op.completionBlock = ^ {
        NSLog(@"任务完成后回调block");
    };
    [op start];
}

- (void)run {
    NSLog(@"----%@",[NSThread currentThread]);
}

- (void)blockOperationAddTask {
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^ {
        NSLog(@"I'm running---%@",[NSThread currentThread].description);
    }];
    for (int i = 0; i < 20; i++) {
        [op addExecutionBlock:^{
            NSLog(@"added block running---%@",[NSThread currentThread].description);
        }];
    }
    NSLog(@"op start");
    [op start];
    NSLog(@"op end");
}

@end
