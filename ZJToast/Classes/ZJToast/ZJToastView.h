//
//  ZJToastView.h
//  hospital
//
//  Created by 张子建 on 15/6/8.
//  Copyright (c) 2015年 LiuBin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    ZJToastViewShowStyleNormal,
    ZJToastViewShowStyleDark
}ZJToastViewShowStyle;

@interface ZJToastView : UIWindow


@property (nonatomic,strong) UIColor *toastBackGround;
@property (nonatomic,strong) UIColor *toastTextColor;

@property (nonatomic,assign) ZJToastViewShowStyle showStyle;

+(void)initializeBackgroundColor:(UIColor*)color;

+(id)sharedZJAlertView;

+(void)showLoading:(NSString *)text;

+(void)showStaut:(NSString *)text;

+(void)showStaut:(NSString *)text afterDelay:(NSTimeInterval)time;

+(void)dissMissToast;

@end

@interface ZJControllerForToast : UIViewController

@end
