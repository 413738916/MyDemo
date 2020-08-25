//
//  MD_GCDMainController.m
//  MyDemo
//
//  Created by 陈彤 on 2020/8/13.
//  Copyright © 2020 ct. All rights reserved.
//

#import "MD_GCDMainController.h"

@interface MD_GCDMainController ()

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *exampleArray;

@end

@implementation MD_GCDMainController

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"NSThread", @"GCD", @"转盘"];
    }
    return _titleArray;
}

- (NSArray *)exampleArray {
    if (!_exampleArray) {
        _exampleArray = @[@"MD_NSThreadController", @"MD_GCDController", @"MDRotaryController"];
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    NSString *classStr = self.exampleArray[indexPath.row];
    Class class =  NSClassFromString(classStr);
    UIViewController *vc = [[class alloc] init];
    
    NSString *nibPath = [[NSBundle mainBundle] pathForResource:classStr ofType:@"nib"];
    if (nibPath != nil) {
        vc = [[NSClassFromString(classStr) alloc] initWithNibName:classStr bundle:nil];
    }
    
    vc.navigationItem.title = self.titleArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
