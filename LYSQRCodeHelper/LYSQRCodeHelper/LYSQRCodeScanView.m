//
//  LYSQRCodeScanView.m
//  LYSQRCodeHelper
//
//  Created by jk on 2017/4/21.
//  Copyright © 2017年 Goldcard. All rights reserved.
//

#import "LYSQRCodeScanView.h"
#import <AVFoundation/AVFoundation.h>

static CGFloat const maskAlpha = 0.4;

@interface LYSQRCodeScanView (){
    dispatch_source_t _timer;// 计时器
}

@property(nonatomic,strong)CALayer *topLayer;

@property(nonatomic,strong)CALayer *leftLayer;

@property(nonatomic,strong)CALayer *rightLayer;

@property(nonatomic,strong)CALayer *bottomLayer;

@property(nonatomic,strong)CALayer *scanLayer;

@property(nonatomic,strong)UILabel *tipLb;

@property(nonatomic,strong)UIButton *lightBtn;

@property(nonatomic,strong)UIButton *albumBtn;

@property(nonatomic,strong)UIImageView *leftTopImage;

@property(nonatomic,strong)UIImageView *rightTopImage;

@property(nonatomic,strong)UIImageView *leftBottomImage;

@property(nonatomic,strong)UIImageView *rightBottomImage;

@property(nonatomic,strong)UIImageView *scanLine;

@end

@implementation LYSQRCodeScanView


#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initConfig];
    }
    return self;
}

#pragma mark - 初始化
-(void)initConfig{
    [self setDefaults];
    [self.layer addSublayer:self.topLayer];
    [self.layer addSublayer:self.bottomLayer];
    [self.layer addSublayer:self.leftLayer];
    [self.layer addSublayer:self.rightLayer];
    [self.layer addSublayer:self.scanLayer];
    [self addSubview:self.tipLb];
    [self addSubview:self.lightBtn];
    [self addSubview:self.albumBtn];
    [self addSubview:self.leftTopImage];
    [self addSubview:self.rightTopImage];
    [self addSubview:self.leftBottomImage];
    [self addSubview:self.rightBottomImage];
    [self addSubview:self.scanLine];
}

#pragma mark - 开始动画
-(void)startAnim{
    [self endAnim];
    __weak typeof (self) MyWeakSelf = self;
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), self.animInterval * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        [MyWeakSelf doAnimate];
    });
    dispatch_resume(_timer);
}

#pragma mark - 开始动画
-(void)doAnimate{
    __weak typeof (self) MyWeakSelf = self;
    __block CGRect frame = self.scanLine.frame;
    static BOOL flag = YES;
    if (flag) {
        frame.origin.y = self.scanY;
        flag = NO;
        [UIView animateWithDuration:MyWeakSelf.animInterval animations:^{
            frame.origin.y += 5;
            MyWeakSelf.scanLine.frame = frame;
        } completion:nil];
    } else {
        if (self.scanLine.frame.origin.y >= self.scanY) {
            CGFloat scanContent_MaxY = self.scanY + CGRectGetHeight(self.scanLayer.frame);
            if (self.scanLine.frame.origin.y >= scanContent_MaxY - 10) {
                frame.origin.y = self.scanY;
                self.scanLine.frame = frame;
                flag = YES;
            } else {
                [UIView animateWithDuration:MyWeakSelf.animInterval animations:^{
                    frame.origin.y += 5;
                    MyWeakSelf.scanLine.frame = frame;
                } completion:nil];
            }
        } else {
            flag = !flag;
        }
    }

}

#pragma mark - 结束动画
-(void)endAnim{
    if (_timer) {
        dispatch_cancel(_timer);
        _timer = nil;
    }
}

#pragma mark - 设置默认值
-(void)setDefaults{
    _scanX = self.frame.size.width * 0.15;
    _scanY = self.frame.size.height * 0.24;
    _animInterval = 0.05;
}

-(CALayer*)topLayer{
    if (!_topLayer) {
        _topLayer = [CALayer new];
        _topLayer.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:maskAlpha].CGColor;
    }
    return _topLayer;
}

-(CALayer*)leftLayer{
    if (!_leftLayer) {
        _leftLayer = [CALayer new];
        _leftLayer.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:maskAlpha].CGColor;
    }
    return _leftLayer;
}

-(CALayer*)rightLayer{
    if (!_rightLayer) {
        _rightLayer = [CALayer new];
        _rightLayer.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:maskAlpha].CGColor;
    }
    return _rightLayer;
}

-(CALayer*)bottomLayer{
    if (!_bottomLayer) {
        _bottomLayer = [CALayer new];
        _bottomLayer.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:maskAlpha].CGColor;
    }
    return _bottomLayer;
}

-(CALayer*)scanLayer{
    if (!_scanLayer) {
        _scanLayer = [CALayer new];
        _scanLayer.backgroundColor = [UIColor clearColor].CGColor;
    }
    return _scanLayer;
}

-(UILabel*)tipLb{
    if (!_tipLb) {
        _tipLb = [UILabel new];
        _tipLb.backgroundColor = [UIColor clearColor];
        _tipLb.textAlignment = NSTextAlignmentCenter;
        _tipLb.font = [UIFont systemFontOfSize:14];
        _tipLb.textColor = [[UIColor whiteColor]colorWithAlphaComponent:0.8];
        _tipLb.text = @"将二维码/条码放入框内, 即可自动扫描";
        _tipLb.lineBreakMode = NSLineBreakByTruncatingMiddle;
    }
    return _tipLb;
}

-(UIButton*)lightBtn{
    if (!_lightBtn) {
        _lightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lightBtn setTitle:@"开灯" forState:UIControlStateNormal];
        [_lightBtn setTitle:@"关灯" forState:UIControlStateSelected];
        [_lightBtn setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.8] forState:UIControlStateNormal];
        [_lightBtn setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.8] forState:UIControlStateSelected];
        _lightBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _lightBtn.layer.masksToBounds = YES;
        [_lightBtn setBackgroundImage:[self colorToImage:[[UIColor blackColor] colorWithAlphaComponent:0.6]] forState:UIControlStateNormal];
        [_lightBtn setBackgroundImage:[self colorToImage:[[UIColor blackColor] colorWithAlphaComponent:0.5]] forState:UIControlStateSelected];
        [_lightBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lightBtn;
}

-(UIButton*)albumBtn{
    if (!_albumBtn) {
        _albumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_albumBtn setTitle:@"相册" forState:UIControlStateNormal];
        [_albumBtn setTitle:@"相册" forState:UIControlStateHighlighted];
        [_albumBtn setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.8] forState:UIControlStateNormal];
        [_albumBtn setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.8] forState:UIControlStateHighlighted];
        _albumBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _albumBtn.layer.masksToBounds = YES;
        [_albumBtn setBackgroundImage:[self colorToImage:[[UIColor blackColor] colorWithAlphaComponent:0.6]] forState:UIControlStateNormal];
        [_albumBtn setBackgroundImage:[self colorToImage:[[UIColor blackColor] colorWithAlphaComponent:0.5]] forState:UIControlStateHighlighted];
        [_albumBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _albumBtn;
}


#pragma mark - 颜色转图片
-(UIImage*)colorToImage:(UIColor*)color{
    CGRect newRect = CGRectMake(0.0, 0.0, 1.0, 1.0);
    UIGraphicsBeginImageContext(newRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, newRect);
    UIImage* theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

-(UIImageView *)leftTopImage{
    if (!_leftTopImage) {
        _leftTopImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LYSQRCode.bundle/QRCodeLeftTop"]];
    }
    return _leftTopImage;
}

-(UIImageView *)rightTopImage{
    if (!_rightTopImage) {
        _rightTopImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LYSQRCode.bundle/QRCodeRightTop"]];
    }
    return _rightTopImage;
}


-(UIImageView *)leftBottomImage{
    if (!_leftBottomImage) {
        _leftBottomImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LYSQRCode.bundle/QRCodeLeftBottom"]];
    }
    return _leftBottomImage;
}


-(UIImageView *)rightBottomImage{
    if (!_rightBottomImage) {
        _rightBottomImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LYSQRCode.bundle/QRCodeRightBottom"]];
    }
    return _rightBottomImage;
}

-(UIImageView*)scanLine{
    if (!_scanLine) {
        _scanLine = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LYSQRCode.bundle/QRCodeScanningLine"]];
    }
    return _scanLine;
}

#pragma mark - 开灯按钮被点击
-(void)btnClicked:(UIButton*)sender{
    if (self.lightBtn == sender) {
        [self turnOnLight:!sender.selected];
        sender.selected = !sender.selected;
    }else{
        if (self.ReadFromAlbumBlock) {
            self.ReadFromAlbumBlock();
        }
    }
}

#pragma mark - 区域
-(CGRect)rectOfInterest{
    CGFloat width = (self.frame.size.width - 2 * self.scanX) / CGRectGetHeight(self.frame);
    CGFloat height = (self.frame.size.width - 2 * self.scanX) / CGRectGetWidth(self.frame);
    CGFloat x = self.scanY / CGRectGetHeight(self.frame);
    CGFloat y = self.scanX/ CGRectGetWidth(self.frame);
    return CGRectMake(x, y, width, height);
}

#pragma mark - 开关灯
- (void)turnOnLight:(BOOL)on {
    AVCaptureDevice *_device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([_device hasTorch]) {
        [_device lockForConfiguration:nil];
        if (on) {
            [_device setTorchMode:AVCaptureTorchModeOn];
        } else {
            [_device setTorchMode: AVCaptureTorchModeOff];
        }
        [_device unlockForConfiguration];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat margin = 7;
    self.scanLayer.frame = CGRectMake(self.scanX, self.scanY, self.frame.size.width - 2 * self.scanX, self.frame.size.width - 2 * self.scanX);
    self.topLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.scanY);
    self.leftLayer.frame = CGRectMake(0, CGRectGetMaxY(self.topLayer.frame), self.scanX, CGRectGetHeight(self.scanLayer.frame));
    self.rightLayer.frame = CGRectMake(CGRectGetMaxX(self.scanLayer.frame), CGRectGetMaxY(self.topLayer.frame), self.scanX, CGRectGetHeight(self.leftLayer.frame));
    self.bottomLayer.frame = CGRectMake(0, CGRectGetMaxY(self.scanLayer.frame), self.frame.size.width, self.frame.size.height - CGRectGetMaxY(self.scanLayer.frame));
    self.tipLb.frame = CGRectMake(0, CGRectGetMaxY(self.scanLayer.frame) + 30.f, self.frame.size.width, 25);
    self.lightBtn.frame = CGRectMake(CGRectGetMinX(self.scanLayer.frame), CGRectGetMaxY(self.tipLb.frame) + 20.f, 60.f, 60.f);
    self.lightBtn.layer.cornerRadius = CGRectGetHeight(self.lightBtn.frame) / 2;
    self.albumBtn.frame = CGRectMake(CGRectGetMaxX(self.scanLayer.frame) - 60.f, CGRectGetMaxY(self.tipLb.frame) + 20.f, 60.f, 60.f);
    self.albumBtn.layer.cornerRadius = CGRectGetHeight(self.albumBtn.frame) / 2;
    self.leftTopImage.frame = CGRectMake(CGRectGetMinX(self.scanLayer.frame) - self.leftTopImage.image.size.width * 0.5 +  margin, CGRectGetMinY(self.scanLayer.frame) - self.leftTopImage.image.size.height * 0.5 +  margin, self.leftTopImage.image.size.width, self.leftTopImage.image.size.height);
    self.rightTopImage.frame = CGRectMake(CGRectGetMaxX(self.scanLayer.frame) - self.rightTopImage.image.size.width * 0.5 - margin, CGRectGetMinY(self.leftTopImage.frame), self.rightTopImage.image.size.width,self.rightTopImage.image.size.height);
    self.leftBottomImage.frame = CGRectMake(CGRectGetMinX(self.leftTopImage.frame), CGRectGetMaxY(self.scanLayer.frame) - self.leftBottomImage.image.size.width * 0.5 - margin, self.leftBottomImage.image.size.width, self.leftBottomImage.image.size.height);
    self.rightBottomImage.frame = CGRectMake(CGRectGetMinX(self.rightTopImage.frame), CGRectGetMinY(self.leftBottomImage.frame), self.rightBottomImage.image.size.width, self.rightBottomImage.image.size.height);
    self.scanLine.frame = CGRectMake(CGRectGetMinX(self.scanLayer.frame) * 0.5, self.scanY, CGRectGetWidth(self.frame) - CGRectGetMinX(self.scanLayer.frame), self.scanLine.image.size.height);
}

@end
