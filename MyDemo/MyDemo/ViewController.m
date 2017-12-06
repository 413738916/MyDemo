//
//  ViewController.m
//  MyDemo
//
//  Created by 123 on 2017/12/6.
//  Copyright © 2017年 ct. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tabview;

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *exampleArray;

@end

@implementation ViewController

+ (void)initialize {
    
    UINavigationBar *navBar = [UINavigationBar appearance];
    navBar.tintColor = [UIColor whiteColor];
    [navBar setBackgroundImage:[UIImage imageNamed:@"NavBar64"] forBarMetrics:UIBarMetricsDefault];
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title = @"目录";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tabview];
    
}

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"手势解锁"];
    }
    return _titleArray;
}

- (NSArray *)exampleArray {
    if (!_exampleArray) {
        _exampleArray = @[@"GesturesToUnlockController"];
    }
    return _exampleArray;
}

- (UITableView *)tabview {
    if (!_tabview) {
        _tabview = [[UITableView alloc]initWithFrame:self.view.bounds];
        _tabview.dataSource = self;
        _tabview.delegate = self;
        _tabview.showsHorizontalScrollIndicator = NO;
        
        _tabview.tableFooterView = [[UIView alloc]init];
        
    }
    return _tabview;
}

#pragma mark - UITableViewDataSource,UITableViewDelegate

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
    
    [self.navigationController pushViewController:[[class alloc]init] animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
