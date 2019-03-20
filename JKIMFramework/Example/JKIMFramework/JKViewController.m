//
//  JKViewController.m
//  JKIMFramework
//
//  Created by ilucklyzhengwen@163.com on 03/14/2019.
//  Copyright (c) 2019 ilucklyzhengwen@163.com. All rights reserved.
//

#import "JKViewController.h"

#import <JKFloatBallManager.h>
@interface JKViewController ()

@end

@implementation JKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    [[JKFloatBallManager shared] showFloatBall];
        
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
