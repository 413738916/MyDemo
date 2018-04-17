//
//  MDSimpleAnimationController.m
//  MyDemo
//
//  Created by 123 on 2017/12/11.
//  Copyright © 2017年 ct. All rights reserved.
//

#import "MDSimpleAnimationController.h"

@interface MDSimpleAnimationController ()

@property (nonatomic, strong) CALayer *heartLayer;

@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) CAKeyframeAnimation *iconKeyAnimation;

@end

@implementation MDSimpleAnimationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self heartAnimation];
    
    [self iconImgView];
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc]initWithFrame:CGRectMake(66, 166, 100, 100)];
        NSString *imageName = [[[[NSBundle mainBundle] infoDictionary]valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
        _iconImgView.image = [UIImage imageNamed:imageName];
        [self.view addSubview:_iconImgView];
        
        _iconImgView.userInteractionEnabled = YES;
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        
        [_iconImgView addGestureRecognizer:longPress];
    }
    return _iconImgView;
}

- (CALayer *)heartLayer {
    if (!_heartLayer) {
        
        _heartLayer = [CALayer layer];
        
        _heartLayer.position = CGPointMake(222, 222);
        _heartLayer.bounds = CGRectMake(0, 0, 100, 100);
        _heartLayer.contents = (id)[UIImage imageNamed:@"an_heart"].CGImage;

        [self.view.layer addSublayer:_heartLayer];
    }
    return _heartLayer;
}

#pragma mark - 开始动画
- (IBAction)start:(UIButton *)sender {
    
    if ([[sender titleForState:0] isEqualToString:@"开始"]) {
        [sender setTitle:@"暂停" forState:0];
        
        [self startAnimtion:self.heartLayer];
        
        [_iconImgView.layer addAnimation:_iconKeyAnimation forKey:@"iconAnimation"];
        
    }
    else {
        [sender setTitle:@"开始" forState:0];
        
        [self pauseAnimtion:self.heartLayer];
        [_iconImgView.layer removeAnimationForKey:@"iconAnimation"];
        
    }
    
}

#pragma mark - 开始动画
- (void)startAnimtion:(CALayer *)layer {
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}

#pragma mark - 暂停动画
- (void)pauseAnimtion:(CALayer *)layer {
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

- (void)longPress:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        
        [self iconAnimation];
    }
}

#define angle2radian(x) ((x) / 180.0 * M_PI)

- (void)iconAnimation {
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    
    anim.keyPath = @"transform.rotation";
    
    anim.values = @[@(angle2radian(-10)),@(angle2radian(10)),@(angle2radian(-10))];
    
    anim.repeatCount = MAXFLOAT;
    
    anim.duration = 0.5;
    
    [_iconImgView.layer addAnimation:anim forKey:@"iconAnimation"];
    
    _iconKeyAnimation = anim;
}

- (void)heartAnimation {

    // 创建动画对象
    CABasicAnimation *anim = [CABasicAnimation animation];
    
    // 设置动画的属性
    anim.keyPath = @"transform.scale";
    
    // 设置属性改变的值
    anim.toValue = @0.5;
    
    // 设置动画时长
    anim.duration = 0.25;
    
    // 取消反弹
    // 动画执行完毕之后不要把动画移除
    anim.removedOnCompletion = NO;
    
    // 保持最新的位置
    anim.fillMode = kCAFillModeForwards;
    
    // 重复动画的次数
    anim.repeatCount = MAXFLOAT;
    
    // 给图层添加了动画
    [self.heartLayer addAnimation:anim forKey:nil];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
