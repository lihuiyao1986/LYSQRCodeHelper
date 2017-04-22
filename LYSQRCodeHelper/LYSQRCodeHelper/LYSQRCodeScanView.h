//
//  LYSQRCodeScanView.h
//  LYSQRCodeHelper
//
//  Created by jk on 2017/4/21.
//  Copyright © 2017年 Goldcard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYSQRCodeScanView : UIView


@property(nonatomic,assign)CGFloat scanX;

@property(nonatomic,assign)CGFloat scanY;

@property(nonatomic,assign)NSTimeInterval animInterval;

@property(nonatomic,assign,readonly)CGRect rectOfInterest;

-(void)startAnim;

-(void)endAnim;

@end
