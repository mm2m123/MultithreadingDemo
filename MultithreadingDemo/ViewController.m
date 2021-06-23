//
//  ViewController.m
//  MultithreadingDemo
//
//  Created by 张毅成 on 2021/6/10.
//

#import "ViewController.h"
#import "SellTicketsViewController.h"
#import "GCDViewController.h"
#import "NSThreadViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *arrayData;
@end

@implementation ViewController

- (NSMutableArray *)arrayData {
    if (!_arrayData) {
        _arrayData = @[@"NSThread", @"GCD", @"NSOperation"].mutableCopy;
    }
    return _arrayData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"多线程🧐";
    [self createTableView];
}

- (void)createTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    cell.textLabel.text = self.arrayData[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            NSThreadViewController *controller = [NSThreadViewController new];
            [self.navigationController pushViewController:controller animated:true];
        }
            break;
            
        default: {
            GCDViewController *controller = [GCDViewController new];
            [self.navigationController pushViewController:controller animated:true];
        }
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

@end
