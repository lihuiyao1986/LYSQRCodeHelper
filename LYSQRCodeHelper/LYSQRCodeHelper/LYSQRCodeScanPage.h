//
//  LYSQRCodeScanPage.h
//  LYSQRCodeHelper
//
//  Created by jk on 2017/4/21.
//  Copyright © 2017年 Goldcard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYSQRCodeScanPage : UIViewController

#pragma mark - 扫描结果回调
@property(nonatomic,copy)void(^ScanResultBlock)(NSString *qrcode);

#pragma mark - 权限设置回调
@property(nonatomic,copy)BOOL(^AVRightBlock)();

@end
