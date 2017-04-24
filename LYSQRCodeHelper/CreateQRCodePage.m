//
//  CreateQRCodePage.m
//  LYSQRCodeHelper
//
//  Created by jk on 2017/4/24.
//  Copyright © 2017年 Goldcard. All rights reserved.
//

#import "CreateQRCodePage.h"
#import "LYSQRCodeGenerator.h"

@interface CreateQRCodePage ()

@property(nonatomic,strong)UIImageView *normalQRCode;

@property(nonatomic,strong)UIImageView *logoQRCode;

@property(nonatomic,strong)UIImageView *colorfulQRCode;

@end

@implementation CreateQRCodePage

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的二维码";
    [self.view addSubview:self.normalQRCode];
    [self.view addSubview:self.logoQRCode];
    [self.view addSubview:self.colorfulQRCode];
    self.normalQRCode.image = [LYSQRCodeGenerator createNormalQRCode:@"http://www.baidu.com" imageWidth:100.f];

    // Do any additional setup after loading the view.
}

-(UIImageView*)normalQRCode{
    if (!_normalQRCode) {
        _normalQRCode = [[UIImageView alloc]initWithFrame:CGRectMake(0, 120, CGRectGetWidth(self.view.frame), 80)];
        _normalQRCode.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _normalQRCode;
}

-(UIImageView*)logoQRCode{
    if (!_logoQRCode) {
        _logoQRCode = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.normalQRCode.frame) + 20, CGRectGetWidth(self.view.frame), 80)];
    }
    return _logoQRCode;
}

-(UIImageView*)colorfulQRCode{
    if (!_colorfulQRCode) {
        _colorfulQRCode = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.logoQRCode.frame) + 20, CGRectGetWidth(self.view.frame), 80)];
    }
    return _colorfulQRCode;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
