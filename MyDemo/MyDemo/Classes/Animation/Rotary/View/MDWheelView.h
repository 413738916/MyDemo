//
//  MDWheelView.h
//  MyDemo
//
//  Created by 123 on 2017/12/11.
//  Copyright © 2017年 ct. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDWheelView : UIView

+ (instancetype)wheelView;

// 开始旋转
- (void)startRotating;

// 停止旋转
- (void)stopRotating;

@end
