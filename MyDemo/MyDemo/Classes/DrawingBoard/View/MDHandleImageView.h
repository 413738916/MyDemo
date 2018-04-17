//
//  MDHandleImageView.h
//  MyDemo
//
//  Created by 123 on 2017/12/7.
//  Copyright © 2017年 ct. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDHandleImageView : UIView

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, copy) void(^HMHandleImageViewBlock)(UIImage *image);

@end
