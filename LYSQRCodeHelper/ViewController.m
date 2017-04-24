//
//  ViewController.m
//  LYSQRCodeHelper
//
//  Created by jk on 2017/4/21.
//  Copyright © 2017年 Goldcard. All rights reserved.
//

#import "ViewController.h"
#import "LYSQRCodeScanPage.h"
#import "LYSAVRightHelper.h"
#import "LYSAlertView.h"
#import "CreateQRCodePage.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor  = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.tag  = 1000;
    btn.frame = CGRectMake(20, 120, CGRectGetWidth(self.view.frame) - 40.f, 44.f);
    [btn setTitle:@"扫描二维码" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    UIButton *btn1= [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.titleLabel.font = [UIFont systemFontOfSize:14];
    btn1.tag  = 10000;
    btn1.frame = CGRectMake(20, CGRectGetMaxY(btn.frame) + 60, CGRectGetWidth(self.view.frame) - 40.f, 44.f);
    [btn1 setTitle:@"生成二维码" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view addSubview:btn1];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)btnClicked:(UIButton*)sender{
    NSUInteger tag = sender.tag;
    if (tag == 1000){
        if ([LYSAVRightHelper hasAVRight]) {
            LYSQRCodeScanPage *page = [[LYSQRCodeScanPage alloc]init];
            page.ScanResultBlock = ^(NSString *result){
                LYSAlertView * alertView = [[LYSAlertView alloc]initWithTitle:@"温馨提示" content:result leftTitle:@"取消" rightTitle:@"确定"];
                [alertView showInView:[UIApplication sharedApplication].keyWindow];
            };
            [self.navigationController pushViewController:page animated:YES];
        }else{
            LYSAlertView * alertView = [[LYSAlertView alloc]initWithTitle:@"温馨提示" content:@"您没有权限" leftTitle:@"取消" rightTitle:@"确定"];
            alertView.leftBlock = ^(){
                
            };
            [alertView showInView:self.view];
        }
    }else{
        [self.navigationController pushViewController:[CreateQRCodePage new] animated:YES];
    }
   
}

#pragma mark - 返回
-(void)goback{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
