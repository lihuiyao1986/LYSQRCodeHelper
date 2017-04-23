//
//  LYSAVRightHelper.h
//  LYSQRCodeHelper
//
//  Created by jk on 2017/4/23.
//  Copyright © 2017年 Goldcard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYSAVRightHelper : NSObject

#pragma mark - 是否有av权限
+(BOOL)hasAVRight;

#pragma mark - 是否有手电筒权限
+(BOOL)hasTorchRight;

#pragma mark - 是否能使用相册
+ (BOOL)isCanUsePhotos:(void(^)())grantBlock;

@end
