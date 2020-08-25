//
//  MDPaintView.h
//  MyDemo
//
//  Created by 123 on 2017/12/7.
//  Copyright © 2017年 ct. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDPaintView : UIView

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, strong) UIColor *color;

@property (nonatomic, strong) UIImage *image;

- (void)clearScreen;

- (void)undo;

@end
