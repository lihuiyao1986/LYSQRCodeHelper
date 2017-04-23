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
#import "UIImage+LYSQRCodeHelper.h"
#import "LYSAVRightHelper.h"


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
        __weak typeof (self)MyWeakSelf = self;
        _scanView = [[LYSQRCodeScanView alloc]initWithFrame:self.view.bounds];
        _scanView.ReadFromAlbumBlock = ^(){
            [MyWeakSelf pickerImageFromAlbum];
        };
    }
    return _scanView;
}

#pragma mark - 从相册中选择照片
-(void)pickerImageFromAlbum{
    __weak typeof (self)MyWeakSelf = self;
    if ([LYSAVRightHelper isCanUsePhotos:^{
        [MyWeakSelf toPickerImagePage];
    }]) {
        [MyWeakSelf toPickerImagePage];
    }
}

-(void)toPickerImagePage{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary; //（选择类型）表示仅仅从相册中选取照片
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark -  UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    __weak typeof (self)MyWeakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        [MyWeakSelf scanQRCodeFromPhotosInTheAlbum:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
    }];
}

- (void)scanQRCodeFromPhotosInTheAlbum:(UIImage *)image {
    // CIDetector(CIDetector可用于人脸识别)进行图片解析，从而使我们可以便捷的从相册中获取到二维码
    // 声明一个CIDetector，并设定识别类型 CIDetectorTypeQRCode
    if (image) {
        NSString *scanResult;
        image = [UIImage imageSizeWithScreenImage:image];
        CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
        // 取得识别结果
        NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
        if (features.count > 0) {
            CIQRCodeFeature *feature = [features objectAtIndex:0];
            scanResult = feature.messageString;
        }
        if (scanResult.length > 0) {
            
            [self playSound:@"LYSQRCode.bundle/sound.caf"];
            
            [self endScan];

            if (self.ScanResultBlock) {
                self.ScanResultBlock(scanResult);
            }
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"为识别的二维码");
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
    
    NSString * scanResult;
    
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        scanResult = obj.stringValue;
    }
    
    if (scanResult.length > 0) {
        
        [self playSound:@"LYSQRCode.bundle/sound.caf"];
        
        [self endScan];
        
        if (self.ScanResultBlock) {
            self.ScanResultBlock(scanResult);
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
