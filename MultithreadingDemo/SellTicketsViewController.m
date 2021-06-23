//
//  SellTicketsViewController.m
//  MultithreadingDemo
//
//  Created by 张毅成 on 2021/6/10.
//

#import "SellTicketsViewController.h"

@interface SellTicketsViewController () {
    NSInteger tickets;//总票数
    NSInteger count;//当前卖出去的票数
}

@property (nonatomic, strong) NSThread* ticketsThreadOne;
@property (nonatomic, strong) NSThread* ticketsThreadTwo;
@property (nonatomic, strong) NSLock* ticketsLock;
@end

@implementation SellTicketsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    tickets = 100;
    count = 0;
    
    //锁对象
    self.ticketsLock = [[NSLock alloc] init];
    
    self.ticketsThreadOne = [[NSThread alloc] initWithTarget:self selector:@selector(sellAction) object:nil];
    self.ticketsThreadOne.name = @"thread-1";
    
    self.ticketsThreadTwo = [[NSThread alloc] initWithTarget:self selector:@selector(sellAction) object:nil];
    self.ticketsThreadTwo.name = @"thread-2";
}
- (IBAction)startSell:(id)sender {
    [self.ticketsThreadOne start];
    [self.ticketsThreadTwo start];

}

- (void)sellAction {
    while (true) {
        //上锁
        [self.ticketsLock lock];
        if (tickets > 0) {
//            [NSThread sleepForTimeInterval:0.5];
            count = 100 - tickets;
            NSLog(@"当前总票数是：%ld----->卖出：%ld------>线程名：%@",tickets,count,[NSThread currentThread]);
            tickets --;
        }else {
            break;
        }
        //解锁
        [self.ticketsLock unlock];
    }
}
@end
