//
//  ViewController.m
//  LYSQRCodeHelper
//
//  Created by jk on 2017/4/21.
//  Copyright © 2017年 Goldcard. All rights reserved.
//

#import "ViewController.h"
#import "LYSQRCodeScanPage.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.frame = CGRectMake(20, 120, CGRectGetWidth(self.view.frame) - 40.f, 44.f);
    [btn setTitle:@"扫描二维码" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)btnClicked:(UIButton*)sender{
    [self presentViewController:[[LYSQRCodeScanPage alloc] init] animated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
