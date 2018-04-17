//
//  MDDrawerController.m
//  MyDemo
//
//  Created by 123 on 2017/12/15.
//  Copyright © 2017年 ct. All rights reserved.
//

#import "MDDrawerController.h"

@interface MDDrawerController ()
{
    BOOL _isDraging;
}

@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, strong) UIView *mainView;

@end

@implementation MDDrawerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [self leftView];
    [self rightView];
    [self mainView];
    [self addGoBackBtn];
    NSLog(@"--------111%@",NSStringFromCGRect(self.view.bounds));
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    NSLog(@"========22%@",NSStringFromCGRect(self.view.bounds));
}

- (UIView *)leftView {
    if (!_leftView) {
        _leftView = [[UIView alloc] initWithFrame:self.view.bounds];
        _leftView.backgroundColor = [UIColor greenColor];
        [self.view addSubview:_leftView];
    }
    return _leftView;
}

- (UIView *)mainView {
    if (!_mainView) {
        _mainView= [[UIView alloc] initWithFrame:self.view.bounds];
        _mainView.backgroundColor = [UIColor redColor];
        [self.view addSubview:_mainView];
        [_mainView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _mainView;
}

- (UIView *)rightView {
    if (!_rightView) {
        _rightView = [[UIView alloc] initWithFrame:self.view.bounds];
        _rightView.backgroundColor = [UIColor orangeColor];
        [self.view addSubview:_rightView];
    }
    return _rightView;
}

- (void)addGoBackBtn {
    
    UIButton *goBackBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    goBackBtn.frame = CGRectMake(100, 100, 100, 100);
    [goBackBtn setBackgroundColor:[UIColor greenColor]];
    [goBackBtn setTitle:@"返回" forState:UIControlStateNormal];
    [goBackBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view addSubview:goBackBtn];
    [goBackBtn addTarget:self action:@selector(goBackBtnClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)goBackBtnClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 当监听的属性改变就会调用这个方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    //    NSLog(@"%@",NSStringFromCGRect(_mainView.frame));
    
    
    if (_mainView.frame.origin.x > 0) {
        _leftView.hidden = NO;
        _rightView.hidden = YES;
    }else if (_mainView.frame.origin.x < 0){
        _leftView.hidden = YES;
        _rightView.hidden = NO;
    }
    
}

// 监听手指的拖动,把触摸事件交给控制器处理
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    // 获取当前位置
    CGPoint location = [touch locationInView:self.view];
    // 获取上一次位置
    CGPoint prePoi = [touch previousLocationInView:self.view];
    
    // 获取x的偏移量
    CGFloat offsetX = location.x - prePoi.x;
    
    // 获取主视图的frame,移动主视图
    //    CGRect frame = _mainView.frame;
    //    frame.origin.x += offsetX;
    _mainView.frame = [self rectWithOffsetX:offsetX];;
    
    _isDraging = YES;
}



// 根据一个x偏移量算出视图的尺寸
#define kMaxY 60
- (CGRect)rectWithOffsetX:(CGFloat)offsetX
{
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    CGFloat offsetY = offsetX * kMaxY / screenW;
    
    CGFloat scale = (screenH - 2 * offsetY) / screenH;
    if (_mainView.frame.origin.x < 0) {
        scale = (screenH + 2 * offsetY) / screenH;
    }
    
    // 获取视图的frame
    CGRect frame = _mainView.frame;
    frame.origin.x += offsetX;
    frame.size.width = frame.size.width * scale;
    frame.size.height = frame.size.height * scale;
    frame.origin.y = (screenH - frame.size.height) * 0.5;
    
    return frame;
    
}


/*
 _mainView.frame.origin.x > screenW * 0.5 x = 250 frame
 CGRectGetMaxX(_mainView.frame) < screenW * 0.5 x = -220;
 
 */

#define kTargetR 250
#define kTargetL -220
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if (_isDraging == NO && _mainView.frame.origin.x != 0) {
        [UIView animateWithDuration:0.25 animations:^{
            
            _mainView.frame = self.view.bounds;
        }];
    }
    
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat target = 0;
    if (_mainView.frame.origin.x > screenW * 0.5) {
        target = kTargetR;
    }else if (CGRectGetMaxX(_mainView.frame) < screenW * 0.5){
        target = kTargetL;
    }
    CGFloat offsetX = target - _mainView.frame.origin.x;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        if (target == 0) {
            _mainView.frame = self.view.bounds;
        }else{
            
            _mainView.frame = [self rectWithOffsetX:offsetX];
        }
    }];
    
    
    _isDraging = NO;
    
    //    [self presentViewController:self animated:YES completion:nil
    //     ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_mainView removeObserver:self forKeyPath:@"frame"];
}

@end
