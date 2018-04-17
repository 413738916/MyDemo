//
//  MDPaintView.m
//  MyDemo
//
//  Created by 123 on 2017/12/7.
//  Copyright © 2017年 ct. All rights reserved.
//

#import "MDPaintView.h"

#import "MDPaintPath.h"

@interface MDPaintView ()

@property (nonatomic, strong) UIBezierPath *path;

@property (nonatomic, strong) NSMutableArray *paths;

@end

@implementation MDPaintView

- (NSMutableArray *)paths {
    if (_paths == nil) {
        _paths = [NSMutableArray array];
    }
    return _paths;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _width = 2;
}

- (void)drawRect:(CGRect)rect {
    if (!self.paths.count) return;
    
    // 遍历所有的路径绘制
    for (MDPaintPath *path in self.paths) {
        
        if ([path isKindOfClass:[UIImage class]]) { // UIImage
            UIImage *image = (UIImage *)path;
            [image drawAtPoint:CGPointZero];
        } else { // HMPaintPath
            [path.color set];
            [path stroke];
        }
    }
}

// 获取触摸点
- (CGPoint)pointWithTouches:(NSSet *)touches {
    
    UITouch *touch = [touches anyObject];
    return [touch locationInView:self];
    
}

#pragma mark 确定起点

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
   
    // 获取触摸点
    CGPoint pos = [self pointWithTouches:touches];
    
    // 创建路径
    MDPaintPath *path = [MDPaintPath paintPathWithLineWidth:_width color:_color startPoint:pos];
    
    _path = path;
    [self.paths addObject:path];
}

#pragma mark 确定路径终点

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    // 获取触摸点
    CGPoint pos = [self pointWithTouches:touches];
    
    // 确定终点
    [_path addLineToPoint:pos];
    
    // 重绘
    [self setNeedsDisplay];

}

#pragma mark 清屏

- (void)clearScreen {
    [self.paths removeAllObjects];
    
    // 重绘
    [self setNeedsDisplay];
}

#pragma mark  撤销

- (void)undo {
    
    [self.paths removeLastObject];
    
    // 重绘
    [self setNeedsDisplay];
}

#pragma mark - 设置图片，就把图片画在画板上
- (void)setImage:(UIImage *)image {
    _image = image;
    
    [self.paths addObject:image];
    
    [self setNeedsDisplay];
}

@end
