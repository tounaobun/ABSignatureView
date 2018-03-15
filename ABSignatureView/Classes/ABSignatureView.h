//
//  ABSignatureView.h
//  Test
//
//  Created by Benson Tommy on 16/11/2017.
//  Copyright © 2017 Benson Tommy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SaveImageHandler)(void);

@interface ABSignatureView : UIView

@property (nonatomic, strong) UIColor *paintColor; // default to black
@property (nonatomic, assign) CGFloat lineWidth;    // default to 3.f

- (void)saveSignatureToAlbumWithCompletionHandler:(SaveImageHandler)handler;

- (BOOL)hasSigned; // 是否已签名

- (void)clear; // 清空签名

- (UIImage *)signatureImage;

@end
