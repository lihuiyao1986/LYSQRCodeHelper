//
//  UIImage+LYSQRCodeHelper.m
//  LYSQRCodeHelper
//
//  Created by jk on 2017/4/23.
//  Copyright © 2017年 Goldcard. All rights reserved.
//

#import "UIImage+LYSQRCodeHelper.h"

@implementation UIImage (LYSQRCodeHelper)

#pragma mark - 返回一张不超过屏幕尺寸的 image
+ (UIImage *)imageSizeWithScreenImage:(UIImage *)image {
    
    CGFloat imageWidth = image.size.width;
    
    CGFloat imageHeight = image.size.height;
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    // 如果读取的二维码照片宽和高小于屏幕尺寸，直接返回原图片
    if (imageWidth <= screenWidth && imageHeight <= screenHeight) {
        return image;
    }
    
    NSLog(@"压缩前图片尺寸 － width：%.2f, height: %.2f", imageWidth, imageHeight);
    
    CGFloat max = MAX(imageWidth, imageHeight);
    
    // 如果是6plus等设备，比例应该是 3.0
    CGFloat scale = max / (screenHeight * 2.0f);
    
    NSLog(@"压缩后图片尺寸 － width：%.2f, height: %.2f", imageWidth / scale, imageHeight / scale);
    
    return [UIImage imageWithImage:image scaledToSize:CGSizeMake(imageWidth / scale, imageHeight / scale)];
}

#pragma mark -  返回一张处理后的图片
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


@end
