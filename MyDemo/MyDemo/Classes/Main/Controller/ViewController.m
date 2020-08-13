//
//  ViewController.m
//  MyDemo
//
//  Created by 123 on 2017/12/6.
//  Copyright © 2017年 ct. All rights reserved.
//

#import "ViewController.h"

#import "MDBaseCModel.h"
#import "MDModalC.h"
#import "MDPushC.h"

#import "MDPresentTransitionAnimated.h"
#import "MDDismissTransitionAnimated.h"
#import "MDTemp.h"

@interface ViewController () <UITableViewDataSource,UITableViewDelegate,UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) UITableView *tabview;

@property (nonatomic, strong) NSArray *exampleArray;

@property (nonatomic, retain) UIPercentDrivenInteractiveTransition *percentDrivenTransition;

@end

@implementation ViewController

+ (void)initialize {
    if (self == [ViewController class]) {
        
        UINavigationBar *navBar = [UINavigationBar appearance];
        navBar.tintColor = [UIColor whiteColor];
        [navBar setBackgroundImage:[UIImage imageNamed:@"NavBar64"] forBarMetrics:UIBarMetricsDefault];
        [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title = @"目录";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tabview];
    
}

- (NSArray *)exampleArray {
    if (!_exampleArray) {
        MDPushC *blockVC = [[MDPushC alloc]initWithName:@"Block" classStr:@"TTBlockController"];
        MDPushC *vc1 = [[MDPushC alloc]initWithName:@"HitTest" classStr:@"MDHItTestController"];
        MDPushC *vc2 = [[MDPushC alloc]initWithName:@"手势解锁" classStr:@"GesturesToUnlockController"];
        MDPushC *vc3 = [[MDPushC alloc]initWithName:@"画板" classStr:@"MDDrawingBoardController"];
        MDPushC *vc4 = [[MDPushC alloc]initWithName:@"动画" classStr:@"MDAnimationController"];
        MDPushC *vc5 = [[MDPushC alloc]initWithName:@"多线程" classStr:@"MD_GCDMainController"];
        MDModalC *vc6 = [[MDModalC alloc]initWithName:@"抽屉" classStr:@"MDDrawerController"];
        MDPushC *vc7 = [[MDPushC alloc]initWithName:@"temp" classStr:@"MDTemp"];
        _exampleArray = @[blockVC, vc1, vc2, vc3, vc4, vc5, vc6,vc7] ;
        
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
    return self.exampleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"example";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    MDBaseCModel *model = self.exampleArray[indexPath.row];
    cell.textLabel.text = model.title;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MDBaseCModel *model = self.exampleArray[indexPath.row];
    if ([model isKindOfClass:[MDPushC class]]) {
        [self pushToViewController:model];
    }
    else if ([model isKindOfClass:[MDModalC class]]) {
        [self modelPushViewController:model];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)pushToViewController:(MDBaseCModel *)model {
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    Class class = model.vcClass;
    UIViewController *vc = [[class alloc] init];
    NSString *nibPath = [[NSBundle mainBundle] pathForResource:NSStringFromClass(class) ofType:@"nib"];
    if (nibPath != nil) {
        vc = [[class alloc] initWithNibName:NSStringFromClass(class) bundle:nil];
    }
    vc.navigationItem.title = model.title;
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)modelPushViewController:(MDBaseCModel *)model {
    Class class = model.vcClass;
    UIViewController *presentVC = [[class alloc] init];
    NSString *nibPath = [[NSBundle mainBundle] pathForResource:NSStringFromClass(class) ofType:@"nib"];
    if (nibPath != nil) {
        presentVC = [[class alloc] initWithNibName:NSStringFromClass(class) bundle:nil];
    }

    presentVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    presentVC.transitioningDelegate = self;
    [self addScreenLeftEdgePanGestureRecognizer:presentVC.view];
    [self presentViewController:presentVC animated:YES completion:nil];
    
}

- (void)addScreenLeftEdgePanGestureRecognizer:(UIView *)view{
    UIScreenEdgePanGestureRecognizer *screenEdgePan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePanGesture:)];
    screenEdgePan.edges = UIRectEdgeLeft;
    [view addGestureRecognizer:screenEdgePan];
}

- (void)edgePanGesture:(UIScreenEdgePanGestureRecognizer *)edgePan{
    CGFloat progress = fabs([edgePan translationInView:[UIApplication sharedApplication].keyWindow].x/[UIApplication sharedApplication].keyWindow.bounds.size.width);
    if (edgePan.state == UIGestureRecognizerStateBegan) {
        self.percentDrivenTransition = [[UIPercentDrivenInteractiveTransition alloc]init];
        if (edgePan.edges == UIRectEdgeLeft) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }else if (edgePan.state == UIGestureRecognizerStateChanged){
        [self.percentDrivenTransition updateInteractiveTransition:progress];
    }else if (edgePan.state == UIGestureRecognizerStateEnded || edgePan.state == UIGestureRecognizerStateCancelled){
        if (progress > 0.5) {
            [_percentDrivenTransition finishInteractiveTransition];
        }else{
            [_percentDrivenTransition cancelInteractiveTransition];
        }
        _percentDrivenTransition = nil;
    }
}

#pragma Mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return [[MDPresentTransitionAnimated alloc] init];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[MDDismissTransitionAnimated alloc] init];
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator{
    return _percentDrivenTransition;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator{
    return _percentDrivenTransition;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
