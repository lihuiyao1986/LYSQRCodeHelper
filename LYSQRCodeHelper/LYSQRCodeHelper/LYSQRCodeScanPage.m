//
//  LYSQRCodeScanPage.m
//  LYSQRCodeHelper
//
//  Created by jk on 2017/4/21.
//  Copyright © 2017年 Goldcard. All rights reserved.
//

#import "LYSQRCodeScanPage.h"
#import <AVFoundation/AVFoundation.h>
#import "LYSQRCodeScanView.h"


@interface LYSQRCodeScanPage ()<AVCaptureMetadataOutputObjectsDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>


@property(nonatomic,strong)LYSQRCodeScanView *scanView;

@property(nonatomic,strong)AVCaptureSession *session;

@property(nonatomic,strong)AVCaptureMetadataOutput *output;

@property(nonatomic,strong)AVCaptureVideoPreviewLayer *previewLayer;

@end

@implementation LYSQRCodeScanPage

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.scanView];
    [self setupPreviewLayer];
}

#pragma mark - 设置预览层
-(void)setupPreviewLayer{
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self beginScan];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self endScan];
}

#pragma mark - 开始扫描
-(void)beginScan{
    [self.session startRunning];
    [self.scanView startAnim];
}

#pragma mark - 结束扫描
-(void)endScan{
    [self.session stopRunning];
    [self.scanView endAnim];
}

-(LYSQRCodeScanView*)scanView{
    if (!_scanView) {
        _scanView = [[LYSQRCodeScanView alloc]initWithFrame:self.view.bounds];
    }
    return _scanView;
}

#pragma mark - previewLayer
-(AVCaptureVideoPreviewLayer*)previewLayer{
    if (!_previewLayer) {
        _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _previewLayer.frame = self.view.layer.bounds;
    }
    return _previewLayer;
}

#pragma mark - 获取session
-(AVCaptureSession*)session{
    
    if (!_session) {
        // 1、获取摄像设备
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        // 2、创建输入流
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        
        // 5、初始化链接对象（会话对象）
        _session = [[AVCaptureSession alloc] init];
        
        // 高质量采集率
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
        
        // 5.1 添加会话输入
        [_session addInput:input];
        
        // 5.2 添加会话输出
        [_session addOutput:self.output];
        
        // 5、设置输出数据类型，需要将元数据输出添加到会话后，才能指定元数据类型，否则会报错
        // 设置扫码支持的编码格式(如下设置条形码和二维码兼容)
        self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code,  AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
        
    }
    
    return _session;
}

#pragma mark - 设置output
-(AVCaptureMetadataOutput*)output{
    if (!_output) {
        _output = [[AVCaptureMetadataOutput alloc] init];
        [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        _output.rectOfInterest = self.scanView.rectOfInterest;
    }
    return _output;
}

#pragma mark - - - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    // 0、扫描成功之后的提示音
    [self playSound:@"LYSQRCode.bundle/sound.caf"];
    
    // 1、如果扫描完成，停止会话
    [self endScan];
    
    // 3、设置界面显示扫描结果
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        if (self.ScanResultBlock) {
            self.ScanResultBlock(obj.stringValue);
        }
    }
}

#pragma mark - 播放声音
-(void)playSound:(NSString*)name{
    
    // 获取音效
    NSString *audioFile = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSURL *fileUrl = [NSURL fileURLWithPath:audioFile];
    
    // 1、获得系统声音ID
    SystemSoundID soundID = 0;
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallback, NULL);
    
    // 2、播放音频
    AudioServicesPlaySystemSound(soundID);
}

#pragma mark - 播放完成回调函数
void soundCompleteCallback(SystemSoundID soundID, void *clientData){
 
}
@end
