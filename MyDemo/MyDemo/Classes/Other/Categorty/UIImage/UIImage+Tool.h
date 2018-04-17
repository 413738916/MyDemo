//
//  UIImage+Tool.h
//  MyCategories
//
//  Created by 123 on 2017/12/5.
//  Copyright © 2017年 ct. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Tool)

/**
 *  生成一个带圆环的图片
 *
 *  @param name   图片的名称
 *  @param border 圆环的宽度
 *  @param color  圆环的颜色
 *
 */
+ (instancetype)imageWithName:(NSString *)name border:(CGFloat)border borderColor:(UIColor *)color;

/**
 *  截屏
 *
 *  @param view 需要截屏的视图
 *
 */
+ (instancetype)imageWithCaptureView:(UIView *)view;


@end
