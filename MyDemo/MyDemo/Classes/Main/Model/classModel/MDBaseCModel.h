//
//  MDBaseCModel.h
//  MyDemo
//
//  Created by 123 on 2017/12/15.
//  Copyright © 2017年 ct. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDBaseCModel : NSObject

- (instancetype)initWithName:(NSString *)title classStr:(NSString *)classStr;

@property (nonatomic, strong, readonly) NSString *title;

@property (nonatomic, assign, readonly) Class vcClass;

@end
