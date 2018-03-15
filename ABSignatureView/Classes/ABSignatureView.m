//
//  ABSignatureView.m
//  Test
//
//  Created by Benson Tommy on 16/11/2017.
//  Copyright © 2017 Benson Tommy. All rights reserved.
//

#import "ABSignatureView.h"

@interface ABSignatureView()

@property(nonatomic, strong) UIBezierPath *bezier;
@property (nonatomic, strong) NSMutableArray<UIBezierPath *> *allLines;

@end

@implementation ABSignatureView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    self.allLines = @[].mutableCopy;
    self.lineWidth = 3.f;
    self.paintColor = [UIColor blackColor];
}

- (BOOL)hasSigned {
    return self.allLines.count > 0;
}

- (void)clear {
    [self.allLines removeAllObjects];
    [self setNeedsDisplay];
}

- (UIImage *)signatureImage {
    // 截屏
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // 截取画板尺寸
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    return newImage;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 贝塞尔曲线
    self.bezier = [UIBezierPath bezierPath];
    // 获取触摸的点
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    // 设置贝塞尔起点
    [self.bezier moveToPoint:point];
    // 存入线
    [self.allLines addObject:self.bezier];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [self.bezier addLineToPoint:point];
    //重绘界面
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
     [self.paintColor setStroke];
    for (UIBezierPath *path in self.allLines) {
        [path setLineWidth:self.lineWidth];
        [path stroke];
    }
}

- (void)saveSignatureToAlbumWithCompletionHandler:(SaveImageHandler)handler {
    UIImage *newImage = [self signatureImage];
    // 截图保存相册
    UIImageWriteToSavedPhotosAlbum(newImage, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)(handler));
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (!error) {
        SaveImageHandler handler = (__bridge SaveImageHandler)(contextInfo);
        !handler?:handler();
    }
}

@end
