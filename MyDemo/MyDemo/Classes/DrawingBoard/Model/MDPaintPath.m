//
//  MDPaintPath.m
//  MyDemo
//
//  Created by 123 on 2017/12/7.
//  Copyright © 2017年 ct. All rights reserved.
//

#import "MDPaintPath.h"

@implementation MDPaintPath

+ (instancetype)paintPathWithLineWidth:(CGFloat)width color:(UIColor *)color startPoint:(CGPoint)startP {
    
    MDPaintPath *path = [[self alloc] init];
    path.lineWidth = width;
    path.color = color;
    [path moveToPoint:startP];
    
    return path;
}

@end
