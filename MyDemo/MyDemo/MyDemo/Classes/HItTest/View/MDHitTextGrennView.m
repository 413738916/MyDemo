//
//  MDHitTextGrennView.m
//  MyDemo
//
//  Created by 123 on 2017/12/15.
//  Copyright © 2017年 ct. All rights reserved.
//

#import "MDHitTextGrennView.h"

@implementation MDHitTextGrennView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%s",__func__);
}

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    // 把自己的点转换按钮的坐标系上的点
//    CGPoint buttonPoint = [self convertPoint:point toView:_button];
//
//    if ([_button pointInside:buttonPoint withEvent:event]) return nil;
//
//
//    return [super hitTest:point withEvent:event];
//}


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    // 把左边控件上的点转换为右边上边控件的点
    //    CGPoint buttonPoint = [self convertPoint:point toView:_button];
    
    // 从右边这个view上的点转换为坐标上的点
    CGPoint buttonPoint = [_button convertPoint:point fromView:self];
    if ([_button pointInside:buttonPoint withEvent:event]) {
        return NO;
    }
    
    return [super pointInside:point withEvent:event];
}


@end
