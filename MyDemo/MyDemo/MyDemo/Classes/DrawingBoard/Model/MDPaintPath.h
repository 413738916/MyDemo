//
//  MDPaintPath.h
//  MyDemo
//
//  Created by 123 on 2017/12/7.
//  Copyright © 2017年 ct. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDPaintPath : UIBezierPath

@property (nonatomic, strong) UIColor *color;

+ (instancetype)paintPathWithLineWidth:(CGFloat)width color:(UIColor *)color startPoint:(CGPoint)startP;

@end
