//
//  UIImage+LYSQRCodeHelper.h
//  LYSQRCodeHelper
//
//  Created by jk on 2017/4/23.
//  Copyright © 2017年 Goldcard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LYSQRCodeHelper)

#pragma mark - 返回一张不超过屏幕尺寸的 image
+ (UIImage *)imageSizeWithScreenImage:(UIImage *)image;

#pragma mark -  返回一张处理后的图片
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)size;

@end
