//
//  MDAnimationController.m
//  MyDemo
//
//  Created by 123 on 2017/12/8.
//  Copyright © 2017年 ct. All rights reserved.
//

#import "MDAnimationController.h"

@interface MDAnimationController ()

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *exampleArray;

@end

@implementation MDAnimationController

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"简单动画",@"时钟",@"转盘"];
    }
    return _titleArray;
}

- (NSArray *)exampleArray {
    if (!_exampleArray) {
        _exampleArray = @[@"MDSimpleAnimationController",@"MDClockController",@"MDRotaryController"];
    }
    return _exampleArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.showsHorizontalScrollIndicator = NO;
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"example";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = self.titleArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    NSString *classStr = self.exampleArray[indexPath.row];
    Class class =  NSClassFromString(classStr);
    
    UIViewController *vc = [[class alloc]init];
    vc.navigationItem.title = self.titleArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
