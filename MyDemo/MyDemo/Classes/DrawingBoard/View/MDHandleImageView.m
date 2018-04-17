//
//  MDHandleImageView.m
//  MyDemo
//
//  Created by 123 on 2017/12/7.
//  Copyright © 2017年 ct. All rights reserved.
//

#import "MDHandleImageView.h"

#import "UIImage+Tool.h"

@interface MDHandleImageView () <UIGestureRecognizerDelegate>

@property (nonatomic, weak) UIImageView *imageView;

@end

@implementation MDHandleImageView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // 添加UIImageView
        [self addImageView];
        
        // 添加手势
        [self addGestureRecognizers];
    }
    return self;
}

#pragma mark 添加图片
- (void)addImageView
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    
    imageView.userInteractionEnabled = YES;
    
    _imageView = imageView;
    [self addSubview:imageView];
}

#pragma mark - 添加手势
- (void)addGestureRecognizers {
    // 1.长按
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    
    [_imageView addGestureRecognizer:longPress];
    
    [self addPinch];
    [self addRotation];
}

#pragma mark 长按
- (void)longPress:(UILongPressGestureRecognizer *)longPrss
{
    if (longPrss.state == UIGestureRecognizerStateEnded) {
        
        [UIView animateWithDuration:0.5 animations:^{
            
            _imageView.alpha = 0.3;
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.5 animations:^{
                _imageView.alpha = 1;
            } completion:^(BOOL finished) {
                
                // 1.截屏
                UIImage *newImage = [UIImage imageWithCaptureView:self];
                
                // 2.把图片传给控制器
                self.HMHandleImageViewBlock(newImage);
                
                // 3.把自己移除父控件
                [self removeFromSuperview];
                
            }];
        }];
    }
}

#pragma mark - 捏合
- (void)addPinch
{
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    // 设置代理的原因：想要同时支持多个手势
    pinch.delegate = self;
    [_imageView addGestureRecognizer:pinch];
    
}

- (void)pinch:(UIPinchGestureRecognizer *)pinch
{
    _imageView.transform = CGAffineTransformScale(_imageView.transform, pinch.scale, pinch.scale);
    
    // 复位
    pinch.scale = 1;
}

// Simultaneous:同时
// 默认是不支持多个手势
// 当你使用一个手势的时候就会调用
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - 旋转
- (void)addRotation
{
    // rotation
    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotation:)];
    rotation.delegate = self;
    [_imageView addGestureRecognizer:rotation];
}

- (void)rotation:(UIRotationGestureRecognizer *)rotation
{
    
    //    _imagView.transform = CGAffineTransformMakeRotation(rotation.rotation);
    _imageView.transform = CGAffineTransformRotate(_imageView.transform, rotation.rotation);
    
    // 复位
    rotation.rotation = 0;
}

#pragma mark 传给一个图片就展示到UIImageView上
- (void)setImage:(UIImage *)image {
    
    _image = image;
    
    _imageView.image = image;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
