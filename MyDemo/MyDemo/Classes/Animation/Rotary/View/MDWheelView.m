//
//  MDWheelView.m
//  MyDemo
//
//  Created by 123 on 2017/12/11.
//  Copyright © 2017年 ct. All rights reserved.
//

#import "MDWheelView.h"


@interface MDWheelButton : UIButton

@end

@implementation MDWheelButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    
    CGFloat imageW = 40;
    CGFloat imageH = 47;
    CGFloat imageX = (contentRect.size.width - imageW) * 0.5;
    CGFloat imageY = 20;
    
    return CGRectMake(imageX, imageY, imageW, imageH);
}

- (void)setHighlighted:(BOOL)highlighted {
}

@end

#define angle2radian(x) ((x) / 180.0 * M_PI)

@interface MDWheelView () <CAAnimationDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *rotationView;

@property (nonatomic, weak) UIButton *selectedButton;

@property (nonatomic, strong) CADisplayLink *link;

@end

@implementation MDWheelView

- (void)setFrame:(CGRect)frame {
    frame.size.height = 286;
    frame.size.width = 286;

    [super setFrame:frame];
}

+ (instancetype)wheelView {
    
    return [[NSBundle mainBundle] loadNibNamed:@"MDWheelView" owner:nil options:nil][0];
}

// 还有没连号线
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
        NSLog(@"initWithCoder----%@",_rotationView);
        
    }
    return self;
}

- (void)layoutSubviews {
   
    [super layoutSubviews];

}

// 连好线
- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    NSLog(@"---%@",NSStringFromCGRect(self.frame));
    NSLog(@"%f",[UIScreen mainScreen].scale);
    
    [self addBtns];
    
}

- (void)addBtns {
    _rotationView.userInteractionEnabled = YES;
    
    // 裁剪的大图片
    UIImage *bigImage = [UIImage imageNamed:@"LuckyAstrology"];
    UIImage *selectedImage = [UIImage imageNamed:@"LuckyAstrologyPressed"];
    
    CGFloat imgScale = [UIScreen mainScreen].scale > 1 ? 2 : 1;
    
    // 图片的尺寸
    CGFloat imageW = 40 * imgScale;
    CGFloat imageH = 47 * imgScale;
    
    for (int i = 0; i < 12; i++) {
        // 创建按钮
        MDWheelButton *button = [MDWheelButton buttonWithType:UIButtonTypeCustom];
        // 锚点
        button.layer.anchorPoint = CGPointMake(0.5, 1);
        // 位置
        button.layer.position = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
        // 旋转按钮
        button.layer.transform = CATransform3DMakeRotation(angle2radian(i * 30), 0, 0, 1);
        // 尺寸
        button.bounds = CGRectMake(0, 0, 68, 143);
        // 设置选中时候的背景图片
        [button setBackgroundImage:[UIImage imageNamed:@"LuckyRototeSelected"] forState:UIControlStateSelected];
        // 设置按钮的图片
        // image:裁剪的图片
        // rect:裁剪的尺寸
        CGRect clipRect = CGRectMake(i * imageW, 0, imageW, imageH);
        CGImageRef smallImage = CGImageCreateWithImageInRect(bigImage.CGImage, clipRect);
        [button setImage:[UIImage imageWithCGImage:smallImage] forState:UIControlStateNormal];
        
        // 设置选中的图片
        CGImageRef selectedSmallImage = CGImageCreateWithImageInRect(selectedImage.CGImage, clipRect);
        [button setImage:[UIImage imageWithCGImage:selectedSmallImage] forState:UIControlStateSelected];
        
        // 监听点击事件
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
        
        if (i == 0) {
            [self btnClick:button];
        }
        
        [_rotationView addSubview:button];
    }

}

#pragma mark  监听按钮点击
- (void)btnClick:(UIButton *)button {
    _selectedButton.selected = NO;
    button.selected = YES;
    _selectedButton = button;
}

#pragma mark 开始旋转
- (void)startRotating
{
    self.link.paused = NO;
    
}

- (void)stopRotating
{
    _link.paused = YES;
}

- (CADisplayLink *)link
{
    
    if (_link == nil) {
        CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
        
        [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        _link = link;
    }
    return _link;
}
// 60  45 / 60.0
- (void)update {
    
    _rotationView.transform = CGAffineTransformRotate(_rotationView.transform, angle2radian(45 / 60.0));
}

- (IBAction)start:(id)sender {
    
    // 1.不要和用户交互
    _rotationView.userInteractionEnabled = NO;
    
    // 2.取消慢慢的旋转
    [self stopRotating];
    
    CABasicAnimation *anim = [CABasicAnimation animation];
    
    anim.keyPath = @"transform.rotation";
    
    anim.toValue = @(M_PI * 2 * 3);
    
    anim.duration = 0.5;
    
    anim.delegate = self;
    
    [_rotationView.layer addAnimation:anim forKey:nil];

}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    _rotationView.userInteractionEnabled = YES;

    // 让选中按钮回到最在上面的中间位置:
    CGFloat angle = atan2(_selectedButton.transform.b, _selectedButton.transform.a);
    
    NSLog(@"%f",angle);
    
    // 把我们的转盘反向旋转这么多°
    _rotationView.transform = CGAffineTransformMakeRotation(-angle);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startRotating];
    });
}

@end
