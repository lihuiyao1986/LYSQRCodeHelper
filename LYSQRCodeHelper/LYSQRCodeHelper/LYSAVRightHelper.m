//
//  LYSAVRightHelper.m
//  LYSQRCodeHelper
//
//  Created by jk on 2017/4/23.
//  Copyright © 2017年 Goldcard. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "LYSAVRightHelper.h"
#import "LYSAlertView.h"

@implementation LYSAVRightHelper

#pragma mark - 是否有av权限
+(BOOL)hasAVRight{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    BOOL result = NO;
    switch (status) {
        case AVAuthorizationStatusAuthorized:
            result = YES;
            break;
        default:
            break;
    }
    return result;
}

#pragma mark - 是否有手电筒权限
+(BOOL)hasTorchRight{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (!device.hasTorch) {
        LYSAlertView *alertView = [[LYSAlertView alloc]initWithTitle:@"温馨提示" content: @"您暂未获取到手电筒权限"leftTitle:@"取消" rightTitle:@"确定"];
        [alertView showInView:[UIApplication sharedApplication].keyWindow];
        return NO;
    }
    return device.hasTorch;
}

#pragma mark - 是否能使用相册
+ (BOOL)isCanUsePhotos:(void(^)())grantBlock{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (grantBlock) {
                        grantBlock();
                    }
                });
            }];
            return NO;
        }else if (authStatus == AVAuthorizationStatusRestricted ){
            LYSAlertView *alertView = [[LYSAlertView alloc]initWithTitle:@"温馨提示" content: @"由于系统原因, 无法访问相册"leftTitle:@"取消" rightTitle:@"确定"];
            [alertView showInView:[UIApplication sharedApplication].keyWindow];
            return NO;
        } else if(authStatus == AVAuthorizationStatusDenied) {
            LYSAlertView *alertView = [[LYSAlertView alloc]initWithTitle:@"温馨提示" content: @"请去-> [设置 - 隐私 - 照片] 打开访问开关"leftTitle:@"取消" rightTitle:@"确定"];
            [alertView showInView:[UIApplication sharedApplication].keyWindow];
            //无权限
            return NO;
        }else{
            return YES;
        }
    }
    else {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        
        if (status == PHAuthorizationStatusRestricted){
            LYSAlertView *alertView = [[LYSAlertView alloc]initWithTitle:@"温馨提示" content: @"由于系统原因, 无法访问相册"leftTitle:@"取消" rightTitle:@"确定"];
            [alertView showInView:[UIApplication sharedApplication].keyWindow];
            return NO;

        }else if(status == PHAuthorizationStatusDenied){
            LYSAlertView *alertView = [[LYSAlertView alloc]initWithTitle:@"温馨提示" content: @"请去-> [设置 - 隐私 - 照片] 打开访问开关"leftTitle:@"取消" rightTitle:@"确定"];
            [alertView showInView:[UIApplication sharedApplication].keyWindow];
            //无权限
            return NO;

        }else if(status == PHAuthorizationStatusNotDetermined){
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) { // 用户第一次同意了访问相册权限
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (grantBlock) {
                            grantBlock();
                        }
                    });
                }
            }];
            return NO;
        }else{
            return YES;
        }
    }
}

@end
