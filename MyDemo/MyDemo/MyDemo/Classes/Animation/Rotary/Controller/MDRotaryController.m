//
//  MDRotaryController.m
//  MyDemo
//
//  Created by 123 on 2017/12/11.
//  Copyright © 2017年 ct. All rights reserved.
//

#import "MDRotaryController.h"

#import "MDWheelView.h"

@interface MDRotaryController ()

@property (nonatomic, weak) MDWheelView *wheelView;

@end

@implementation MDRotaryController

- (IBAction)start:(id)sender {
    [_wheelView startRotating];
}
- (IBAction)stop:(id)sender {
    [_wheelView stopRotating];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    MDWheelView *wheel = [MDWheelView wheelView];

    wheel.frame = CGRectMake(self.navigationController.view.center.x - 286 * 0.5, 120, 0, 0);
    
    [self.view addSubview:wheel];
    
    _wheelView = wheel;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
