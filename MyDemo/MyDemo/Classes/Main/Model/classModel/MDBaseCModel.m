//
//  MDBaseCModel.m
//  MyDemo
//
//  Created by 123 on 2017/12/15.
//  Copyright © 2017年 ct. All rights reserved.
//

#import "MDBaseCModel.h"

@implementation MDBaseCModel

- (instancetype)initWithName:(NSString *)title classStr:(NSString *)classStr {
    
    if (self = [super init]) {
    
        _title = title;
        
        _vcClass = NSClassFromString(classStr);
    }
    
    return self;
}

@end
