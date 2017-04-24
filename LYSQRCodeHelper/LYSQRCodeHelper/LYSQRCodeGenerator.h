//
//  LYSQRCodeGenerator.h
//  LYSQRCodeHelper
//
//  Created by jk on 2017/4/24.
//  Copyright © 2017年 Goldcard. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreImage/CoreImage.h>

#import <AVFoundation/AVFoundation.h>

@interface LYSQRCodeGenerator : NSObject

#pragma mark - 生成一张普通的二维码
+ (UIImage *)createNormalQRCode:(NSString *)data imageWidth:(CGFloat)imageWidth;

#pragma mark - 生成一张带有logo的二维码（logoScaleToSuperView：相对于父视图的缩放比取值范围0-1；0，不显示，1，代表与父视图大小相同）
+ (UIImage *)createWithLogoQRCodeData:(NSString *)data logoImageName:(NSString *)logoImageName logoScaleToSuperView:(CGFloat)logoScaleToSuperView;

#pragma mark - 生成一张彩色的二维码
+ (UIImage *)createWithColorQRCodeData:(NSString *)data backgroundColor:(CIColor *)backgroundColor mainColor:(CIColor *)mainColor;

@end
