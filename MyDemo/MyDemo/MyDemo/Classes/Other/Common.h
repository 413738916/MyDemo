//
//  Common.h
//  MyDemo
//
//  Created by 123 on 2017/12/6.
//  Copyright © 2017年 ct. All rights reserved.
//

#ifndef Common_h
#define Common_h

/*
 *日志输出
 */
#ifdef DEBUG
//调试状态
#define MyLog(...) NSLog(__VA_ARGS__)

#else
//发布状态
#define MyLog(...)

#endif


#define KScreenHeight [UIScreen mainScreen].bounds.size.height
#define KScreenWidth [UIScreen mainScreen].bounds.size.width



#endif /* Common_h */
